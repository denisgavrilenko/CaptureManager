//
//  AVCaptureSession+Outputs.m
//  FXDemo_iOS
//
//  Created by Denis Gavrilenko on 2/5/16.
//  Copyright © 2016 Octonion. All rights reserved.
//

#import "AVCaptureSession+Outputs.h"

@implementation AVCaptureSession (Outputs)

- (void)removeAllOutputs
{
    for (int i = (int)self.outputs.count - 1; i >= 0; --i)
    {
        [self removeOutput:self.outputs[i]];
    }
}

@end
