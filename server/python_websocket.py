import asyncio
import websockets

import cv2


async def accept(websocket, path):
    cap = cv2.VideoCapture(0)

    data_rcv = await websocket.recv()
    print("received data: ", data_rcv)

    while True:
        ret, frame = cap.read()
####


        encode_param = [int(cv2.IMWRITE_JPEG_QUALITY), 60]
        encoded_frame = cv2.imencode('.jpg', frame, encode_param)[1].tobytes()

        await websocket.send(encoded_frame)

websoc_svr = websockets.serve(accept, "0.0.0.0", "25001")

# waiting
asyncio.get_event_loop().run_until_complete(websoc_svr)
asyncio.get_event_loop().run_forever()
