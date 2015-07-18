//
//  Utils.m
//  TramuntanApp
//
//  Created by Tovkal on 31/08/14.
//  Copyright (c) 2014 Tovkal. All rights reserved.
//

#import "ARUtils.h"
#import "UIDeviceHardware.h"

@implementation ARUtils

#pragma mark - Matrix helpers

+ (BOOL) rotationMatrixIsEmpty:(CMRotationMatrix)r
{
    double m = 0.0;
    
    m += r.m11 + r.m12 + r.m13;
    m += r.m21 + r.m22 + r.m23;
    m += r.m31 + r.m32 + r.m33;
    
    if (m == 0.0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - Math functions
// Creates a projection matrix using the given y-axis field-of-view, aspect ratio, and near and far clipping planes
void createProjectionMatrix(mat4f_t mout, float fovy, float aspect, float zNear, float zFar)
{
    float f = 1.0f / tanf(fovy/2.0f);
    
    mout[0] = f / aspect;
    mout[1] = 0.0f;
    mout[2] = 0.0f;
    mout[3] = 0.0f;
    
    mout[4] = 0.0f;
    mout[5] = f;
    mout[6] = 0.0f;
    mout[7] = 0.0f;
    
    mout[8] = 0.0f;
    mout[9] = 0.0f;
    mout[10] = (zFar+zNear) / (zNear-zFar);
    mout[11] = -1.0f;
    
    mout[12] = 0.0f;
    mout[13] = 0.0f;
    mout[14] = 2 * zFar * zNear /  (zNear-zFar);
    mout[15] = 0.0f;
}

// Matrix-vector and matrix-matricx multiplication routines
void multiplyMatrixAndVector(vec4f_t vout, const mat4f_t m, const vec4f_t v)
{
    vout[0] = m[0]*v[0] + m[4]*v[1] + m[8]*v[2] + m[12]*v[3];
    vout[1] = m[1]*v[0] + m[5]*v[1] + m[9]*v[2] + m[13]*v[3];
    vout[2] = m[2]*v[0] + m[6]*v[1] + m[10]*v[2] + m[14]*v[3];
    vout[3] = m[3]*v[0] + m[7]*v[1] + m[11]*v[2] + m[15]*v[3];
}

void multiplyMatrixAndMatrix(mat4f_t c, const mat4f_t a, const mat4f_t b)
{
    uint8_t col, row, i;
    memset(c, 0, 16*sizeof(float));
    
    for (col = 0; col < 4; col++) {
        for (row = 0; row < 4; row++) {
            for (i = 0; i < 4; i++) {
                c[col*4+row] += a[i*4+row]*b[col*4+i];
            }
        }
    }
}

#pragma mark - Geodetic
#pragma mark  Constants

#define WGS84_A	(6378137.0)				// WGS 84 semi-major axis constant in meters
#define WGS84_E (8.1819190842622e-2)	// WGS 84 eccentricity

#pragma mark Functions

// References to ECEF and ECEF to ENU conversion may be found on the web.

// Converts latitude, longitude, altitude (LLA) to ECEF coordinate system
void latLonToEcef(double lat, double lon, double alt, double *x, double *y, double *z)
{
    double clat = cos(lat * DEGREES_TO_RADIANS);
    double slat = sin(lat * DEGREES_TO_RADIANS);
    double clon = cos(lon * DEGREES_TO_RADIANS);
    double slon = sin(lon * DEGREES_TO_RADIANS);
    
    double N = WGS84_A / sqrt(1.0 - WGS84_E * WGS84_E * slat * slat);
    
    *x = (N + alt) * clat * clon;
    *y = (N + alt) * clat * slon;
    *z = (N * (1.0 - WGS84_E * WGS84_E) + alt) * slat;
}

/**
 *  Converts ECEF coordinates to ENU
 *
 *  @param lat Origin of ENU system
 *  @param lon Origin of ENU system
 *  @param x   X ECEF coordinates of the device
 *  @param y   Y ECEF coordinates of the device
 *  @param z   Z ECEF coordinates of the device
 *  @param xr  X ECEF coordinates of the POI
 *  @param yr  Y ECEF coordinates of the POI
 *  @param zr  Z ECEF coordinates of the POI
 *  @param e   Resulting E coordinate of the POI in ENU
 *  @param n   Resulting N coordinate of the POI in ENU
 *  @param u   Resulting U coordinate of the POI in ENU
 */
void ecefToEnu(double lat, double lon, double x, double y, double z, double xr, double yr, double zr, double *e, double *n, double *u)
{
    double clat = cos(lat * DEGREES_TO_RADIANS);
    double slat = sin(lat * DEGREES_TO_RADIANS);
    double clon = cos(lon * DEGREES_TO_RADIANS);
    double slon = sin(lon * DEGREES_TO_RADIANS);
    double dx = x - xr;
    double dy = y - yr;
    double dz = z - zr;
    
    *e = -slon*dx  + clon*dy;
    *n = -slat*clon*dx - slat*slon*dy + clat*dz;
    *u = clat*clon*dx + clat*slon*dy + slat*dz;
}


@end
