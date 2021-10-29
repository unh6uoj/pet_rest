from gpiozero import Servo, Motor
import time
import asyncio
import websockets


async def accept(websocket, path):
    # Motor 초기 설정
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

        # 밥 주기
        if data_rcv == "food":
            food_motor.forward()
            time.sleep(2)
            food_motor.stop()

        # 물 주기
        elif data_rcv == "water":
            water_servo.value = 0.6
            time.sleep(1)
            water_servo.value = -0.2
            time.sleep(1)

        # 공 던지기
        elif data_rcv == "ball":
            ball_motor1.forward()
            ball_motor2.backward()
            time.sleep(1)
            ball_servo.value = 0.6
            time.sleep(1)
            ball_servo.value = -0.2
            time.sleep(1)
            ball_motor1.stop()
            ball_motor2.stop()

        # 운동량 조회하기
        else:
            pass


websoc_svr = websockets.serve(accept, "0.0.0.0", "25001")

# waiting
asyncio.get_event_loop().run_until_complete(websoc_svr)
asyncio.get_event_loop().run_forever()
