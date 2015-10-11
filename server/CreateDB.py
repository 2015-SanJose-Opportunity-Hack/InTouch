'''
Created on Oct 3, 2015

@author: npedemane
'''

import sqlite3

sqlite_file = 'sensor_data.sqlite'    # name of the sqlite database file
table_name = 'sensor'    # name of the table to be created
 
# Connecting to the database file
conn = sqlite3.connect(sqlite_file)
c = conn.cursor()

# Creating a second table with 1 column and set it as PRIMARY KEY
# note that PRIMARY KEY column must consist of unique values!
c.execute('CREATE TABLE {tn} ({nf1} {ft1},{nf2} {ft2}, {nf3} {ft3}, {nf4} {ft4}, PRIMARY KEY({nf1},{nf2}))'.format(tn=table_name, nf1='USERID', ft1='TEXT',nf2='DATA_TS', ft2='INTEGER',nf3='AGG_GYRO_VAL',ft3='REAL',nf4='AGG_ACCEL_VAL',ft4='REAL'))

# Committing changes and closing the connection to the database file
conn.commit()
conn.close()
