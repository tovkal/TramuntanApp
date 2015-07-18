//
//  Utils.h
//  TramuntanApp
//
//  Created by Tovkal on 31/08/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

#pragma mark - Type definition

typedef float mat4f_t[16];	// 4x4 matrix in column major order
typedef float vec4f_t[4];	// 4D vector

#define DEGREES_TO_RADIANS (M_PI/180.0)

#pragma mark -

@interface ARUtils : NSObject

+ (BOOL) rotationMatrixIsEmpty:(CMRotationMatrix)r;

// Creates a projection matrix using the given y-axis field-of-view, aspect ratio, and near and far clipping planes
void createProjectionMatrix(mat4f_t mout, float fovy, float aspect, float zNear, float zFar);

// Matrix-vector and matrix-matricx multiplication routines
void multiplyMatrixAndVector(vec4f_t vout, const mat4f_t m, const vec4f_t v);
void multiplyMatrixAndMatrix(mat4f_t c, const mat4f_t a, const mat4f_t b);

// References to ECEF and ECEF to ENU conversion may be found on the web.
// Converts latitude, longitude, altitude (LLA) to ECEF coordinate system
void latLonToEcef(double lat, double lon, double alt, double *x, double *y, double *z);

// Coverts ECEF to ENU coordinates centered at given lat, lon
void ecefToEnu(double lat, double lon, double x, double y, double z, double xr, double yr, double zr, double *e, double *n, double *u);

@end
