'''
Created on Oct 4, 2015

@author: vkhamker
'''
import model_core
import optparse    
import time
import Notifications
from threading import Timer
from job_scheduler import schedule_job


def __make_opt_parser():
    parser = optparse.OptionParser("usage: %prog user_id ")
    return parser

def should_send_question(raw_data,event_type):
    #get model Value
    score = model_core.predict_wake_up(raw_data)
    
    #based on rule, decide whether to trigger notification or not
    if score == 1:
        return True
    return False

def send_question(raw_data,event_type):
    #TODO call parse to ask the relevant question
    print "Asking question to user...."
    Notifications.sendNotifications_toParse("")

def send_alarm(raw_data,event_type):
    print "sending alarm to caregiver"
    Notifications.sendNotifications_toTwilio('9198154800',"9198154800")

def should_send_alarm():
    print "checking response status"
    status = Notifications.getRespondedStatus()
    if status==False:
        send_alarm("", "")
        
def should_schedule_for_next_day():
    return False

if __name__ == '__main__':
    #trigger model
    parser = __make_opt_parser()
    (options,args) = parser.parse_args()
    ts = time.time()
    event_type =args[1]
    raw_data = {"user_id":args[0],"timestamp":ts}
    #send_question("", "")
    if should_send_question(raw_data,event_type):
        send_question(raw_data,event_type)
        t = Timer(60*1/12, should_send_alarm) #after 15 mins
        t.start()
    if should_schedule_for_next_day():
        schedule_job("wake_up_classify", args[0], ts+24*60*60*1000)
    
    #print "done"