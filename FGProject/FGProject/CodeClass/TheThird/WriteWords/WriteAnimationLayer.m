//
//  WriteAnimationLayer.m
//  书写文字
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import "WriteAnimationLayer.h"
#import "WriteFunction.h"
#import <QuartzCore/CALayer.h>
#import <Foundation/NSObject.h>
@interface WriteAnimationLayer()
{
    NSTimer *timer;
    CALayer *animationLayer;
}


@end

@implementation WriteAnimationLayer
-(instancetype)init
{
    self = [super init];
    if (self)
    {
//        timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(checkingAnimationState:) userInfo:nil repeats:YES];
//        [[NSRunLoop  currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
    return self;
}

- (void)checkingAnimationState:(NSTimer*)timer
{
//    CABasicAnimation *aimat =(CABasicAnimation*)[_pathLayer animationForKey:@"strokeEnd"];
//    FGLOG(@"-----end %@ %d %d",aimat.byValue,aimat.isAdditive,aimat.cumulative);
}
-(void)animationPath:(UIBezierPath*)path inView:(UIView*)view strokeColor:(UIColor*)color lineWidth:(CGFloat)lineWidth layerFrame:(CGRect)layerFrame wordsLengh:(NSInteger)length
{
    animationLayer = [CALayer layer];
    animationLayer.frame = layerFrame;
    [animationLayer setBackgroundColor:[UIColor clearColor].CGColor];
    [view.layer addSublayer:animationLayer];
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = animationLayer.bounds;
    pathLayer.bounds = CGPathGetBoundingBox(path.CGPath);
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [color CGColor];
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = lineWidth;
    pathLayer.lineJoin = kCALineJoinBevel;
    [animationLayer addSublayer:pathLayer];
    self.pathLayer = pathLayer;
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    pathAnimation.duration = length*85/327;//调试出来的比例
    pathAnimation.duration = 1;//调试出来的比例
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
//    animationLayer.delegate = self;
//    pathAnimation.delegate = self;
}

- (void)writeWordsWithWordsStr:(NSString *)wordsStr layerFrame:(CGRect)frame layeView:(UIView*)view
{
    for (id layer in view.layer.sublayers)
    {
        [layer removeAllAnimations];
    }
    
    UIBezierPath *path = [WriteFunction pathForText:wordsStr lineSpace:2.0f textFont:[UIFont systemFontOfSize:15.0f] drawWidth:CGRectGetWidth(frame) forLayerDraw:YES];
    CGRect sizeFrame = CGPathGetBoundingBox(path.CGPath);
    [self animationPath:path inView:view strokeColor:[UIColor redColor] lineWidth:0.8f layerFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), sizeFrame.size.width, sizeFrame.size.height) wordsLengh:wordsStr.length];
    view.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), sizeFrame.size.width, sizeFrame.size.height);
}

@end
