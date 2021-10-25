from gpiozero import Servo, Motor
import time
import asyncio
import websockets


async def accept(websocket, path):
    print("init")

    # Motor Pins
    food_motor = Motor(20, 16)
    water_servo = Servo(17)
    ball_motor1 = Motor(1, 2)
    ball_motor2 = Motor(3, 4)
    ball_servo = Servo(5)

    while True:
        try:
            print('wait...')
            data_rcv = await websocket.recv()
            print(data_rcv)
        except:
            print('error')

        if data_rcv == "food":
            food_motor.forward()
            time.sleep(2)
            food_motor.stop()

        elif data_rcv == "water":
            water_servo.value = 0.6
            time.sleep(1)
            water_servo.value = -0.2
            time.sleep(1)

        elif data_rcv == "ball":        # 테스트 해봐야 함...
            ball_motor1.forward()
            ball_motor2.backward()
            time.sleep(1)
            ball_servo.value = 0.6
            time.sleep(1)
            water_servo.value = -0.2
            time.sleep(1)
            ball_motor1.stop()
            ball_motor2.stop()

websoc_svr = websockets.serve(accept, "0.0.0.0", "25001")

# waiting
asyncio.get_event_loop().run_until_complete(websoc_svr)
asyncio.get_event_loop().run_forever()
