'''
Created on Oct 3, 2015

@author: vkhamker
'''
from feature_generator import generate_features
from model_classifier import predict_wake_up_using_rules
def fit():
    #TODO
    print "TODO"
def predict_wake_up(raw_data):
    feature_vector = generate_features(raw_data)
    pred = predict_wake_up_using_rules(feature_vector)
    return pred 
if __name__ == '__main__':
    
    raw_data = {'user_id':'john','timestamp':'56999999'}
    print predict_wake_up(raw_data)