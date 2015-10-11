//
//  VKStatistics.m
//  GyrosAndAccelerometers
//
//  Created by Khamker, Vandit on 10/3/15.
//  Copyright © 2015 Joe Hoffman. All rights reserved.
//

#import "VKStatistics.h"

@implementation VKStatistics



- (double) get_euclidean_dist: (double)x1 comma: (double)y1 comma: (double) z1 with: (double)x2 comma: (double) y2 comma: (double) z2{
    
    double distance = ({double d1 = x1 - x2, d2 = y1 - y2, d3 = z1-z2;sqrt(d1 * d1 + d2 * d2 + d3*d3); });
    return distance;

}


@end
