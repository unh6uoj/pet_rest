import asyncio
import websockets
import os
try:
    import tflite_runtime.interpreter as tflite
except:
    import tensorflow.lite as tflite
import cv2
import numpy as np
import time

# 동영상 설정
FRAME_W = 800
FRAME_H = 600

# tensorflow 정확도 최소값
CONFIDENCE_THRESHOLD = 0.5

print("server on!")


async def get_recv_data(websocket):
    return websocket.recv()


async def accept(websocket, path):
    cap = cv2.VideoCapture(0)
    cap.set(3, FRAME_W)
    cap.set(4, FRAME_H)

    model = tflite.Interpreter(model_path=os.path.dirname(
        os.path.realpath(__file__)) + '/model/video_model.tflite')
    model.allocate_tensors()
    input_details = model.get_input_details()
    output_details = model.get_output_details()

    while True:
        data_rcv = await websocket.recv()
        print("received data: ", data_rcv)
        while data_rcv == 'on':
            # data_rcv = get_recv_data(websocket)

            if data_rcv == 'off':
                break

            _, frame = cap.read()
            img_tensor = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

            cv2.imshow("test", frame)
            cv2.waitKey(1)

            origin_h, origin_w, _ = frame.shape
            img_tensor = cv2.resize(
                img_tensor, (input_details[0]['shape'][2], input_details[0]['shape'][1]))
            input_data = np.expand_dims(img_tensor, axis=0)
            model.set_tensor(input_details[0]['index'], input_data)

            start_time = time.time()
            model.invoke()
            end_time = time.time()
            detection_time = round(end_time - start_time, 2)
            print("사진 인식 소요 시간 : " + str(detection_time) + "초")

            boxes = model.get_tensor(output_details[0]['index'])[0]
            classes = model.get_tensor(output_details[1]['index'])[0]
            scores = model.get_tensor(output_details[2]['index'])[0]
            count = model.get_tensor(output_details[3]['index'])[0]

            result = []

            # 객체 개수만큼 반복
            for i in range(int(count)):
                # 정확도가 지정한 범위 안에 있을 때
                if (scores[i] > CONFIDENCE_THRESHOLD) and int(classes[i]) == 17:
                    # 객체 테두리 좌표 저장(텐서플로우 이미지용 좌표를 원본 이미지용 좌표로 변환)
                    y_min = str(int(max(1, (boxes[i][0] * origin_h))))
                    x_min = str(int(max(1, (boxes[i][1] * origin_w))))
                    y_max = str(int(min(origin_h, (boxes[i][2] * origin_h))))
                    x_max = str(int(min(origin_w, (boxes[i][3] * origin_w))))
                    print("detection rate : " + str(scores[i]))

                    # 탐지 결과 리스트에 추가
                    result.append([x_min, y_min, x_max, y_max])

            encode_param = [int(cv2.IMWRITE_JPEG_QUALITY), 60]
            encoded_frame = cv2.imencode(
                '.jpg', frame, encode_param)[1].tobytes()

            await websocket.send([encoded_frame, result])

websoc_svr = websockets.serve(accept, "0.0.0.0", "25005")

# waiting
asyncio.get_event_loop().run_until_complete(websoc_svr)
asyncio.get_event_loop().run_forever()
