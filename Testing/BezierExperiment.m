//
//  BezierExperiment.m
//  Testing
//
//  Created by Lakis Filippidis on 28/09/23.
//

#import "BezierExperiment.h"

#define pointRadius         12.f

@interface BezierExperiment ()


@property (nonatomic, assign) CGFloat coefficient;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint finishPoint;
@property (nonatomic, assign) CGPoint startControlPoint;
@property (nonatomic, assign) CGPoint finishControlPoint;
@property (nonatomic, assign) CGPoint draggedPoint;

@property (nonatomic, retain) UIBezierPath *curvePath;

@end


@implementation BezierExperiment
@synthesize startPoint, finishPoint, startControlPoint, finishControlPoint, draggedPoint;
@synthesize coefficient;
@synthesize curvePath;

- (void)generateInView:(UIView *)drawingView {
    draggedPoint = CGPointMake(-1.f, -1.f);
    
    coefficient = 0.5f;
    startPoint = [self generatePoint:drawingView];
    finishPoint = [self generatePoint:drawingView];
    startControlPoint = [self generatePoint:drawingView];
    finishControlPoint = [self generatePoint:drawingView];
    [self createBezier:drawingView];
}

- (void)coefficientChanged:(UIView *)drawingView coefficient:(CGFloat)coefficient {
    self.coefficient = coefficient;
    [self createBezier:drawingView];
}

- (void)createBezier:(UIView *)drawingView {
    CGFloat radius = pointRadius;
    BOOL firstGenerate = YES;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    [shapeLayer setName:@"shapeLayer"];
    for (CALayer *sublayer in drawingView.layer.sublayers) {
        if ([sublayer.name isEqual:@"shapeLayer"]) {
            shapeLayer = (CAShapeLayer *)sublayer;
            firstGenerate = NO;
        }
    }
    
    [[shapeLayer sublayers] makeObjectsPerformSelector:@selector(removeFromSuperlayer) withObject:nil];
    
    CAShapeLayer *curveLayer = [self cretaCurveLayer:drawingView];
    CAShapeLayer *controlLinesLayer = [self cretaControlLinesLayer:drawingView];
    CAShapeLayer *pointLayer = [self createPointLayer:drawingView radius:radius];
    CAShapeLayer *controlPointLayer = [self createPointControlLayer:drawingView radius:radius];
    CAShapeLayer *tPointLayer = [self createTPointLayer:drawingView tPoint:[self getTPoint:coefficient startPoint:startPoint finishPoint:finishPoint startControlPoint:startControlPoint finishControlPoint:finishControlPoint] radius:radius];

    [shapeLayer addSublayer:curveLayer];
    [shapeLayer addSublayer:pointLayer];
    [shapeLayer addSublayer:controlPointLayer];
    [shapeLayer addSublayer:controlLinesLayer];
    [shapeLayer addSublayer:tPointLayer];
    
    if (firstGenerate) {
        [drawingView.layer addSublayer:shapeLayer];
    }
}


// Layer constructor

- (CAShapeLayer *)cretaCurveLayer:(UIView *)drawingView {
    curvePath = [UIBezierPath bezierPath];
    [curvePath moveToPoint:startPoint];
    [curvePath addCurveToPoint:finishPoint controlPoint1:startControlPoint controlPoint2:finishControlPoint];
    
    CAShapeLayer *shapeLayer = [self createShapeLayer:drawingView.bounds strokeColor:UIColor.blackColor path:curvePath.CGPath width:5.0];
    [shapeLayer setName:@"curveLayer"];
    
    [curvePath closePath];
    return shapeLayer;
}

- (CAShapeLayer *)cretaControlLinesLayer:(UIView *)drawingView {
    UIBezierPath *linesPath = [UIBezierPath bezierPath];
    [linesPath moveToPoint:startPoint];
    [linesPath addLineToPoint:startControlPoint];
        
    [linesPath moveToPoint:finishPoint];
    [linesPath addLineToPoint:finishControlPoint];

    CAShapeLayer *shapeLayer = [self createShapeLayer:drawingView.bounds strokeColor:UIColor.lightGrayColor path:linesPath.CGPath width:3.0];
    [shapeLayer setLineDashPattern: [NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:5], nil]];
    [shapeLayer setLineJoin:kCALineJoinRound];
    return shapeLayer;
}

- (CAShapeLayer *)createPointLayer:(UIView *)drawingView radius:(CGFloat)radius {
    UIBezierPath *pointsPath = [UIBezierPath bezierPath];
    [pointsPath appendPath:[self createPointPath:startPoint radius:radius]];
    [pointsPath appendPath:[self createPointPath:finishPoint radius:radius]];
    return [self createShapeLayer:drawingView.bounds strokeColor:UIColor.purpleColor path:pointsPath.CGPath width:radius];
}

- (CAShapeLayer *)createPointControlLayer:(UIView *)drawingView radius:(CGFloat)radius {
    UIBezierPath *pointsPath = [UIBezierPath bezierPath];
    [pointsPath appendPath:[self createPointPath:startControlPoint radius:radius]];
    [pointsPath appendPath:[self createPointPath:finishControlPoint radius:radius]];
    return [self createShapeLayer:drawingView.bounds strokeColor:UIColor.blueColor path:pointsPath.CGPath width:radius];;
}

- (CAShapeLayer *)createTPointLayer:(UIView *)drawingView tPoint:(CGPoint)tPoint radius:(CGFloat)radius {
    UIBezierPath *pointsPath = [UIBezierPath bezierPath];
    [pointsPath appendPath:[self createPointPath:tPoint radius:radius]];
    return [self createShapeLayer:drawingView.bounds strokeColor:UIColor.redColor path:pointsPath.CGPath width:radius];
}

- (UIBezierPath *)createPointPath:(CGPoint)point radius:(CGFloat)radius {
    return [UIBezierPath bezierPathWithOvalInRect:CGRectMake(point.x - radius / 2, point.y - radius / 2, radius, radius)];
}

- (CAShapeLayer *)createShapeLayer:(CGRect)frame strokeColor:(UIColor *)strokeColor path:(CGPathRef)path width:(CGFloat)width {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = UIColor.clearColor.CGColor;
    shapeLayer.strokeColor = strokeColor.CGColor;
    shapeLayer.lineWidth = width;
    shapeLayer.frame = frame;
    shapeLayer.path = path;
    return  shapeLayer;
}


// Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event locationView:(nonnull UIView *)view {
    UITouch *touch = [[event touchesForView:view] anyObject];
    CGPoint location = [touch locationInView:view];
    
    [self findDraggedPoint:location];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event locationView:(nonnull UIView *)view {
    UITouch *touch = [[event touchesForView:view] anyObject];
    CGPoint location = [touch locationInView:view];
    
    CGFloat x = MAX(pointRadius, MIN(view.bounds.size.width - pointRadius, location.x));
    CGFloat y = MAX(pointRadius, MIN(view.bounds.size.height - pointRadius, location.y));
    
    NSLog(@"X: %f   Y: %f", x, y);
    
    if (draggedPoint.x > 0 && draggedPoint.y > 0) {
        [self moveDraggedPoint:CGPointMake(x, y)];
        [self createBezier:view];
    }
}

- (void)touchesEnded {
    self.draggedPoint = CGPointMake(-1.f, -1.f);
}

- (void)findDraggedPoint:(CGPoint)location {
    CGFloat raduis = pointRadius;
    if ([self point:startPoint isIncludedLocation:location radius:raduis]) {
        draggedPoint = location;
        startPoint = draggedPoint;
    }
    
    if ([self point:finishPoint isIncludedLocation:location radius:raduis]) {
        draggedPoint = location;
        finishPoint = draggedPoint;
    }
    
    if ([self point:startControlPoint isIncludedLocation:location radius:raduis]) {
        draggedPoint = location;
        startControlPoint = draggedPoint;
    }
    
    if ([self point:finishControlPoint isIncludedLocation:location radius:raduis]) {
        draggedPoint = location;
        finishControlPoint = draggedPoint;
    }
}

- (void)moveDraggedPoint:(CGPoint)location {
    if ((draggedPoint.x == startPoint.x) && (draggedPoint.y == startPoint.y)) {
        startPoint = location;
        draggedPoint = startPoint;
    }
    else if ((draggedPoint.x == finishPoint.x) && (draggedPoint.y == finishPoint.y)) {
        finishPoint = location;
        draggedPoint = finishPoint;
    }
    else if ((draggedPoint.x == startControlPoint.x) && (draggedPoint.y == startControlPoint.y)) {
        startControlPoint = location;
        draggedPoint = startControlPoint;
    }
    else if ((draggedPoint.x == finishControlPoint.x) && (draggedPoint.y == finishControlPoint.y)) {
        finishControlPoint = location;
        draggedPoint = finishControlPoint;
    }
}


// Point constructor

- (CGPoint)generatePoint:(UIView *)drawingView {
    CGRect bounds = [drawingView bounds];
    CGFloat x = MAX(pointRadius, MIN(drawingView.bounds.size.width - pointRadius, arc4random_uniform(bounds.size.width)));
    CGFloat y = MAX(pointRadius, MIN(drawingView.bounds.size.height - pointRadius, arc4random_uniform(bounds.size.height)));
    return CGPointMake(x, y);
}

- (BOOL)point:(CGPoint)point isIncludedLocation:(CGPoint)location radius:(CGFloat)radius {
    return (fabs(location.x - point.x) <= radius && fabs(location.y - point.y) <= radius);
}

- (CGPoint)getTPoint:(CGFloat)t startPoint:(CGPoint)startPoint finishPoint:(CGPoint)finishPoint startControlPoint:(CGPoint)startControlPoint finishControlPoint:(CGPoint)finishControlPoint {
    CGFloat oneMinusT = 1 - t;
    CGFloat x = pow(oneMinusT, 3) * startPoint.x + 3 * pow(oneMinusT, 2) * t * startControlPoint.x + 3 * oneMinusT * pow(t, 2) * finishControlPoint.x + pow(t, 3) * finishPoint.x;
    CGFloat y = pow(oneMinusT, 3) * startPoint.y + 3 * pow(oneMinusT, 2) * t * startControlPoint.y + 3 * oneMinusT * pow(t, 2) * finishControlPoint.y + pow(t, 3) * finishPoint.y;
    return CGPointMake(x, y);
}

@end
