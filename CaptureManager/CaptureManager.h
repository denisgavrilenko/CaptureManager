//
//  CaptureManager.h
//  PiqEvent_iOS
//
//  Created by Denis Gavrilenko on 11/19/15.
//  Copyright © 2015 Octonion. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CapturePreviewView;
@class AVCaptureOutput;
@class AVCaptureDeviceFormat;

@interface CaptureManager : NSObject

- (instancetype)initWithPreviewView:(CapturePreviewView *)previewView;

- (void)configureStandartInput;
- (void)addOutput:(AVCaptureOutput *)output;

- (void)changeDeviceFormat:(AVCaptureDeviceFormat *)deviceFormat;

- (void)startRunning;
- (void)stopRunning;

@end
