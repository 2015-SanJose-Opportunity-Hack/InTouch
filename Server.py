'''
Created on Oct 3, 2015

@author: npedemane
'''
from flask import Flask
from flask import request,abort
import sqlite3
from OpenSSL import SSL

app = Flask(__name__)

def trigger():
    #for every user in the d
    pass

def connect_to_db():
    conn = sqlite3.connect('sensor_data.sqlite')
    c = conn.cursor()
    return c,conn

@app.route('/hotv/api/v1.0/metrics', methods=['POST'])
def insert_row():
    if not request.json:
        abort(400)
        print 'request not json'
    cur,conn = connect_to_db()
    agg_acc = request.json['acc']
    agg_gyro = request.json['gyr']
    user_id = request.json['user_id']
    timestamp = request.json['timestamp']
    cur.execute('SELECT * FROM {tn}'.format(tn='sensor'))
    cur.execute("INSERT INTO sensor VALUES (?, ?, ?, ?);",(user_id,timestamp,agg_gyro,agg_acc))  
    #,val1=user_id,val2=int(timestamp),val3=float(agg_gyro),val4=float(agg_acc)
    conn.commit()
    conn.close()
    return 'success'

@app.route('/')
def home():
    '''
    c.execute("INSERT INTO {tn} ({cn1}, {cn2}, {cn3}, {cn4}) VALUES ('U1', 12345,1,2)".format(tn='sensor', cn1='USERID', cn2='DATA_TS', cn3='AGG_GYRO_VAL', cn4='AGG_ACCEL_VAL'))
    c.execute('SELECT * FROM {tn}'.format(tn='sensor'))
    print c.fetchall()
    '''
    return "Heart Of the Valley"

if __name__ == '__main__':
    #context = ('ssl.cert', 'ssl.key')
    app.run(host="0.0.0.0",port=5000)
    #app.run(host="0.0.0.0",port=5000, ssl_context=context, threaded=True, debug=True)
