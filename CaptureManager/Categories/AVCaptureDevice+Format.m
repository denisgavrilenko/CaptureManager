//
//  AVCaptureDevice+Format.m
//  FXDemo_iOS
//
//  Created by Denis Gavrilenko on 2/5/16.
//  Copyright © 2016 Octonion. All rights reserved.
//

#import "AVCaptureDevice+Format.h"

@implementation AVCaptureDevice (Format)

+ (AVCaptureDeviceFormat *)defauitDeviceActiveFormat
{
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    return videoDevice.activeFormat;
}

+ (void)configureDefaultDeviceWithFormat:(AVCaptureDeviceFormat *)format error:(NSError **)error
{
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([videoDevice lockForConfiguration:error])
    {
        videoDevice.activeFormat = format;
        AVFrameRateRange *frameRate = [format.videoSupportedFrameRateRanges lastObject];
        videoDevice.activeVideoMinFrameDuration = CMTimeMake(1, (int32_t)frameRate.maxFrameRate);
        videoDevice.activeVideoMaxFrameDuration = CMTimeMake(1, (int32_t)frameRate.maxFrameRate);
        [videoDevice unlockForConfiguration];
        NSLog(@"%s Did set format: %@", __PRETTY_FUNCTION__, format);
    }
    else
    {
        NSLog(@"%s AVCaptureDevice Error: %@", __PRETTY_FUNCTION__, *error);
    }
}

@end
