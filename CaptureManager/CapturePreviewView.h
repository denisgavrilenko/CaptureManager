//
//  CapturePreviewView.h
//  PiqEvent_iOS
//
//  Created by Denis Gavrilenko on 12/1/15.
//  Copyright © 2015 Octonion. All rights reserved.
//

#import <UIKit/UIKit.h>

@import AVFoundation;

@interface CapturePreviewView : UIView

@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureVideoOrientation orientation;

@end
