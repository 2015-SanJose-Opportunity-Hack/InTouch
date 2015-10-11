'''
Created on Oct 4, 2015

@author: npedemane
'''
import json,httplib
from twilio.rest import TwilioRestClient

def sendNotifications_toTwilio(to_phone,from_phone,notif_type='call'):
    
    account_sid = 'ACfd5e8f974b65ff2f742326786bd60b77'
    auth_token  = "f2026f0a015ada5921c9b9f2976545b7"
    client = TwilioRestClient(account_sid, auth_token) 
 
    if notif_type is 'call':
        notif = client.calls.create(to=to_phone, from_=from_phone, url="https://demo.twilio.com/welcome/voice/",method="GET",fallback_method="GET", status_callback_method="GET", record="false") 
    else:
        notif = client.messages.create(to=to_phone, from_=from_phone, body="hi")
           
    print notif.sid
        
def sendNotifications_toParse(category_text):
    connection = httplib.HTTPSConnection('api.parse.com', 443)
    connection.connect()
    connection.request('POST', '/1/push', json.dumps({
       "where": {
                 "deviceToken" : "894b855bdba063f4a67d16c7ee14f6305adbe16c8b7ac61235267a8546ad5ec7"
       },
       "data": {
         "alert": "Did you Wake Up smarty?",
         "category": "inTouchCategory",
         "taskId":"hMGqP0lLzy"
       }
     }), {
       "X-Parse-Application-Id": "NhJGrdxkmmGolldGpNjToTZY009P6DdNEgGYVl3J",
       "X-Parse-REST-API-Key": "BKZBC6fP97Ttf5gCcpESVuu4vnXan32xEB2nM84D",
       "Content-Type": "application/json"
     })
    result = json.loads(connection.getresponse().read())
    print result
    
def getRespondedStatus(task="Wake Up"):   
    connection = httplib.HTTPSConnection('api.parse.com', 443)
    connection.connect()
    connection.request('GET', '/1/classes/Task', '', {
       "X-Parse-Application-Id": "NhJGrdxkmmGolldGpNjToTZY009P6DdNEgGYVl3J",
       "X-Parse-REST-API-Key": "BKZBC6fP97Ttf5gCcpESVuu4vnXan32xEB2nM84D"
     })
    result = json.loads(connection.getresponse().read())
    r = result.get('results')
    responded = (item for item in r if item["name"] == 'Wake Up').next().get('responded')
    return responded
    
if __name__ == '__main__':
    getRespondedStatus(task="Wake Up")