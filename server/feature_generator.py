'''
Created on Oct 3, 2015

@author: vkhamker
'''
from Server import connect_to_db

def generate_features(raw_user_input):
    user_id = raw_user_input["user_id"]
    timestamp = raw_user_input["timestamp"]
    feature_vector = []
    feature_vector.append(generate_var_time_diff_since_last_activity(user_id, timestamp))
    #feature_vector.append(generate_time_diff_since_no_activity(user_id, timestamp))
    
    for k in [5,10,30]:
        feature_vector.append(generate_agg_accl_last_k_mins(user_id, timestamp, k))
        feature_vector.append(generate_agg_gyr_last_k_mins(user_id, timestamp, k))
    
    #vars - activity_last_5_mins, activity_last_10_mins, activity_last_30_mins
    #vars - time_diff_since_last_activity
    
    return feature_vector
    
def generate_time_diff_since_no_activity(user_id,timestamp):
    time_diff_in_secs =0.0
    cur,conn = connect_to_db()
    agg_gyro_val_threshold = 30.0
    agg_acc_val_threshold = 30.0
    #query = "SELECT MIN(%s-DATA_TS)/1000 FROM sensor WHERE USERID == %s AND DATA_TS < %s AND (AGG_GYRO_VAL >= %s OR AGG_ACCEL_VAL >= %s);"%(timestamp,user_id,timestamp,agg_gyro_val_threshold,agg_acc_val_threshold)
    cur.execute("SELECT MIN(?-DATA_TS)/60 FROM sensor WHERE UPPER(USERID) == UPPER(?) AND DATA_TS < ? AND (AGG_GYRO_VAL < ? AND AGG_ACCEL_VAL < ?);",(timestamp,user_id,timestamp,agg_gyro_val_threshold,agg_acc_val_threshold))
    rows = cur.fetchall()
    time_diff_in_secs = rows[0][0]
    if time_diff_in_secs == None:
        time_diff_in_secs = -1
    return time_diff_in_secs
def generate_agg_accl_last_k_mins(user_id,timestamp,k):
    agg_activity = 0;
    cur,conn = connect_to_db()
    agg_gyro_val_threshold = 3.0
    agg_acc_val_threshold = 3.0
    #query = 'SELECT SUM(AGG_ACCEL_VAL) FROM sensor WHERE USERID = ? AND DATA_TS > (?-?)*60*1000'
    cur.execute("SELECT SUM(AGG_ACCEL_VAL) FROM sensor where UPPER(USERID) == UPPER(?) AND DATA_TS BETWEEN ?-(?*60) AND ?;",(user_id,timestamp,k,timestamp))
    rows = cur.fetchall()
    agg_activity = rows[0][0]
    if agg_activity == None:
        agg_activity = -1
    return agg_activity
def generate_agg_gyr_last_k_mins(user_id,timestamp,k):
    agg_activity = 0;
    cur,conn = connect_to_db()
    agg_gyro_val_threshold = 3.0
    agg_acc_val_threshold = 3.0
    
    #query = 'SELECT SUM(AGG_ACCEL_VAL) FROM sensor WHERE USERID = ? AND DATA_TS > (?-?)*60*1000'
    cur.execute("SELECT SUM(AGG_GYRO_VAL) FROM sensor where UPPER(USERID) == UPPER(?) AND DATA_TS BETWEEN  ?-(?*60) AND ?;",(user_id,timestamp,k,timestamp))
    rows = cur.fetchall()
    agg_activity = rows[0][0]
    if agg_activity == None:
        agg_activity = -1
    return agg_activity

def generate_var_time_diff_since_last_activity(user_id,timestamp):
    time_diff_in_secs =0.0
    cur,conn = connect_to_db()
    agg_gyro_val_threshold = 3.0
    agg_acc_val_threshold = 3.0
    #query = "SELECT MIN(%s-DATA_TS)/1000 FROM sensor WHERE USERID == %s AND DATA_TS < %s AND (AGG_GYRO_VAL >= %s OR AGG_ACCEL_VAL >= %s);"%(timestamp,user_id,timestamp,agg_gyro_val_threshold,agg_acc_val_threshold)
    cur.execute("SELECT MIN(?-DATA_TS)/60 FROM sensor WHERE UPPER(USERID) == UPPER(?) AND DATA_TS < ? AND (AGG_GYRO_VAL >= ? OR AGG_ACCEL_VAL >= ?);",(timestamp,user_id,timestamp,agg_gyro_val_threshold,agg_acc_val_threshold))
    #cur.execute("SELECT * from sensor")
    rows = cur.fetchall()
    #print rows
    time_diff_in_secs = rows[0][0]
    if time_diff_in_secs == None:
        time_diff_in_secs = -1
    
    return time_diff_in_secs

if __name__ == '__main__':
    print generate_var_time_diff_since_last_activity('john','465640583')
    print generate_time_diff_since_no_activity('john','465640583')
    print generate_agg_accl_last_k_mins('john','465634459',1)
    print generate_agg_gyr_last_k_mins('john','465634459',1)
    data = {'user_id':'john','timestamp':'465634459'}
    print generate_features(data)