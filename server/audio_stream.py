import asyncio
import websockets

import pyaudio

# async def accept(websocket, path):
#     data_rcv = await websocket.recv()
#     print("received data: ", data_rcv)

#     await websocket.send('보낼 값')

# websoc_svr = websockets.serve(accept, "0.0.0.0", "25002")

# # waiting
# asyncio.get_event_loop().run_until_complete(websoc_svr)
# asyncio.get_event_loop().run_forever()

audio = pyaudio.PyAudio()

for index in range(audio.get_device_count()):
    desc = audio.get_device_info_by_index(index)
    print("DEVICE: {device}, INDEX: {index}, RATE: {rate} ".format(
        device=desc["name"], index=index, rate=int(desc["defaultSampleRate"])))
