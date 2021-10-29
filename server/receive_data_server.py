import time
import asyncio
import websockets
import board
import busio
import RPi.GPIO as GPIO
import adafruit_vl53l0x
from hx711 import HX711


class ServeData():
    def __init__(self):
        # loadcell 초기 설정
        self.food_loadcell = HX711(5, 6)
        self.water_loadcell = HX711(7, 8)

        # 레이저 초기 설정
        i2c = busio.I2C(board.SCL, board.SDA)
        self.ball_sensor = adafruit_vl53l0x.VL53L0X(i2c)

    def get_loadcell_data(self):
        try:
            food_amount = self.food_loadcell.get_raw_data(1)[0]
            water_amount = self.water_loadcell.get_raw_data(1)[0]
            
        finally:
            GPIO.cleanup()

        # ##### 보정하기

        return food_amount, water_amount

    def get_laser_data(self):
        distance = self.ball_sensor.range / 10

        # ######################보정 계수 적용할 것

        if distance < 1:
            return True
        return False

<<<<<<< HEAD
    def accept(self):
        while True:
            self.get_loadcell_data()
            self.get_laser_data()
            time.sleep(1)
=======

def accept(websocket, path):
    while True:
        a = websocket.recv()
        'AA'
        server.get_loadcell_data()
        time.sleep(1)
>>>>>>> 89dbceb2b5d7ac616611b3a4fec8293a9a7bacfc


server = ServeData()

websoc_svr = websockets.serve(server.accept, "0.0.0.0", "25002")

# waiting
asyncio.get_event_loop().run_until_complete(websoc_svr)
asyncio.get_event_loop().run_forever()
