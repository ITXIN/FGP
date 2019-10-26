//
//  FGAngryBirdsView.m
//  FGProject
//
//  Created by Bert on 2016/12/29.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGAngryBirdsView.h"

@interface FGAngryBirdsView ()<CAAnimationDelegate,UICollisionBehaviorDelegate>
{
    NSMutableArray *groupImagesArr ;
    UITapGestureRecognizer *singleTap;
    UIImageView *currentTapBirdView;
}
@end

@implementation FGAngryBirdsView

static NSInteger groupBirdCount = 0;
static NSInteger endGroupBirdNumber = 0;
static NSString *keyDropDowningAnimationGroup = @"positionKeyGroupDropDonwing";//掉落过程
static NSString *keyDropDownEndAnimationGroup = @"positionKeyGroupDropDonwEnd";//掉落过程

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        groupImagesArr  = [NSMutableArray array];
        [self initWaveValue];
        
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGroupImageView:)]; // 设置手势
        // 添加通知(处理从后台进来后的情况)
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(groupBirdsAnimation)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
    }
    return self;
}

#pragma mark 初始化波浪参数
- (void)initWaveValue{
    self.b = 0.0;
    //公式中用到(起始幅度)
    self.wave = 1.5;
    //起始Y值
    self.waveHeight = kScreenWidth/7;
    //起始频率
    self.w = 180;
}

#pragma mark -
#pragma mark --- 一群鸟
- (void)clerarGroupBirdsAnimation{
    for (NSInteger i = 0; i < groupImagesArr.count; i ++){
        UIImageView *imagesView = groupImagesArr[i];
        [imagesView stopAnimating];
        [imagesView.layer removeAllAnimations];
        [imagesView.layer removeFromSuperlayer];
        [imagesView removeFromSuperview];
        imagesView = nil;
    }
    [groupImagesArr removeAllObjects];
    groupImagesArr = nil;
    groupImagesArr = [NSMutableArray array];
    
}

- (void)groupBirdsAnimation{
    NSInteger numberBirds = arc4random()%10+1;
    groupBirdCount = numberBirds;
    groupBirdCount = 6;
    [self addGestureRecognizer:singleTap]; // 给图片添加手势
    
    NSMutableArray *imageArr = [NSMutableArray array];
    for (int i = 0; i < 3; i ++){
        [imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"angrybird_0%d",i+1]]];
    }
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    path2.lineWidth = 5.0;
    path2.lineCapStyle = kCGLineCapRound;
    path2.lineJoinStyle = kCGLineJoinRound;
    [path2 moveToPoint:CGPointMake(10, 50)];
    [path2 addCurveToPoint:CGPointMake(kScreenWidth, 100) controlPoint1:CGPointMake(kScreenWidth/3*1, 20) controlPoint2:CGPointMake(kScreenWidth/2, 50)];//两个切点
    for (NSInteger i = 0; i < groupBirdCount; i ++){
        CGFloat width = arc4random()%50 + 30;
        UIImageView *imageView =  ({
            UIImageView *imgView = [[UIImageView alloc]init];
            [self addSubview:imgView];
            if (i != 0 ){
                imgView.frame = CGRectMake(-arc4random()%100+20,arc4random()%20,width , width);
            }else{
                width = 100;
                imgView.frame = CGRectMake(-100,0,width , width);
                
            }
            imgView.userInteractionEnabled = YES;
            imgView.tag = 100 + i;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView;
        });
        imageView.image = imageArr[0];
        [groupImagesArr addObject:imageView];
        [imageView.layer addAnimation:[self setupStartLiveCircularAnimationPath:path2] forKey:@"Stroken1"];
        if (width>=50) {
            FGLOG(@"---width %f",width);
            [imageView setAnimationImages:imageArr];
            [imageView setAnimationDuration:imageArr.count *0.35];
            [imageView setAnimationRepeatCount:0];
            [imageView startAnimating];
        }
    }
    
    [imageArr removeAllObjects];
    imageArr = nil;
    
}

- (CAKeyframeAnimation *)setupStartLiveCircularAnimationPath:(UIBezierPath *)path{
    CAKeyframeAnimation * orbit = [CAKeyframeAnimation animation];
    orbit.keyPath = @"position";
    orbit.path = path.CGPath;
    orbit.duration = 10;
    orbit.additive = YES;
    orbit.repeatCount = HUGE_VAL;
    orbit.calculationMode = kCAAnimationPaced;
    orbit.rotationMode = nil;
    orbit.removedOnCompletion = NO;//到了那个移动位置后,是否返回
    orbit.delegate = self;
    orbit.fillMode = kCAFillModeForwards;
    return orbit;
}

#pragma mark -
#pragma mark --- UICollisionBehaviorDelegate
-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p{
    FGLOG(@"开始碰撞时触发的方法");
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier{
    FGLOG(@"结束碰撞时触发的方法");
}

#pragma mark -
#pragma mark --- 添加手势
- (void)tapGroupImageView:(UITapGestureRecognizer*)sender{
    CGPoint touchPoint = [sender locationInView:self];
    for (UIImageView *imageView in groupImagesArr){
        if ([imageView.layer.presentationLayer hitTest:touchPoint]){
            [[SoundsProcess shareInstance] playSoundOfTock];
            currentTapBirdView = imageView;
            [self dropBirdAnimationImagesWithImageView:imageView];
            [self dropBirdCABasicAnimationWithImageView:imageView point:touchPoint];
            return;
        }
    }
}

#pragma mark - 掉落过程中
#pragma mark --- drop animation
- (void)dropBirdAnimationImagesWithImageView:(UIImageView*)imageView{
    if ([imageView isAnimating]){
        [imageView.layer removeAllAnimations];
        [imageView stopAnimating];
    }
    
    NSMutableArray *imageArr = [NSMutableArray array];
    for (int i = 0; i < 7; i ++){
        [imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"dropbird_0%d",i]]];
    }
    
    [imageView setAnimationImages:imageArr];
    [imageView setAnimationDuration:imageArr.count *0.35];
    [imageView setAnimationRepeatCount:0];
    [imageView startAnimating];
    [imageArr removeAllObjects];
    imageArr = nil;
}

#pragma mark -
#pragma mark --- drop CABasicAnimation
- (void)dropBirdCABasicAnimationWithImageView:(UIImageView*)imageView point:(CGPoint)point{
    CAAnimationGroup *group = [CAAnimationGroup animation];
    CGFloat duration = 1.5;
    CGFloat repeatCount = 1.0;
    NSMutableArray *animationArr = [NSMutableArray array];
    {
        CABasicAnimation *animation =
        [CABasicAnimation animationWithKeyPath:@"position"];
        animation.fromValue = [NSValue valueWithCGPoint:point]; // 起始点
        animation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x+10, kScreenHeight-10)]; // 终了点
        animation.repeatCount = repeatCount;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.duration = duration;
        [animationArr addObject:animation];
    }
    
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        // 动画选项设定
        animation.duration = duration; // 动画持续时间
        animation.repeatCount = repeatCount; // 重复次数
        animation.autoreverses = NO; // 动画结束时执行逆动画
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        // 缩放倍数
        animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
        animation.toValue = [NSNumber numberWithFloat:0.2]; // 结束时的倍率
        [animationArr addObject:animation];
    }
    group.duration = duration;
    group.animations = animationArr;
    group.delegate = self;
    
    //动画不会逆执行
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    [imageView.layer addAnimation:group forKey:keyDropDowningAnimationGroup];
}

#pragma mark -
#pragma mark --- 掉落到底部时设置新的动画
- (void)dropDownEndAnimationWithImageView:(UIImageView*)imageView{
    [imageView stopAnimating];
    NSMutableArray *imageArr = [NSMutableArray array];
    for (int i = 0; i < 2; i ++){
        [imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"drop_angry_bird_0%d",i]]];
    }
    
    [imageView setAnimationImages:imageArr];
    [imageView setAnimationDuration:imageArr.count *0.35];
    [imageView setAnimationRepeatCount:0];
    [imageView startAnimating];
    [imageArr removeAllObjects];
    imageArr = nil;
}

- (void)dropDownEndCABasicAnimationWithImageView:(UIImageView*)imageView{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    animation.duration = 0.75; // 动画持续时间
    animation.repeatCount = 1; // 重复次数
    animation.autoreverses = NO; // 动画结束时执行逆动画
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:0.2]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.5]; // 结束时的倍率
    
    [imageView.layer addAnimation:animation forKey:@"dropDownEnd"];
}

#pragma mark -
#pragma mark --- <CAAnimationDelegate>
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag){
        endGroupBirdNumber ++;
        if (currentTapBirdView){
            //对点击的图片的处理
            if ([currentTapBirdView.layer animationForKey:keyDropDowningAnimationGroup] == anim){
                [self dropDownEndAnimationWithImageView:currentTapBirdView];
                [self dropDownEndCABasicAnimationWithImageView:currentTapBirdView];
            }
        }
        
        if (endGroupBirdNumber == groupBirdCount){
            [self startBirdsAnimation];
        }
    }
}

#warning --- 当进入后台重新打开,绘制的线不能清除
- (void)startBirdsAnimation{
    //    [self clerarGroupBirdsAnimation];
    [self groupBirdsAnimation];
    //    endGroupBirdNumber = 0;
    //    currentTapBirdView = nil;
}

@end
