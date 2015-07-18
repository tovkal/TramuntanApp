//
//  ARUtilsTests.m
//  TramuntanApp
//
//  Created by Andrés Pizá on 18/7/15.
//  Copyright (c) 2015 Tovkal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <CoreMotion/CoreMotion.h>
#import "ARUtils.h"

@interface ARUtilsTests : XCTestCase

@end

@implementation ARUtilsTests

- (void)testRotationMatrixIsEmpty {
    CMRotationMatrix matrix;
    
    XCTAssertTrue([ARUtils rotationMatrixIsEmpty:matrix]);
}

- (void)testRotationMatrixIsNotEmpty {
    CMRotationMatrix matrix;
    matrix.m11 = 1;
    
    XCTAssertFalse([ARUtils rotationMatrixIsEmpty:matrix]);
}

- (void)testcreateProjectionMatrix {
    float fovy = 45.0f;
    float aspect = 1.7f;
    float zNear = 0.25f;
    float zFar = 1000.0f;
    float f = 1.0f / tanf(fovy/2.0f);
    mat4f_t mout;
    
    createProjectionMatrix(mout, fovy, aspect, zNear, zFar);
    
    XCTAssertEqual(f / aspect, mout[0]);
    XCTAssertEqual(0.0f, mout[1]);
    XCTAssertEqual(0.0f, mout[2]);
    XCTAssertEqual(0.0f, mout[3]);
    XCTAssertEqual(0.0f, mout[4]);
    XCTAssertEqual(f, mout[5]);
    XCTAssertEqual(0.0f, mout[6]);
    XCTAssertEqual(0.0f, mout[7]);
    XCTAssertEqual(0.0f, mout[8]);
    XCTAssertEqual(0.0f, mout[9]);
    XCTAssertEqual((zFar+zNear) / (zNear-zFar), mout[10]);
    XCTAssertEqual(-1.0f, mout[11]);
    XCTAssertEqual(0.0f, mout[12]);
    XCTAssertEqual(0.0f, mout[13]);
    XCTAssertEqual(2 * zFar * zNear /  (zNear-zFar), mout[14]);
    XCTAssertEqual(0.0f, mout[15]);
}

- (void)testMultiplyMatrixAndVector {
    mat4f_t matrix;
    vec4f_t vector;
    vec4f_t result;
    
    matrix[0] = 4;
    matrix[1] = 6;
    matrix[2] = 4;
    matrix[3] = 3;
    matrix[4] = 6;
    matrix[5] = 3;
    matrix[6] = 5;
    matrix[7] = 2;
    matrix[8] = 8;
    matrix[9] = 4;
    matrix[10] = 6;
    matrix[11] = 1;
    matrix[12] = 0;
    matrix[13] = 5;
    matrix[14] = 7;
    matrix[15] = 9;
    
    vector[0] = 32;
    vector[1] = 4;
    vector[2] = 6;
    vector[3] = 7;
    
    multiplyMatrixAndVector(result, matrix, vector);
    
    XCTAssertEqual(result[0], 200);
    XCTAssertEqual(result[1], 263);
    XCTAssertEqual(result[2], 233);
    XCTAssertEqual(result[3], 173);
}

- (void)testMultiplyMatrixAndMatri {
    mat4f_t matrixA;
    mat4f_t matrixB;
    mat4f_t result;
    
    matrixA[0] = 4;
    matrixA[1] = 6;
    matrixA[2] = 4;
    matrixA[3] = 3;
    matrixA[4] = 6;
    matrixA[5] = 3;
    matrixA[6] = 5;
    matrixA[7] = 2;
    matrixA[8] = 8;
    matrixA[9] = 4;
    matrixA[10] = 6;
    matrixA[11] = 0;
    matrixA[12] = 0;
    matrixA[13] = 5;
    matrixA[14] = 7;
    matrixA[15] = 9;

    matrixB[0] = 4;
    matrixB[1] = 6;
    matrixB[2] = 4;
    matrixB[3] = 3;
    matrixB[4] = 6;
    matrixB[5] = 3;
    matrixB[6] = 5;
    matrixB[7] = 2;
    matrixB[8] = 8;
    matrixB[9] = 4;
    matrixB[10] = 6;
    matrixB[11] = 0;
    matrixB[12] = 0;
    matrixB[13] = 5;
    matrixB[14] = 7;
    matrixB[15] = 9;
    
    multiplyMatrixAndMatrix(result, matrixA, matrixB);
    
    XCTAssertEqual(result[0], 84);
    XCTAssertEqual(result[1], 73);
    XCTAssertEqual(result[2], 91);
    XCTAssertEqual(result[3], 51);
    XCTAssertEqual(result[4], 82);
    XCTAssertEqual(result[5], 75);
    XCTAssertEqual(result[6], 83);
    XCTAssertEqual(result[7], 42);
    XCTAssertEqual(result[8], 104);
    XCTAssertEqual(result[9], 84);
    XCTAssertEqual(result[10], 88);
    XCTAssertEqual(result[11], 32);
    XCTAssertEqual(result[12], 86);
    XCTAssertEqual(result[13], 88);
    XCTAssertEqual(result[14], 130);
    XCTAssertEqual(result[15], 91);
}

- (void)testLatLonToEcef {
    double lat = 39.3;
    double lon = 2.99;
    double alt = 50;
    double x;
    double y;
    double z;
    
    latLonToEcef(lat, lon, alt, &x, &y, &z);
    
    XCTAssertEqualWithAccuracy(x, 4935610.29789, 0.0001);
    XCTAssertEqualWithAccuracy(y, 257800.590535, 0.0001);
    XCTAssertEqualWithAccuracy(z, 4018176.93813, 0.0001);
}

- (void)testEcefToEnu {
    double lat = 39.3;
    double lon = 2.99;
    double x = 4935610.29789;
    double y = 257800.590535;
    double z = 4018176.93813;
    double xr = 4935.844563;
    double yr = 267.31623453;
    double zr = 4018.77934;
    double e;
    double n;
    double u;
    
    ecefToEnu(lat, lon, x, y, z, xr, yr, zr, &e, &n, &u);
    
    XCTAssertEqualWithAccuracy(e, -9.490470, 0.0001);
    XCTAssertEqualWithAccuracy(n, -20934.8549, 0.0001);
    XCTAssertEqualWithAccuracy(u, 6363246.1375, 0.0001);
}

@end
