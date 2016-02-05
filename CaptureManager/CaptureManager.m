//
//  CaptureManager.m
//  PiqEvent_iOS
//
//  Created by Denis Gavrilenko on 11/19/15.
//  Copyright © 2015 Octonion. All rights reserved.
//

#import "CaptureManager.h"

#import <AVFoundation/AVFoundation.h>
#import "AVCaptureDevice+Format.h"
#import "AVCaptureSession+Outputs.h"
#import "CapturePreviewView.h"

static char * const kSessionQueueLabel = "Capture Manager Session Queue";

@interface CaptureManager ()

@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic, strong) CapturePreviewView *previewView;

@end

@implementation CaptureManager

- (instancetype)initWithPreviewView:(CapturePreviewView *)previewView
{
    self = [super init];
    if (self)
    {
        self.captureSession = [self createCaptureSession];
        self.previewView = previewView;
        self.previewView.session = self.captureSession;
        self.sessionQueue = dispatch_queue_create(kSessionQueueLabel, DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

#pragma mark - Setters Getters

- (void)setVideoDeviceInput:(AVCaptureDeviceInput *)videoDeviceInput
{
    [self.captureSession removeInput:_videoDeviceInput];
    _videoDeviceInput = videoDeviceInput;
    [self.captureSession addInput:videoDeviceInput];
}

- (AVCaptureDeviceFormat *)activeFormat
{
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    return videoDevice.activeFormat;
}

#pragma mark - Public

- (void)configureStandartInput
{
    dispatch_async(self.sessionQueue, ^{
        AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [self switchDeviceFormatForBestConfiguration:videoDevice.formats];
        
        [self.captureSession beginConfiguration];
        
        AVCaptureDeviceInput *input = [self inputForSession:self.captureSession captureDevice:videoDevice];
        if (input)
        {
            [self setVideoDeviceInput:input];
            [self.previewView setOrientation:AVCaptureVideoOrientationLandscapeRight];
        }
        
        [self.captureSession commitConfiguration];
    });
}

- (void)addOutput:(AVCaptureOutput *)output
{
    dispatch_async(self.sessionQueue, ^{
        [self.captureSession beginConfiguration];
        
        if ([self.captureSession canAddOutput:output])
        {
            [self.captureSession removeAllOutputs];
            [self.captureSession addOutput:output];
        }
        
        [self.captureSession commitConfiguration];
    });
}

- (void)changeDeviceFormat:(AVCaptureDeviceFormat *)deviceFormat
{
    dispatch_async(self.sessionQueue, ^{
        NSError *error = nil;
        [AVCaptureDevice configureDefaultDeviceWithFormat:deviceFormat error:&error];
    });
}

#pragma mark - Session

- (AVCaptureSession *)createCaptureSession
{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetInputPriority;
    return session;
}

#pragma mark - Input

- (AVCaptureDeviceInput *)inputForSession:(AVCaptureSession *)captureSession captureDevice:(AVCaptureDevice *)captureDevice
{
    NSError *error;
    AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error)
    {
        NSLog(@"Video input creation failed: %s %@", __PRETTY_FUNCTION__, error);
        return nil;
    }
    if (![captureSession canAddInput:videoIn])
    {
        NSLog(@"Video input add-to-session failed %s", __PRETTY_FUNCTION__);
        return nil;
    }
    return videoIn;
}

#pragma mark - Running

- (void)startRunning
{
    dispatch_async(self.sessionQueue, ^{
        [self.captureSession startRunning];
    });
}

- (void)stopRunning
{
    dispatch_async(self.sessionQueue, ^{
        [self.captureSession stopRunning];
    });
}

#pragma mark - Configuration

- (void)switchDeviceFormatForBestConfiguration:(NSArray <AVCaptureDeviceFormat *> *)formats
{
    AVCaptureDeviceFormat *selectedFormat = nil;
    int32_t maxWidth = 0;
    AVFrameRateRange *frameRateRange = nil;
    for (AVCaptureDeviceFormat *format in formats)
    {
        for (AVFrameRateRange *range in format.videoSupportedFrameRateRanges)
        {
            CMFormatDescriptionRef description = format.formatDescription;
            CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(description);
            int32_t width = dimensions.width;
            
            if (frameRateRange.maxFrameRate < range.maxFrameRate || (frameRateRange.maxFrameRate == range.maxFrameRate && maxWidth < width))
            {
                selectedFormat = format;
                frameRateRange = range;
                maxWidth = width;
            }
        }
    }
    NSError *error = nil;
    [AVCaptureDevice configureDefaultDeviceWithFormat:selectedFormat error:&error];
}


@end