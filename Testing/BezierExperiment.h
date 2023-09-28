//
//  BezierExperiment.h
//  Testing
//
//  Created by Lakis Filippidis on 28/09/23.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BezierExperiment : NSObject

- (void)generateInView:(UIView *)drawingView;
- (void)coefficientChanged:(UIView *)drawingView coefficient:(CGFloat)coefficient;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event locationView:(nonnull UIView *)view;
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event locationView:(nonnull UIView *)view;
- (void)touchesEnded;

- (CGPoint)getTPoint:(CGFloat)t startPoint:(CGPoint)startPoint finishPoint:(CGPoint)finishPoint startControlPoint:(CGPoint)startControlPoint finishControlPoint:(CGPoint)finishControlPoint;

@end

NS_ASSUME_NONNULL_END
