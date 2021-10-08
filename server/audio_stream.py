import asyncio
import websockets


async def accept(websocket, path):
    data_rcv = await websocket.recv()
    print("received data: ", data_rcv)

    await websocket.send('보낼 값')

websoc_svr = websockets.serve(accept, "0.0.0.0", "25002")

# waiting
asyncio.get_event_loop().run_until_complete(websoc_svr)
asyncio.get_event_loop().run_forever()
