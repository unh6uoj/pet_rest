from pyfcm import FCMNotification

APIKEY = 'AAAAdTN02mQ:APA91bE2ZilYBVvDYK5FcdtA88yDTzBpmP4a-hPt8yJ4d4s0sEj9QaW7umidMi7aKIYhEOKJGuEklhyYfqDJ-xB88L4pptnFPgS_9CKVfKBWqjoHhTzA1-SzbMsrUAJN_prplw-Yl0rb'
TOKEN = ''

push_service = FCMNotification(APIKEY)


def sendMessage(body, title):
    data_message = {
        "body": body,
        "title": title
    }

    result = push_service.single_device_data_message(
        restricted_package_name=TOKEN, data_message=data_message)

    print(result)


sendMessage('테스트', '테스트 타이틀')
