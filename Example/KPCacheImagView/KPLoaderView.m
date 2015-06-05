//
//  CustomView.m
//  CustomControls
//
//  Created by Kunal Pandey on 18/05/15.
//  Copyright (c) 2015 Kunal Pandey. All rights reserved.
//

#import "CustomLoaderView.h"

#define pi 3.14159265359
#define   DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)
@implementation CustomLoaderView
{
  CGFloat startAngle,endAngle;
  CAShapeLayer *circlePathLayer;
  CGFloat circleRadius;
  CustomLoaderView *progressIndicatorView;
   
}

-(id)initWithFrame:(CGRect)frame {
  if(self = [super initWithFrame:frame]) {
    [self configure];
   
  }
  return self;
}
-(void)layoutSubviews {

  [super layoutSubviews];
  circlePathLayer.frame = self.bounds;
  circlePathLayer.path = [self circlePath].CGPath;
}

-(void)configure {
  circleRadius = 20.0;
  self.progress = 0;
  circlePathLayer = [CAShapeLayer layer];
  circlePathLayer.frame = self.bounds;
  circlePathLayer.lineWidth = 2;
  circlePathLayer.fillColor = [UIColor clearColor].CGColor;
  circlePathLayer.strokeColor = [UIColor grayColor].CGColor;
  [self.layer addSublayer:circlePathLayer];
  self.backgroundColor = [UIColor whiteColor];
}

-(CGRect)circleFrame {
  CGRect circleFrame = CGRectMake(0,0,2*circleRadius,2*circleRadius);
  circleFrame.origin.x = CGRectGetMidX(circlePathLayer.bounds) - CGRectGetMidX(circleFrame);
  circleFrame.origin.y = CGRectGetMidY(circlePathLayer.bounds) - CGRectGetMidY(circleFrame);
  return circleFrame;
}

-(UIBezierPath *)circlePath {
  return [UIBezierPath bezierPathWithOvalInRect:[self circleFrame]];
}

-(void)updateLayout{
  CGRect rect= self.frame;
    [[UIColor redColor] setStroke];
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath setLineWidth:1.0];
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.height/2) radius:rect.size.width/2 startAngle:DEGREES_TO_RADIANS(startAngle) endAngle:DEGREES_TO_RADIANS(endAngle) clockwise:YES];
    [bezierPath stroke];
    [bezierPath closePath];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  
  }


-(CGFloat)progress {
  return circlePathLayer.strokeEnd;
}
-(void)setProgress:(CGFloat)progress {
  if (progress > 1) {
    circlePathLayer.strokeEnd = 1;
  } else if (progress < 0) {
    circlePathLayer.strokeEnd = 0;
  } else {
    circlePathLayer.strokeEnd = progress;
  }
}

-(void)reveal {
  self.backgroundColor = [UIColor clearColor];
  self.progress = 1;
  [circlePathLayer removeAnimationForKey:@"strokeEnd"];
  [circlePathLayer removeFromSuperlayer];
  self.superview.layer.mask =circlePathLayer;
  
  CGPoint center =CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
  double finalRadius = sqrt((center.x*center.x) + (center.y*center.y));
  double radiusInset = finalRadius - circleRadius;
  
  CGRect outerRect = CGRectInset([self circleFrame], -radiusInset, -radiusInset);
  CGPathRef toPath = [UIBezierPath bezierPathWithOvalInRect:outerRect].CGPath;
  
  // 2
  CGPathRef fromPath = circlePathLayer.path;
  CGFloat fromLineWidth = circlePathLayer.lineWidth;
  
  // 3
  [CATransaction begin];
  [CATransaction setValue:kCFBooleanTrue forKey:kCATransactionDisableActions];
  circlePathLayer.lineWidth = 2*finalRadius;
  circlePathLayer.path = toPath;
  [CATransaction commit];
  
  // 4
  CABasicAnimation *lineWidthAnimation = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
  lineWidthAnimation.fromValue = [NSNumber numberWithDouble:fromLineWidth];
  lineWidthAnimation.toValue = [NSNumber numberWithDouble:2*finalRadius];
  CABasicAnimation *pathAnimation =[CABasicAnimation animationWithKeyPath:@"path"];
  pathAnimation.fromValue = (__bridge id)(fromPath);
  pathAnimation.toValue = (__bridge id)(toPath);
  
  // 5
  CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
  groupAnimation.duration = 1;
  groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  groupAnimation.animations = @[pathAnimation,lineWidthAnimation];
  groupAnimation.delegate = self;
  [circlePathLayer addAnimation:groupAnimation forKey:@"strokeWidth"];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  self.superview.layer.mask = nil;
}


@end
