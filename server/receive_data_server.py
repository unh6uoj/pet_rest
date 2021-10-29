import time
import asyncio
import websockets
from hx711 import HX711
import sys


class ServeData():
    def __init__(self):
        # loadcell 초기 설정
        self.loadcell = HX711(5, 6)
        self.loadcell.set_reading_format("MSB", "MSB")
        self.loadcell.set_reference_unit(1)
        self.loadcell.reset()
        self.loadcell.tare()

        print('loadcell initailize done')

        # laser 초기 설정

    # loadcell 오류 시 실행
    def loadcell_clean(self):
        print('cleaning...')

        GPIO.cleanup()

        print('clean done!')
        sys.exit()

    def get_loadcell_data(self):
        try:
            result = self.loadcell.get_weight(5)
            print(result)
            self.loadcell.power_down()
            self.loadcell.power_up()
            time.sleep(0.1)
        except:
            self.loadcell_clean()

        return result

    def accept(self):
        while True:
            server.get_loadcell_data()
            time.sleep(1)


server = ServeData()

websoc_svr = websockets.serve(server.accept, "0.0.0.0", "25001")

# waiting
asyncio.get_event_loop().run_until_complete(websoc_svr)
asyncio.get_event_loop().run_forever()
