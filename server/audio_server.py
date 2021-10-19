# import asyncio
# import websockets

import pyaudio
import numpy as np

CHUNK = 2**10
RATE = 44100

# async def accept(websocket, path):
#     data_rcv = await websocket.recv()
#     print("received data: ", data_rcv)

#     await websocket.send('보낼 값')

# websoc_svr = websockets.serve(accept, "0.0.0.0", "25002")

# # waiting
# asyncio.get_event_loop().run_until_complete(websoc_svr)
# asyncio.get_event_loop().run_forever()

audio = pyaudio.PyAudio()

# stream = audio.open(format=pyaudio.paInt16, channels=1, rate=RATE, input=True,
#                     frames_per_buffer=CHUNK, input_device_index=2)

# while(True):
#     data = np.fromstring(stream.read(CHUNK), dtype=np.int16)
#     print(int(np.average(np.abs(data))))

# stream.stop_stream()
# stream.close()
# p.terminate()


for index in range(audio.get_device_count()):
    desc = audio.get_device_info_by_index(index)
    print("DEVICE: {device}, INDEX: {index}, RATE: {rate} ".format(
        device=desc["name"], index=index, rate=int(desc["defaultSampleRate"])))
