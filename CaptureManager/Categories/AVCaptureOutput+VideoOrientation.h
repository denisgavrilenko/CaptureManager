//
//  AVCaptureOutput+VideoOrientation.h
//  PiqEvent_iOS
//
//  Created by Denis Gavrilenko on 11/20/15.
//  Copyright © 2015 Octonion. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import <UIKit/UIKit.h>

@interface AVCaptureOutput (VideoOrientation)

- (void)setOutputOrientationWithDeviceOrientation:(UIDeviceOrientation)deviceOrientation;
- (void)setOutputOrientation:(AVCaptureVideoOrientation)videoOrientation;

@end
