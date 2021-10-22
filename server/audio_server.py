import pyaudio
import numpy as np
import librosa
import tflite_runtime.interpreter as tflite
# from pyfcm import FCMNotification


APIKEY = "Your Server Key"
TOKEN = "Your Token"

class Audio():
    # 초기화
    def __init__(self):
        # 마이크 관련 변수
        self.audio = pyaudio.PyAudio()
        self.mic_index = 0
        self.mic_rate = 0
        self.mic_chunk = 2048

        # 텐서플로우 관련 변수
        self.model = tflite.Interpreter(r'C:\Users\User\VS_workspace\pet_rest\server\model\model.tflite')
        self.model.allocate_tensors()
        self.model_rate = 16000
        self.input_details = self.model.get_input_details()
        self.output_details = self.model.get_output_details()

        # fcm 관련 변수
        # self.push_service = FCMNotification(APIKEY)

    # 최적의 마이크 찾기
    def find_best_mic(self):
        for index in range(self.audio.get_device_count()):
            desc = self.audio.get_device_info_by_index(index)

            if desc["maxInputChannels"] == 1 and 44000 < desc["defaultSampleRate"] <= 48000:
                self.mic_index = index
                self.mic_rate = int(desc["defaultSampleRate"])
                print(desc["name"]+"을(를) 사용합니다!")
                return True

        print("사용할 수 있는 마이크를 찾을 수 없습니다.")
        return False

    # # 메세지 전송하기
    # def send_message(self):
    #     data_message = {"body": "펫터레스트", "title": "개가 짖었습니다!"}
    #     push_result = self.push_service.single_device_data_message(
    #         registration_id=TOKEN, data_message=data_message)
    #     print(push_result)

    # 오디오 큐 시작하기
    def start_audio_queue(self):
        stream = self.audio.open(format=pyaudio.paInt16, channels=1, rate=self.mic_rate, input=True,
                                 frames_per_buffer=self.mic_chunk, input_device_index=self.mic_index)

        audio_queue = np.array([])

        while True:
            stream_data = np.fromstring(
                stream.read(self.mic_chunk), dtype=np.int16)
            audio_queue = np.append(audio_queue, stream_data)

            if audio_queue.shape[0] > self.mic_rate * 10.9:
                audio_queue = np.delete(audio_queue, 0, axis=0)

            # 1초 이상 데이터가 모이면 음성 인식
            if audio_queue.shape[0] > self.mic_rate * 1.0:
                result = self.bark_detection(audio_queue)
                if result:
                    stream.stop_stream()
                    stream.close()

    # 개 짖음 인식하기
    def bark_detection(self, audio_queue):
        # 음성 데이터 전처리
        resample_queue = librosa.resample(
            audio_queue, self.mic_rate, self.model_rate)
        data_pad = np.hstack((resample_queue, np.zeros(
            int(self.model_rate*10.99))[resample_queue.shape[0]:]))
        melspec = librosa.feature.melspectrogram(
            data_pad, sr=16000, n_fft=512, hop_length=160, n_mels=64) #  win_length=400
        audio_mel = np.expand_dims(
            librosa.power_to_db(melspec, ref=np.max), -1)[np.newaxis].astype('float32')

        # 음성 데이터 예측하기
        self.model.set_tensor(self.input_details[0]['index'], audio_mel)
        self.model.invoke()
        output_data = self.model.get_tensor(self.output_details[0]['index'])[0]

        # 결과 출력하기
        print(output_data)

        if output_data[0] > output_data[2] and output_data[0] > 0.3:
            print("개")
        else:
            print("...")
        # print(np.argmax(output_data))

        # # 개 짖음을 인식했을 때
        # if np.max(output_data) > 0.8 and np.argmax(output_data) == 0:
        #     print("개가 짖었습니다!")
        #     return True
        return False

    # 종료
    def __del__(self):
        self.audio.terminate()


# 메인 함수
def main():
    audio = Audio()
    if audio.find_best_mic():
        audio.start_audio_queue()


main()
