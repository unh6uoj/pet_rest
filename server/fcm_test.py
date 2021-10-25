from pyfcm import FCMNotification

APIKEY = 'AAAAdTN02mQ:APA91bE2ZilYBVvDYK5FcdtA88yDTzBpmP4a-hPt8yJ4d4s0sEj9QaW7umidMi7aKIYhEOKJGuEklhyYfqDJ-xB88L4pptnFPgS_9CKVfKBWqjoHhTzA1-SzbMsrUAJN_prplw-Yl0rb'
# TOKEN = 'ecejRQOp3kVvgTExOBLpfo:APA91bFtgCZhbGmEutsaNUrFLHx1WeGOasxrZeKMYl-63aZGGotJar976rSYOLC8_1x0eXaB4gnbqmpExzD4-GJ_KKH5a9sewakjuPeNj2FZi0VrRA6h79nSKK3Jyih9UlSxr8-IhSPZ'
TOKEN = 'eIi-ZTHsSRG5YDTiJt0ikq:APA91bGtVkNW3iA3meofbyfjmFXHmjrwa5bUSSV1ZMwVD6yYH--hTG93d36R6NpE3CIfbXEtnrLESZOAbEeUDh7CjCi7VQ9K9HoIr-4SE3dyEPRsXDuk2Q9XC5PhB0K5YvKEXkuwIgmS'

push_service = FCMNotification(APIKEY)


def sendMessage(body, title):
    result = push_service.notify_single_device(
        registration_id=TOKEN, message_title=title, message_body=body)

    print(result)


sendMessage('테스트', '테스트 타이틀')
