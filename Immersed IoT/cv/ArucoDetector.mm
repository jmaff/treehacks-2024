//
//  OpenCVWrapper.m
//  Immersed IoT
//
//  Created by Joseph Maffetone on 2/17/24.
//

#import <opencv2/opencv.hpp>
#import <opencv2/core.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/imgproc/imgproc.hpp>
#include "opencv2/aruco.hpp"
#include "opencv2/aruco/dictionary.hpp"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SceneKit/SceneKit.h>
#import <CoreVideo/CoreVideo.h>
#import "SKWorldTransform.h"

#import "ArucoDetector.h"

@implementation ArucoDetector : NSObject

+(NSMutableArray *) estimatePose:(CVPixelBufferRef)pixelBuffer withIntrinsics:(matrix_float3x3)intrinsics {
    return [NSMutableArray array];
}

@end
