//
//  FGAngryBirdsView.m
//  FGProject
//
//  Created by Bert on 2016/12/29.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGAngryBirdsView.h"

@interface FGAngryBirdsView ()<CAAnimationDelegate,UICollisionBehaviorDelegate>

@end

@implementation FGAngryBirdsView
{
    UIView *bgView;
    NSMutableArray *groupPointArr ;
    NSMutableArray *groupImagesArr ;
    UIView *tempGroupView;
    UITapGestureRecognizer *singleTap;
    UIImageView *currentTapBirdView;
}

static NSInteger groupBirdCount = 0;
static NSInteger endGroupBirdNumber = 0;
static NSString *keyDropDowningAnimationGroup = @"positionKeyGroupDropDonwing";//掉落过程
static NSString *keyDropDownEndAnimationGroup = @"positionKeyGroupDropDonwEnd";//掉落过程

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        groupPointArr = [NSMutableArray array];
        groupImagesArr  = [NSMutableArray array];
        [self initWaveValue];
        
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGroupImageView:)]; // 设置手势
        
        bgView = ({
            UIView *view = [[UIView alloc]init];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            view;
        });
        
        // 添加通知(处理从后台进来后的情况)
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(groupBirdsAnimation)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        [self groupBirdsAnimation];
        
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
    [tempGroupView removeFromSuperview];
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
    [groupPointArr removeAllObjects];
    groupPointArr = nil;
    groupPointArr = [NSMutableArray array];
    
}

- (void)groupBirdsAnimation{
    NSInteger numberBirds = arc4random()%10+1;
    groupBirdCount = numberBirds;
    tempGroupView = ({
        UIView *view = [[UIView alloc]init];
        [bgView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        view.tag = 20000;
        view;
    });
    
    for (NSInteger i = 0; i < numberBirds; i ++){
        UIImageView *imageView =  ({
            UIImageView *imgView = [[UIImageView alloc]init];
            [tempGroupView addSubview:imgView];
            CGFloat width = arc4random()%50 + 20;
            
            if (i != 0 ){
                imgView.frame = CGRectMake(-arc4random()%100+20,arc4random()%20,width , width);
            }else{
                imgView.frame = CGRectMake(-100,0,100 , 100);
            }
            imgView.userInteractionEnabled = YES;
            imgView.tag = 100 + i;
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView;
        });
        
        [groupImagesArr addObject:imageView];
        
        if ([imageView isAnimating]){
            return;
        }
        
        NSMutableArray *imageArr = [NSMutableArray array];
        for (int i = 0; i < 5; i ++){
            [imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"angrybird_0%d",i+1]]];
        }

        [imageView setAnimationImages:imageArr];
        [imageView setAnimationDuration:imageArr.count *0.35];
        [imageView setAnimationRepeatCount:0];
        [imageView startAnimating];
        
        [imageArr removeAllObjects];
        imageArr = nil;

        [tempGroupView addGestureRecognizer:singleTap]; // 给图片添加手势
    }
    
    for (NSInteger i = 0; i < numberBirds; i ++){
        float y = arc4random()%50 + 20;
        self.waveHeight = y;
        NSMutableArray *tempArr = [NSMutableArray array];
        if (i %2 == 0){
            for (float x = -100; x <= kScreenWidth+100; x ++){
                //y=Acos(wx+Φ)+B
                y = 5*self.wave*cos(2*M_PI/self.w*x + self.b) + self.waveHeight;
                [tempArr addObject:NSStringFromCGPoint(CGPointMake(x, y))];
            }
        }else{
            for (float x = -100; x <= kScreenWidth+100; x ++){
                //y=Asin(wx+Φ)+B
                y = 5*self.wave*sin(2*M_PI/self.w*x + self.b) + self.waveHeight;
                [tempArr addObject:NSStringFromCGPoint(CGPointMake(x, y))];
            }
        }
        
        [groupPointArr addObject:tempArr];
    }
    
    [self drawGroupLineWithGroupPointArr:groupPointArr imageViewArr:groupImagesArr];
}

#pragma mark -
#pragma mark --- 绘制群鸟的路径
- (void)drawGroupLineWithGroupPointArr:(NSMutableArray *)pointsArr imageViewArr:(NSMutableArray*)imageViewArr{
    
    for (NSInteger i = 0; i < imageViewArr.count; i ++){
        UIImageView *imageView = (UIImageView*)imageViewArr[i];
        NSMutableArray *tepPointsArr = pointsArr[i];
        
        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        circlePath.lineWidth = 0.0;//设置1就可以显示出来了,这里隐藏了
        circlePath.lineCapStyle = kCGLineCapRound;
        circlePath.lineJoinStyle = kCGLineJoinRound;
        
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        circleLayer.lineCap = kCALineCapRound;
        circleLayer.lineJoin =  kCALineJoinRound;
        // 设置填充颜色
        circleLayer.fillColor = [UIColor clearColor].CGColor;
        // 设置线宽
        circleLayer.lineWidth =0.0;//设置1就可以显示出来了,这里隐藏了
        // 设置线的颜色
        circleLayer.strokeColor = RGBA(255,255,255,1.0).CGColor;
        circleLayer.strokeEnd = 1.0;
        circleLayer.strokeStart = 0.0;
        for (int i = 0; i < tepPointsArr.count; i ++){
            if (i == 0){
                [circlePath moveToPoint:CGPointFromString(tepPointsArr[i]) ];
            }else{
                [circlePath addLineToPoint:CGPointFromString(tepPointsArr[i])];
            }
        }
        circleLayer.path = circlePath.CGPath;

        CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnima.duration = 15.5f;
        pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnima.fillMode = kCAFillModeForwards;
        pathAnima.removedOnCompletion = YES;
        pathAnima.repeatCount = 1;
        [circleLayer addAnimation:pathAnima forKey:@"strokeEndAnimation1"];
        
        [tempGroupView.layer addSublayer:circleLayer];
        
        [imageView.layer addAnimation:[self setupStartLiveCircularAnimationPath:circlePath withRepatCount:5] forKey:@"Stroken1"];
        
    }
}

- (CAKeyframeAnimation *)setupStartLiveCircularAnimationPath:(UIBezierPath *)path withRepatCount:(NSInteger)repeatCount{
    CAKeyframeAnimation *orbit = [CAKeyframeAnimation animation];
    orbit.keyPath = @"position";
    orbit.path = path.CGPath;
    orbit.duration = 10;
    orbit.additive = YES;
    orbit.repeatCount = repeatCount;
    orbit.calculationMode = kCAAnimationPaced;
    orbit.rotationMode = nil;
    orbit.removedOnCompletion = NO;//到了那个移动位置后,是否返回
    orbit.delegate = self;
    orbit.fillMode = kCAFillModeForwards;
    return orbit;
}

#pragma mark -
#pragma mark --- 添加碰撞效果
- (void)setupGravityBehaviorWithImageView:(UIImageView*)imageView{
    // 初始化力学动画生成器
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc]initWithReferenceView:self];
    
    // 创建重力下落效果的对象
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc]initWithItems:@[imageView]];
    
    //设置重力加速度，水平和竖直方向
    [gravityBehavior setGravityDirection:CGVectorMake(0.0f, 1.0f)];
    gravityBehavior.magnitude = 100;//下降速度
    
    // 创建碰撞效果的对象
    UICollisionBehavior* collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[imageView]];
    
    // 物体的碰撞模式共有三种：UICollisionBehaviorModeItems(物体相互碰撞)
//    UICollisionBehaviorModeBoundaries（物体不相互碰撞，只与边界碰撞）
//    UICollisionBehaviorModeEverything（既与物体碰撞又与边界碰撞）
    [collisionBehavior setCollisionMode:UICollisionBehaviorModeEverything];
    
    //此代码的作用是将self.view的边框作为碰撞边界，必须设置为YES，否则不会生成碰撞效果
    collisionBehavior.translatesReferenceBoundsIntoBoundary =YES;
    
    [animator addBehavior:gravityBehavior];
    [animator addBehavior:collisionBehavior];
    
    collisionBehavior.collisionDelegate =self;
}

#pragma mark -
#pragma mark --- UICollisionBehaviorDelegate
-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p{
    NSLog(@"开始碰撞时触发的方法");
}

-(void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier{
    NSLog(@"结束碰撞时触发的方法");
}

#pragma mark -
#pragma mark --- 添加手势
- (void)tapGroupImageView:(UITapGestureRecognizer*)sender{
    CGPoint touchPoint = [sender locationInView:bgView];
    for (UIImageView *imageView in groupImagesArr){
        if ([imageView.layer.presentationLayer hitTest:touchPoint])
        {
            [[SoundsProcess shareInstance] playSoundOfTock];
            currentTapBirdView = imageView;
          
            [self dropBirdAnimationImagesWithImageView:imageView];
            [self dropBirdCABasicAnimationWithImageView:imageView point:touchPoint];
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
            [self restartBirdsAnimation];
        }
    }
}

#warning --- 当进入后台重新打开,绘制的线不能清除
- (void)restartBirdsAnimation{
    [self clerarGroupBirdsAnimation];
    [self groupBirdsAnimation];
    endGroupBirdNumber = 0;
    currentTapBirdView = nil;
}

@end
