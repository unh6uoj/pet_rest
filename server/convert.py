import tensorflow as tf
import keras.backend as K


# 텐서플로우 보조 함수
def mish(x):
    return x * K.tanh(K.softplus(x))


model = tf.keras.models.load_model(
    r'C:\Users\User\VS_workspace\pet_rest\server\model\model_1.h5', custom_objects={'mish': mish})

print("model load!")

converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

print("model convert!")

with open(r'C:\Users\User\VS_workspace\pet_rest\server\model\model.tflite', 'wb') as f:
  f.write(tflite_model)

print("model save!")