//
//  CapturePreviewView.m
//  PiqEvent_iOS
//
//  Created by Denis Gavrilenko on 12/1/15.
//  Copyright © 2015 Octonion. All rights reserved.
//

#import "CapturePreviewView.h"

@implementation CapturePreviewView

- (void)layoutSubviews
{
    for (CALayer *layer in self.layer.sublayers)
    {
        layer.frame = self.bounds;
    }
}

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    return previewLayer.session;
}

- (void)setSession:(AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    previewLayer.session = session;
}

- (void)setOrientation:(AVCaptureVideoOrientation)orientation
{
    _orientation = orientation;
    
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    dispatch_async(dispatch_get_main_queue(), ^{
        previewLayer.connection.videoOrientation = _orientation;
    });
}

@end
