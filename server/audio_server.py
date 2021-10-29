from pyfcm import FCMNotification
import time
import librosa
import numpy as np
import pyaudio
import os
import warnings
warnings.filterwarnings(action='ignore')
try:
    import tflite_runtime.interpreter as tflite
except:
    import tensorflow.lite as tflite


APIKEY = 'AAAAdTN02mQ:APA91bE2ZilYBVvDYK5FcdtA88yDTzBpmP4a-hPt8yJ4d4s0sEj9QaW7umidMi7aKIYhEOKJGuEklhyYfqDJ-xB88L4pptnFPgS_9CKVfKBWqjoHhTzA1-SzbMsrUAJN_prplw-Yl0rb'
TOKEN = 'eIi-ZTHsSRG5YDTiJt0ikq:APA91bGtVkNW3iA3meofbyfjmFXHmjrwa5bUSSV1ZMwVD6yYH--hTG93d36R6NpE3CIfbXEtnrLESZOAbEeUDh7CjCi7VQ9K9HoIr-4SE3dyEPRsXDuk2Q9XC5PhB0K5YvKEXkuwIgmS'


class Audio():
    # 초기화
    def __init__(self):
        # 마이크 관련 변수
        self.audio = pyaudio.PyAudio()
        self.mic_index = 0
        self.mic_rate = 0
        self.mic_chunk = 512

        # 텐서플로우 관련 변수
        self.model = tflite.Interpreter(model_path=os.path.dirname(
            os.path.realpath(__file__)) + '/model/audio_model.tflite')
        self.model.allocate_tensors()
        self.model_rate = 16000
        self.input_details = self.model.get_input_details()
        self.output_details = self.model.get_output_details()

        # fcm 관련 변수
        self.push_service = FCMNotification(APIKEY)

    # 최적의 마이크 찾기
    def find_best_mic(self):
        for index in range(self.audio.get_device_count()):
            desc = self.audio.get_device_info_by_index(index)

            if desc["maxInputChannels"] == 1 and 44000 < desc["defaultSampleRate"] <= 48000:
                self.mic_index = index
                self.mic_rate = desc["defaultSampleRate"]
                os.system('clear')
                print(desc["name"]+"을(를) 사용합니다!")
                return True

        os.system('clear')
        print("사용할 수 있는 마이크를 찾을 수 없습니다.")
        return False

    # 메세지 전송하기
    def sendMessage(self):
        result = self.push_service.notify_single_device(
            registration_id=TOKEN, message_title="펫터레스트", message_body="개가 짖었습니다!")
        print(result)

    # 오디오 큐 시작하기
    def start_audio_queue(self):
        stream = self.audio.open(format=pyaudio.paInt16, channels=1, rate=int(self.mic_rate), input=True,
                                 frames_per_buffer=self.mic_chunk, input_device_index=self.mic_index)

        audio_queue = np.array([])

        while True:
            stream_data = np.fromstring(
                stream.read(self.mic_chunk, exception_on_overflow=False), dtype=np.int16)
            audio_queue = np.append(audio_queue, stream_data)

            # 1.5초 이상 데이터가 모이면 음성 인식
            if audio_queue.shape[0] / self.mic_rate > 1.5:
                result, detection_time = self.bark_detection(audio_queue)
                # 객체 탐지에 걸린 시간만큼 큐 비우기
                audio_queue = audio_queue[round(
                    self.mic_rate * detection_time):]
                if result:
                    self.sendMessage()
                    # stream 10초간 멈추기
                    audio_queue = np.array([])
                    stream.stop_stream()
                    time.sleep(10)
                    stream.start_stream()

    # 개 짖음 인식하기
    def bark_detection(self, audio_queue):
        # 음성 데이터 전처리
        resample_queue = librosa.resample(
            audio_queue, self.mic_rate, self.model_rate)
        data_pad = np.hstack((resample_queue, np.zeros(
            int(self.model_rate*1.5))[resample_queue.shape[0]:]))
        pad_overflow = data_pad.shape[0] - int(self.model_rate*1.5)
        if pad_overflow > 0:
            data_pad = data_pad[pad_overflow:]
        melspec = librosa.feature.melspectrogram(
            data_pad, sr=16000, n_fft=512, win_length=400, hop_length=160, n_mels=64)
        audio_mel = np.expand_dims(
            librosa.power_to_db(melspec, ref=np.max), -1)[np.newaxis].astype('float32')

        # 음성 데이터 예측하기
        self.model.set_tensor(self.input_details[0]['index'], audio_mel)
        past_time = time.time()
        self.model.invoke()
        current_time = time.time()
        detection_time = round(current_time - past_time, 2)
        print("음성 인식 소요 시간 : " + str(detection_time) + "초")
        output_data = self.model.get_tensor(self.output_details[0]['index'])[0]

        if output_data[0] > 0.0001:
            print("dog bark!!")
            return True, detection_time

        return False, detection_time

    # 종료
    def __del__(self):
        self.audio.terminate()


# 메인 함수
def main():
    audio = Audio()
    if audio.find_best_mic():
        audio.start_audio_queue()

if __name__ == '__main__':
    main()