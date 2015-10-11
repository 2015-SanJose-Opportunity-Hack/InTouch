'''
Created on Oct 4, 2015

@author: vkhamker
'''


import os
import datetime
import time

def schedule_job(job_name,user_id, schedule_timestamp):
    #newruntime = (datetime.datetime.now() + datetime.timedelta(minutes=5)).strftime("%H:%M %d.%m.%Y")
    schedule_timestamp = time.strftime('%Y-%m-%d %H:%M:%S', time.localtime(schedule_timestamp))
    #schedule_timestamp = schedule_timestamp.strftime("%H:%M %d.%m.%Y")
    command = 'echo " python %s %s" | at %s' %(job_name,user_id,schedule_timestamp)
    os.system(command)
    
if __name__ == '__main__':
    ts = time.time()
    #schedule_timestamp = (datetime.datetime.now() + datetime.timedelta(minutes=1)).strftime("%H:%M %d.%m.%Y")
    schedule_job("wake_up_classify", "John", ts)