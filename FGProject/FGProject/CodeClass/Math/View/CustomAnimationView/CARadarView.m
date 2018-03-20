//
//  CARadarView.m
//  FGProject
//
//  Created by Bert on 2016/11/21.
//  Copyright © 2016年 XL. All rights reserved.
// 雷达
//  Created by catch on 16/7/12.
//  Copyright © 2016年 catch. All rights reserved.
//
#import "CARadarView.h"
@interface CARadarView()

@property (nonatomic, strong) CAShapeLayer *pulseLayer;
@property (nonatomic, strong) CAReplicatorLayer *replicatorLayer;
@property (nonatomic, strong) CAAnimationGroup *animaGroup;
@property (nonatomic, strong) CABasicAnimation *opacityAnima;

@end
@implementation CARadarView
#pragma mark -- Init

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    self.fillColor = [UIColor colorWithRed:53/255.0 green:190/255.0 blue:46/255.0 alpha:0.8];
    self.instanceCount = 10;// 圈数
    self.instanceDelay = 0.75;//间隔
    self.animationDuration = self.instanceCount*self.instanceDelay;
    self.opacityValue = 0.46f;//透明度
    
}

#pragma mark -- Public Method

-(void)startAnimation{
    if (![self.layer.sublayers containsObject:self.replicatorLayer]) {
        [self.layer addSublayer:self.replicatorLayer];
    }
    
    [self.pulseLayer removeAllAnimations];
    [self.pulseLayer addAnimation:self.animaGroup forKey:@"groupAnimation"];
}

-(void)stopAnimation{
    if (_pulseLayer) {
        [_pulseLayer removeAllAnimations];
    }
}

#pragma mark -- Setters & Getters

-(void)setFillColor:(UIColor *)fillColor{
    _fillColor = fillColor;
    self.pulseLayer.fillColor = fillColor.CGColor;
}

-(void)setInstanceCount:(NSInteger)instanceCount{
    _instanceCount = instanceCount;
    self.replicatorLayer.instanceCount = instanceCount;
}

-(void)setInstanceDelay:(CFTimeInterval)instanceDelay{
    _instanceDelay = instanceDelay;
    self.replicatorLayer.instanceDelay = instanceDelay;
}

-(void)setOpacityValue:(CGFloat)opacityValue{
    _opacityValue = opacityValue;
    self.opacityAnima.fromValue = @(opacityValue);
}

-(void)setAnimationDuration:(CFTimeInterval)animationDuration{
    _animationDuration = animationDuration;
    self.animaGroup.duration = animationDuration;
}

- (CAShapeLayer *)pulseLayer {
    if(_pulseLayer == nil) {
        _pulseLayer = [CAShapeLayer layer];
        _pulseLayer.frame = self.layer.bounds;
        _pulseLayer.path = [UIBezierPath bezierPathWithOvalInRect:_pulseLayer.bounds].CGPath;
//        _pulseLayer.path = [UIBezierPath bezierPathWithRect:_pulseLayer.bounds].CGPath;//正方形
        //        _pulseLayer.path = [UIBezierPath bezierPathWithOvalInRect:_pulseLayer.bounds].CGPath;//椭圆,和圆差不多
        //        _pulseLayer.path = [UIBezierPath bezierPathWithRoundedRect:_pulseLayer.bounds cornerRadius:CGRectGetWidth(self.frame)/2].CGPath;//圆角矩形,通过设置可以绘制圆
        //        _pulseLayer.path = [UIBezierPath bezierPathWithArcCenter:self.center radius:100 startAngle:0 endAngle:M_PI*2 clockwise:YES].CGPath;//当设置 x和y时会从向下角执行,否则是在中心点执行
        /*
         当 path = [UIBezierPath bezierPathWithArcCenter:self.center radius:100 startAngle:0 endAngle:M_PI*2 clockwise:YES].CGPath;
         例如:
         CARadarView *radarView = [[CARadarView alloc]initWithFrame:CGRectMake(0, 0,200, 200)];//在中心点执行
         CARadarView *radarView = [[CARadarView alloc]initWithFrame:CGRectMake(110, 110,200, 200)];//x和y时会从向下角执行
         [self.view addSubview:radarView];
         radarView.center = self.view.center;
         radarView.fillColor = [UIColor redColor];
         radarView.opacityValue = 0.9;
         [radarView startAnimation];
         */
        
        
        _pulseLayer.fillColor = [UIColor blueColor].CGColor;
        _pulseLayer.opacity = 0.0;
    }
    return _pulseLayer;
}

- (CAReplicatorLayer *)replicatorLayer {
    if(_replicatorLayer == nil) {
        _replicatorLayer = [CAReplicatorLayer layer];
        _replicatorLayer.frame = self.bounds;
        _replicatorLayer.instanceCount = 6;
        _replicatorLayer.instanceDelay = 1.5;
        [_replicatorLayer addSublayer:self.pulseLayer];
    }
    return _replicatorLayer;
}

- (CAAnimationGroup *)animaGroup {
    if(_animaGroup == nil) {
        CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
        scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
        
        scaleAnima.removedOnCompletion = NO;
        
        _animaGroup = [CAAnimationGroup animation];
        _animaGroup.animations = @[self.opacityAnima, scaleAnima];
        _animaGroup.duration = 9;
        _animaGroup.autoreverses = NO;
        _animaGroup.repeatCount = HUGE;
        
        _animaGroup.removedOnCompletion = NO;
    }
    return _animaGroup;
}

- (CABasicAnimation *)opacityAnima {
    if(_opacityAnima == nil) {
        _opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
        _opacityAnima.fromValue = @(0.3);
        _opacityAnima.toValue = @(0.0);
        _opacityAnima.removedOnCompletion = NO;
    }
    return _opacityAnima;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.pulseLayer.frame = self.bounds;
    self.replicatorLayer.frame = self.bounds;
}
@end
