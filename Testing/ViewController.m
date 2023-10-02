//
//  ViewController.m
//  Testing
//
//  Created by Lakis Filippidis on 26/09/23.
//

#import "ViewController.h"
#import "BezierExperiment.h"

#define pointRadius         8.f

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *drawingView;
@property (weak, nonatomic) IBOutlet UIButton *generateButton;
@property (weak, nonatomic) IBOutlet UISlider *coefSlider;

@property (nonatomic, retain) BezierExperiment *bezier;

@end


@implementation ViewController
@synthesize drawingView, coefSlider;
@synthesize bezier;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    drawingView.layer.cornerRadius = 15.f;
    bezier = [BezierExperiment new];
}

- (void)viewDidAppear:(BOOL)animated {
    [self generate:nil];
}

- (IBAction)generate:(id)sender {
    [bezier generateInView:drawingView];
    [self setRandomCoefficiente];
}

- (IBAction)sliderChanged:(id)sender {
    [bezier coefficientChanged:drawingView coefficient:coefSlider.value];
}

- (void)setRandomCoefficiente {
    CGFloat coefficient = (CGFloat)arc4random() / UINT32_MAX;
    coefSlider.value = coefficient;
    [bezier coefficientChanged:drawingView coefficient:coefSlider.value];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event { 
    [bezier touchesBegan:touches withEvent:event locationView:drawingView];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [bezier touchesMoved:touches withEvent:event locationView:drawingView];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [bezier touchesEnded];
}

@end
