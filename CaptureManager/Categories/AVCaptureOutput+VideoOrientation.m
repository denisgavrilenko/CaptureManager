//
//  AVCaptureOutput+VideoOrientation.m
//  PiqEvent_iOS
//
//  Created by Denis Gavrilenko on 11/20/15.
//  Copyright © 2015 Octonion. All rights reserved.
//

#import "AVCaptureOutput+VideoOrientation.h"

@implementation AVCaptureOutput (VideoOrientation)

+ (AVCaptureVideoOrientation)videoOrientationForDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    switch (deviceOrientation) {
        case UIDeviceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        case UIDeviceOrientationPortraitUpsideDown:
            return AVCaptureVideoOrientationPortraitUpsideDown;
        case UIDeviceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeRight;
        case UIDeviceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeLeft;
        default:
            return AVCaptureVideoOrientationLandscapeRight;
    }
}

- (void)setOutputOrientationWithDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
    [self setOutputOrientation:[AVCaptureOutput videoOrientationForDeviceOrientation:deviceOrientation]];
}

- (void)setOutputOrientation:(AVCaptureVideoOrientation)videoOrientation
{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.connections)
    {
        NSLog(@"%s %@", __PRETTY_FUNCTION__, connection);
        for (AVCaptureInputPort *port in connection.inputPorts)
        {
            NSLog(@"%s %@",__PRETTY_FUNCTION__ , port);
            if ([[port mediaType] isEqual:AVMediaTypeVideo])
            {
                videoConnection = connection;
            }
        }
    }
    if ([videoConnection isVideoOrientationSupported])
    {
        [videoConnection setVideoOrientation:videoOrientation];
    }
}

@end
