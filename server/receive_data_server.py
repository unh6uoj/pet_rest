import time
import asyncio
import websockets
import board
import busio
import adafruit_vl53l0x
from hx711 import HX711
import numpy as np
import os
try:
    import tflite_runtime.interpreter as tflite
except:
    import tensorflow.lite as tflite
import cv2
import csv    


# 동영상 설정
FRAME_W = 800
FRAME_H = 600

# tensorflow 정확도 최소값
CONFIDENCE_THRESHOLD = 0.5


class ImageData():
    def __init__(self):
        self.cap = cv2.VideoCapture(0)
        self.cap.set(3, FRAME_W)
        self.cap.set(4, FRAME_H)

        self.model = tflite.Interpreter(model_path=os.path.dirname(
            os.path.realpath(__file__)) + '/model/video_model.tflite')
        self.model.allocate_tensors()
        self.input_details = self.model.get_input_details()
        self.output_details = self.model.get_output_details()

        self.before_time = 0
        self.before_points = []

    def get_points(self):
        _, frame = self.cap.read()
        cv2.imwrite('./data/video.jpg', frame)
        self.before_time = time.time()
        img_tensor = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

        origin_h, origin_w, _ = frame.shape
        img_tensor = cv2.resize(
            img_tensor, (self.input_details[0]['shape'][2], self.input_details[0]['shape'][1]))
        input_data = np.expand_dims(img_tensor, axis=0)
        self.model.set_tensor(self.input_details[0]['index'], input_data)

        start_time = time.time()
        self.model.invoke()
        end_time = time.time()
        detection_time = round(end_time - start_time, 2)
        print("사진 인식 소요 시간 : " + str(detection_time) + "초")

        boxes = self.model.get_tensor(self.output_details[0]['index'])[0]
        classes = self.model.get_tensor(self.output_details[1]['index'])[0]
        scores = self.model.get_tensor(self.output_details[2]['index'])[0]
        count = self.model.get_tensor(self.output_details[3]['index'])[0]

        result = []
        best_confidence = 0

        # 객체 개수만큼 반복
        for i in range(int(count)):
            if (scores[i] > CONFIDENCE_THRESHOLD) and (int(classes[i]) == 17):
                if scores[i] > best_confidence:
                    best_confidence = scores[i]
                    y_min = str(int(max(1, (boxes[i][0] * origin_h))))
                    x_min = str(int(max(1, (boxes[i][1] * origin_w))))
                    y_max = str(int(min(origin_h, (boxes[i][2] * origin_h))))
                    x_max = str(int(min(origin_w, (boxes[i][3] * origin_w))))
                    print("detection rate : " + str(scores[i]))

                    result = [x_min, y_min, x_max, y_max]

        self.before_points = result
        return result

    def save_momentum(self):
        curr_time = time.localtime(time.time())
        curr_date = time.strftime('%Y-%m-%d', curr_time)
        curr_hour = int(curr_time.tm_hour)
        csv_read_data = []
        try:
            file_r = open('./data/' + str(curr_date) + '.csv', 'r', encoding='utf-8')
            csv_read_data = csv.reader(file_r)
            file_r.close()

        finally:
            file_w = open('./data/' + str(curr_date) + '.csv', 'w', encoding='utf-8', newline='')
            csv_w = csv.writer(file_w)
            if len(csv_read_data) >= curr_hour + 1:
                csv_read_data[curr_hour] += 56789
            else:
                csv_read_data.append([4567890987654])

            for line in csv_read_data:
                csv_w.writerow(line)
            
            file_w.close()


class ServeData():
    def __init__(self):
        # loadcell 초기 설정
        self.food_loadcell = HX711(5, 6)
        self.water_loadcell = HX711(7, 8)
        self.zero_weight = -40000       # 빈 통 무게
        self.max_weight = 2180000

        # 레이저 초기 설정
        i2c = busio.I2C(board.SCL, board.SDA)
        self.ball_sensor = adafruit_vl53l0x.VL53L0X(i2c)

        self.img_data = ImageData()

    def get_loadcell_data(self):
        try:
            food_amount = self.food_loadcell.get_raw_data(5)[0]
            water_amount = self.water_loadcell.get_raw_data(5)[0]
        except:
            print("err!!!")

        food_amount = round((food_amount - self.zero_weight) /
                            float(self.max_weight - self.zero_weight), 3)
        water_amount = round((water_amount - self.zero_weight) /
                             float(self.max_weight - self.zero_weight), 3)

        return food_amount, water_amount    # 0~1 사이의 실수

    def get_laser_data(self):
        distance = self.ball_sensor.range / 10

        if distance < 3.0:
            return True     # 공 있다
        return False        # 공 없다

    def get_momentum(self):
        return self.img_data.get_points()


async def accept(websocket, path):
    server = ServeData()
    while True:
        food_amount, water_amount = server.get_loadcell_data()
        ball = server.get_laser_data()
        send_data = [str(food_amount), str(water_amount), str(ball)]

        await websocket.send(send_data)


websoc_svr = websockets.serve(accept, "0.0.0.0", "25002")

# waiting
asyncio.get_event_loop().run_until_complete(websoc_svr)
asyncio.get_event_loop().run_forever()
