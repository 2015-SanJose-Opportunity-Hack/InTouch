'''
Created on Oct 4, 2015

@author: vkhamker
'''

def predict_wake_up_using_rules(feature_vector):
    if feature_vector[0] > 10:
        if feature_vector[1] < 5.0:
            if feature_vector[2] < 5.0:
                if feature_vector[3] < 5.0:
                    if feature_vector[4] < 5.0:
                        if feature_vector[5] < 5.0:
                            if feature_vector[6] < 5.0:
                                return 1
        
    return 0
    

if __name__ == '__main__':
    pass