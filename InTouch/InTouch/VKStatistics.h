//
//  VKStatistics.h
//  GyrosAndAccelerometers
//
//  Created by Khamker, Vandit on 10/3/15.
//  Copyright © 2015 Joe Hoffman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKStatistics : NSObject

- (double) get_euclidean_dist: (double)x1 comma: (double)y1 comma: (double) z1 with: (double)x2 comma: (double) y2 comma: (double) z2;

@end

