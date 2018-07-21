//
//  BubbleButton.m
//  FGProject
//
//  Created by Bert on 2016/12/20.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "BubbleButton.h"

@implementation BubbleButton

{
    CGPoint startPoint;
    CGFloat maxWidth;
    NSMutableSet *recyclePool;
    NSMutableArray *array;
}
- (instancetype)initWithFrame:(CGRect)frame leftWidth:(CGFloat)leftWidth rightWidth:(CGFloat)rightWidth bottomHeight:(CGFloat)bottomHeight
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _leftWidth = leftWidth;
        _rightWidth = rightWidth;
        _bottomHeight = bottomHeight;
        
        self.thumbNumberLab = [[UILabel alloc]initWithFrame:self.bounds];
        [self addSubview:self.thumbNumberLab];
        self.thumbNumberLab.textAlignment = NSTextAlignmentCenter;
        
        array = @[].mutableCopy;
        recyclePool = [NSMutableSet set];
        
    }
    return self;
}

- (void)generateBubbleWithImage:(UIImage *)image
{
    CALayer *layer = [self createLayerWithImage:image];
    [self.layer addSublayer:layer];
    [self generateBubbleWithCALayer:layer];
}

- (void)generateBubbleInRandom
{
    for (int i = 0; i < self.imagesArr.count; i ++)
    {
        CALayer *layer;
        if (recyclePool.count > 0)
        {
            layer = [recyclePool anyObject];
            [recyclePool removeObject:layer];
        }else
        {
            UIImage *image = self.imagesArr[arc4random()%self.imagesArr.count];
            layer = [self createLayerWithImage:image];
        }
        [self.layer addSublayer:layer];
        [self generateBubbleWithCALayer:layer];
    }
    
    
}

- (CALayer*)createLayerWithImage:(UIImage*)image
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, image.size.width/scale, image.size.height/scale);
    layer.contents = (__bridge id)image.CGImage;
    return layer;
}

- (void)generateBubbleWithCALayer:(CALayer*)layer
{
    maxWidth = _leftWidth+_rightWidth;
    
    startPoint = CGPointMake(kScreenWidth/2, 0);
    CGPoint endPoint = CGPointMake(maxWidth*[self randomFloat] - _leftWidth, _bottomHeight);
    //过度
    CGPoint controlPonit1 = CGPointMake(maxWidth*[self randomFloat] - _leftWidth, _bottomHeight*0.2);
    CGPoint controlPonit2 = CGPointMake(maxWidth*[self randomFloat] - _leftWidth, _bottomHeight*0.6);
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, startPoint.x, startPoint.y);
    CGPathAddCurveToPoint(curvedPath, NULL, controlPonit1.x, controlPonit1.y, controlPonit2.x, controlPonit2.y, endPoint.x, endPoint.y);
    
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animation];
    keyFrame.keyPath = @"position";
    keyFrame.path = CFAutorelease(curvedPath);
    keyFrame.duration = self.duration;
    keyFrame.calculationMode = kCAAnimationPaced;
    [layer addAnimation:keyFrame forKey:@"keyFrame"];
    
    
    CABasicAnimation *scale = [CABasicAnimation animation];
    scale.keyPath = @"transform.scale";
    scale.toValue = @2.5;
    scale.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scale.duration = self.duration;
    
    CABasicAnimation *alpha = [CABasicAnimation animation];
    alpha.keyPath = @"opacity";
    alpha.fromValue = @1;
    alpha.toValue = @0.0;
    alpha.duration = self.duration;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[keyFrame,scale,alpha];
    group.duration = self.duration;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [layer addAnimation:group forKey:@"group"];
    
    [array addObject:layer];
    
}

-(CGFloat)randomFloat
{
    return (arc4random()%100)/100.0f;
}

@end
