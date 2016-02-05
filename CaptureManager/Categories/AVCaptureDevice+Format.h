//
//  AVCaptureDevice+Format.h
//  FXDemo_iOS
//
//  Created by Denis Gavrilenko on 2/5/16.
//  Copyright © 2016 Octonion. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVCaptureDevice (Format)

+ (AVCaptureDeviceFormat *)defauitDeviceActiveFormat;
+ (void)configureDefaultDeviceWithFormat:(AVCaptureDeviceFormat *)format error:(NSError **)error;

@end
