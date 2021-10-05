from gpiozero import Servo, Motor
import time

import asyncio
import websockets

async def accept(websocket, path):
    print("init")
    
    geared = Motor(20, 16)
    servo = Servo(17)
    
    while True:
        try:
            print('wait...')
            data_rcv = await websocket.recv()
            print(data_rcv)
        except:
            print('error')

        if data_rcv == "food":
            geared.forward()
            time.sleep(2)
            geared.stop()
        
        elif data_rcv == "water":
            servo.value = 0.6
            time.sleep(1)
            servo.value = -0.2
            time.sleep(1)

websoc_svr = websockets.serve(accept, "0.0.0.0", "25003")

# waiting
asyncio.get_event_loop().run_until_complete(websoc_svr)
asyncio.get_event_loop().run_forever()