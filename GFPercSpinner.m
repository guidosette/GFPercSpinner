//
//  GFSpinner.m
//  // Fanfa
//
//  Created by Guido Fanfani on 22/09/19.
//  Copyright © 2019 Fanfa. All rights reserved.
//

#import "GFPercSpinner.h"

#define DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180.0f)

@implementation GFPercSpinner {
	CAShapeLayer *circle;
    bool animation;

	// defaults
	float spinnerStrokeDefault;
}

- (instancetype)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		[self setup:frame];
		
	}
	return self;
}

- (void)setup:(CGRect)frame {
	
	self.backgroundColor = [UIColor clearColor];
	
	spinnerStrokeDefault = 3;
	
	//circle
	circle = [CAShapeLayer layer];
	circle.fillColor = [UIColor clearColor].CGColor;
	circle.lineCap = kCALineCapRound;
	circle.strokeColor = [UIColor grayColor].CGColor;
	circle.lineWidth = spinnerStrokeDefault;
	[self.layer addSublayer:circle];
	// Center the shape in self.view
	[self updateFrame:frame];
	
	circle.strokeEnd = 0;
	
}

- (void)updateFrame:(CGRect)frame {
	
	float radius = frame.size.height/2-5;
	circle.position = CGPointMake(CGRectGetMidX(self.bounds)-radius,
								  CGRectGetMidY(self.bounds)-radius);
	float startAngle = 0.0f;
	float endAngle = 360.0f;
	// Make a circular shape
	UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius)
														radius:radius
													startAngle:DEGREES_TO_RADIANS(startAngle) - DEGREES_TO_RADIANS(90.0f)
													  endAngle:DEGREES_TO_RADIANS(endAngle) - DEGREES_TO_RADIANS(90.0f)
													 clockwise:YES];
	circle.path = [path CGPath];
}

-(void)setStrokeColor:(UIColor*)color {
	circle.strokeColor = color.CGColor;
}

-(void)setStrokeWidth:(float)width {
	circle.lineWidth = width;
}

- (void)updateProgress:(float)perc {
	if (animation) {
		self->circle.strokeEnd = 1.0;
		  return;
	  }
	self->circle.strokeEnd = perc;
}

- (float)currentProgress {
	return circle.strokeEnd;
}

- (void)reset {
	circle.strokeEnd = 0;
}

#pragma mark - Animation

- (void)startAnimation {
    if (animation) {
        return;
    }
    animation = true;
    
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.toValue = @(-M_PI_2*4); // The angle we are rotating to
    rotate.duration = 0.8;
    rotate.repeatCount = INFINITY;
    rotate.autoreverses = NO;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];


	CABasicAnimation* scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	scale.duration = 0.8;
	scale.repeatCount = INFINITY;
	scale.removedOnCompletion = NO;
	scale.autoreverses = YES;
	scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	scale.fromValue = [NSNumber numberWithFloat:1.0];
	scale.toValue = [NSNumber numberWithFloat:0.4];
	
	CABasicAnimation* translate = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
	translate.duration = 0.8;
	translate.repeatCount = INFINITY;
	translate.removedOnCompletion = NO;
	translate.autoreverses = YES;
	translate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	translate.fromValue = [NSNumber numberWithFloat:1.0];
	translate.toValue = [NSNumber numberWithFloat:0.4];
	
    [circle addAnimation:scale forKey:@"rotateAnimation"];
//    [circle addAnimation:translate forKey:@"translateAnimation"];
}

- (void)stopAnimation {
    [circle removeAnimationForKey:@"rotateAnimation"];
//    [circle removeAnimationForKey:@"translateAnimation"];
    animation = false;
}

- (bool)isAnimation {
    return animation;
}

@end
