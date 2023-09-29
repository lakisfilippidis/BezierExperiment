//
//  TestingTests.m
//  TestingTests
//
//  Created by Lakis Filippidis on 26/09/23.
//

#import <XCTest/XCTest.h>
#import "BezierExperiment.h"

@interface TestingTests : XCTestCase
@property (nonatomic, retain) BezierExperiment *bezier;
@end


@implementation TestingTests


- (void)setUp {
    self.bezier = [BezierExperiment new];
}

- (void)tearDown {
    self.bezier = nil;
}

- (void)testExample {
    BezierExperiment *bezier = [BezierExperiment new];
    CGFloat coefficient = 0.f;
    CGPoint startPoint = CGPointMake(0.f, 0.f);
    CGPoint finishPoint = CGPointMake(3.f, 3.f);
    CGPoint startControlPoint = CGPointMake(1.f, 1.f);
    CGPoint finishControlPoint = CGPointMake(2.f, 2.f);
    CGPoint testPoint = [bezier getTPoint:coefficient startPoint:startPoint finishPoint:finishPoint startControlPoint:startControlPoint finishControlPoint:finishControlPoint];
    XCTAssertEqual(testPoint.x, 0.f, @"point X");
    XCTAssertEqual(testPoint.y, 0.f, @"point Y");
    
    coefficient = 0.5f;
    startPoint = CGPointMake(0.f, 0.f);
    finishPoint = CGPointMake(3.f, 3.f);
    startControlPoint = CGPointMake(1.f, 1.f);
    finishControlPoint = CGPointMake(2.f, 2.f);
    testPoint = [bezier getTPoint:coefficient startPoint:startPoint finishPoint:finishPoint startControlPoint:startControlPoint finishControlPoint:finishControlPoint];
    XCTAssertEqual(testPoint.x, 1.5f, @"point X");
    XCTAssertEqual(testPoint.y, 1.5f, @"point Y");

    coefficient = 1.f;
    startPoint = CGPointMake(0.f, 0.f);
    finishPoint = CGPointMake(3.f, 3.f);
    startControlPoint = CGPointMake(1.f, 1.f);
    finishControlPoint = CGPointMake(2.f, 2.f);
    testPoint = [bezier getTPoint:coefficient startPoint:startPoint finishPoint:finishPoint startControlPoint:startControlPoint finishControlPoint:finishControlPoint];
    XCTAssertEqual(testPoint.x, 3.f, @"point X");
    XCTAssertEqual(testPoint.y, 3.f, @"point Y");
    
    coefficient = 0.25f;
    startPoint = CGPointMake(0.f, 0.f);
    finishPoint = CGPointMake(3.f, 3.f);
    startControlPoint = CGPointMake(1.f, 1.f);
    finishControlPoint = CGPointMake(2.f, 2.f);
    testPoint = [bezier getTPoint:coefficient startPoint:startPoint finishPoint:finishPoint startControlPoint:startControlPoint finishControlPoint:finishControlPoint];
    XCTAssertEqual(testPoint.x, 0.75, @"point X");
    XCTAssertEqual(testPoint.y, 0.75, @"point Y");
    
    coefficient = 0.5f;
    startPoint = CGPointMake(0.f, 0.f);
    finishPoint = CGPointMake(2.f, 2.f);
    startControlPoint = CGPointMake(2.f, 0.f);
    finishControlPoint = CGPointMake(0.f, 2.f);
    testPoint = [bezier getTPoint:coefficient startPoint:startPoint finishPoint:finishPoint startControlPoint:startControlPoint finishControlPoint:finishControlPoint];
    
    XCTAssertEqual(testPoint.x, 1.0, @"point X");
    XCTAssertEqual(testPoint.y, 1.0, @"point Y");
    
    // Negative test case
    coefficient = 0.5f;
    startPoint = CGPointMake(0.f, 0.f);
    finishPoint = CGPointMake(2.f, 2.f);
    startControlPoint = CGPointMake(2.f, 0.f);
    finishControlPoint = CGPointMake(0.f, 2.f);
    testPoint = [bezier getTPoint:coefficient startPoint:startPoint finishPoint:finishPoint startControlPoint:startControlPoint finishControlPoint:finishControlPoint];
    
    XCTAssertEqual(testPoint.x, 1.1, @"point X");
    XCTAssertEqual(testPoint.y, 1.1, @"point Y");
}

- (void)testPerformanceExample {
    [self measureBlock:^{
        BezierExperiment *bezier = [BezierExperiment new];
        CGFloat coefficient = 1.f;
        CGPoint startPoint = CGPointMake(0.f, 0.f);
        CGPoint finishPoint = CGPointMake(3.f, 3.f);
        CGPoint startControlPoint = CGPointMake(1.f, 1.f);
        CGPoint finishControlPoint = CGPointMake(2.f, 2.f);
        [bezier getTPoint:coefficient startPoint:startPoint finishPoint:finishPoint startControlPoint:startControlPoint finishControlPoint:finishControlPoint];
    }];
}


// Get t point of bezier curve

- (CGPoint)getTPoint:(CGFloat)t startPoint:(CGPoint)startPoint finishPoint:(CGPoint)finishPoint startControlPoint:(CGPoint)startControlPoint finishControlPoint:(CGPoint)finishControlPoint {
    CGFloat oneMinusT = 1 - t;
    CGFloat x = pow(oneMinusT, 3) * startPoint.x + 3 * pow(oneMinusT, 2) * t * startControlPoint.x + 3 * oneMinusT * pow(t, 2) * finishControlPoint.x + pow(t, 3) * finishPoint.x;
    CGFloat y = pow(oneMinusT, 3) * startPoint.y + 3 * pow(oneMinusT, 2) * t * startControlPoint.y + 3 * oneMinusT * pow(t, 2) * finishControlPoint.y + pow(t, 3) * finishPoint.y;
    return CGPointMake(x, y);
}

@end
