//
//  ViewController.m
//  GyrosAndAccelerometers
//
//  Created by NSCookbook on 3/25/13.
//  Copyright (c) 2013 NSCookbook. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "ViewController.h"
#import "VKStatistics.h"



NSURLConnection *conn;
NSMutableDictionary *deviation_data;
NSNumber *zero;
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    zero = [[NSNumber alloc]initWithDouble:0.0];
    
    currentAccelX = 0;
    
    currentAccelY = 0;
    currentAccelZ = 0;
    
    currentRotX = 0;
    currentRotY = 0;
    currentRotZ = 0;
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .2;
    self.motionManager.gyroUpdateInterval = .2;
    
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        [self outputAccelertionData:accelerometerData.acceleration];
                                                 if(error){
                                                     
                                                     NSLog(@"%@", error);
                                                 }
    }];
    
    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
                                        [self outputRotationData:gyroData.rotationRate];
                                    }];

    
    [NSTimer scheduledTimerWithTimeInterval:20.0
                                     target:self
                                   selector:@selector(sendDataToServer:)
                                   userInfo:nil
                                    repeats:YES];
    
    stats_calc = [[VKStatistics alloc]init];
    
    deviation_data = [[NSMutableDictionary alloc] initWithDictionary:@{@"acc":zero,@"gyr":zero}];
    
    NSLog(@"Done with init");
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    
    self.accX.text = [NSString stringWithFormat:@" %.2fg",acceleration.x];
    currentAccelX = acceleration.x;
    self.accY.text = [NSString stringWithFormat:@" %.2fg",acceleration.y];
    currentAccelY = acceleration.y;
    self.accZ.text = [NSString stringWithFormat:@" %.2fg",acceleration.z];
    currentAccelZ = acceleration.z;

    double deviation = [stats_calc get_euclidean_dist:previousAccelX comma:previousAccelY comma:previousAccelZ with:currentAccelX comma:currentAccelY comma:currentRotZ];
    //NSLog(@"Accelerometer deviation: %f ", deviation);
    NSNumber *tempNumber = [[NSNumber alloc] initWithDouble:deviation];
    deviation_data[@"acc"]  = [NSNumber numberWithFloat:([deviation_data[@"acc"] floatValue]+ [tempNumber floatValue])];
    
    self.maxAccX.text = [NSString stringWithFormat:@" %.2f",currentAccelX];
    self.maxAccY.text = [NSString stringWithFormat:@" %.2f",currentAccelY];
    self.maxAccZ.text = [NSString stringWithFormat:@" %.2f",currentAccelZ];
    previousAccelX = currentAccelX;
    previousAccelY = currentAccelY;
    previousAccelZ = currentAccelZ;

}



-(void) sendDataToServer:(NSTimer *)timer
{
    

    NSString *gyr = [deviation_data[@"gyr"] stringValue];
    NSString *acc = [deviation_data[@"acc"] stringValue];
    //NSString *user_id = deviation_data[@"user_id"];
    NSString *user_id = @"John";
    //NSDate *now = [NSDate date];
    //CFAbsoluteTime nowEpochSeconds = CFAbsoluteTimeGetCurrent();
    NSTimeInterval secondsSinceUnixEpoch = [[NSDate date]timeIntervalSince1970];
    NSString *epoch_time = [NSString stringWithFormat:@"%ld",(long int)(secondsSinceUnixEpoch)];
                           
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         gyr, @"gyr",
                         acc, @"acc",
                         user_id,@"user_id",
                         epoch_time,@"timestamp",
                         nil];
    NSError *error;
    NSData *postdata = [NSJSONSerialization dataWithJSONObject:tmp options:NSJSONWritingPrettyPrinted error:&error];
    
    //NSString *url = @"http://192.168.95.32:5000/hotv/api/v1.0/metrics";
    NSString *url = @"http://localhost:5000/hotv/api/v1.0/metrics";
    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc] initWithURL:
     [NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    /*
    [request setValue:[NSString
                       stringWithFormat:@"%d", (int)[postdata length]] forHTTPHeaderField:@"Content-length"];
  */
    
    [request setHTTPBody:postdata];
    NSLog(@"Request: %@",request);
    conn =[[NSURLConnection alloc] initWithRequest:request delegate:self];

    
}

-(void)outputRotationData:(CMRotationRate)rotation
{
    
    self.rotX.text = [NSString stringWithFormat:@" %.2fr/s",rotation.x];
    
        currentRotX = rotation.x;
    self.rotY.text = [NSString stringWithFormat:@" %.2fr/s",rotation.y];
    
        currentRotY = rotation.y;
    
    self.rotZ.text = [NSString stringWithFormat:@" %.2fr/s",rotation.z];
        currentRotZ = rotation.z;
    
    
    self.maxRotX.text = [NSString stringWithFormat:@" %.2f",currentRotX];
    self.maxRotY.text = [NSString stringWithFormat:@" %.2f",currentRotY];
    self.maxRotZ.text = [NSString stringWithFormat:@" %.2f",currentRotZ];
    
    
    
    double deviation = [stats_calc get_euclidean_dist:previousMaxRotX comma:previousMaxRotY comma:previousMaxRotZ with:currentRotX comma:currentRotY comma:currentRotZ];
    //NSLog(@"Accelerometer deviation: %f ", deviation);
    NSNumber *tempNumber = [[NSNumber alloc] initWithDouble:deviation];
    deviation_data[@"gyr"]  = [NSNumber numberWithFloat:([deviation_data[@"gyr"] floatValue]+ [tempNumber floatValue])];
    previousMaxRotX = currentRotX;
    previousMaxRotY = currentRotY;
    previousMaxRotZ = currentRotZ;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetMaxValues:(id)sender {
    
    currentAccelX = 0;
    currentAccelY = 0;
    currentAccelZ = 0;
    
    currentRotX = 0;
    currentRotY = 0;
    currentRotZ = 0;
    
}


#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    //int code = [httpResponse statusCode];
    
    NSLog(@"%@",httpResponse);
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
    NSLog(@"Receiving data...");
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@"Finished loading. Response: %@",_responseData);
    deviation_data = [[NSMutableDictionary alloc] initWithDictionary:@{@"acc":zero,@"gyr":zero}];
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    conn = nil;
    _responseData = nil;
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
}

@end
