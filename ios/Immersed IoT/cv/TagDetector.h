//
//  OpenCVWrapper.h
//  Immersed IoT
//
//  Created by Joseph Maffetone on 2/17/24.
//

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>
#import <SceneKit/SceneKit.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TagDetector : NSObject

// 1) cv::aruco::detectMarkers
// 2) cv::aruco::estimatePoseSingleMarkers
// 3) transform offset and rotation of marker's corners in OpenGL coords
// 4) return them as an array of matrixes
 +(NSMutableArray *) estimatePose:(CVPixelBufferRef)pixelBuffer withIntrinsics:(matrix_float3x3)intrinsics andMarkerSize:(Float64)markerSize;

@end

NS_ASSUME_NONNULL_END

