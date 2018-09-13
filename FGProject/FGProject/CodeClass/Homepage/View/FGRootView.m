//
//  FGRootView.m
//  FGProject
//
//  Created by pingan on 2018/8/7.
//  Copyright © 2018年 bert. All rights reserved.
//

#import "FGRootView.h"
#import "CARadarView.h"
#import "WaterRippleView.h"
@implementation FGRootView
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

- (void)initSubviews{
    [super initSubviews];
    
    
    bgView = ({
        UIView *view = [[UIView alloc]init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        view;
    });
    
    
    self.myWaterView = [[WaterRippleView alloc] initWithFrame:CGRectMake(0, kScreenHeight/2, kScreenWidth, kScreenHeight/2)
                                              mainRippleColor:[UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:0.7]
                                             minorRippleColor:[UIColor colorWithRed:84/255.0f green:200/255.0f blue:120/255.0f alpha:0.5]
                                            mainRippleoffsetX:6.0f
                                           minorRippleoffsetX:1.1f
                                                  rippleSpeed:2.0f
                                               ripplePosition:kScreenHeight/2-100//高度
                                              rippleAmplitude:15.0f];
    self.myWaterView.backgroundColor = UIColor.clearColor;
    [self addSubview:self.myWaterView];
    
    
    UILabel *tempLab = ({
        UILabel *label = [UILabel new];
        [self addSubview:label];
        label.text = @"🦑";
        label;
    });
    
    
    NSArray *arr = @[@"🦑",@"🐲",@"🐢",@"🐟",@"🦀️",@"🦐",@"🐳",@"🦈",@"🐬"];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    
    
    
    //太阳
    _sunImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth+50, kScreenHeight/6, kScreenWidth/10, kScreenWidth/10)];
    _sunImgView.image = [UIImage imageNamed:@"taiyang-03"];
    [self addSubview:_sunImgView];
    
    //晃动动画
    CABasicAnimation *basicAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnim.toValue = [NSNumber numberWithFloat:M_PI_2/7];
    basicAnim.duration = 2.0;
    basicAnim.autoreverses = YES;
    basicAnim.repeatCount = HUGE_VAL;
    basicAnim.removedOnCompletion = NO;
    basicAnim.fillMode = kCAFillModeForwards;
    
    basicAnim.toValue = [NSNumber numberWithFloat:M_PI_2/9];
    [_sunImgView.layer addAnimation:basicAnim forKey:@"KCBasicAnimation_Rotation"];
    
    //太阳移动
    CAKeyframeAnimation *basicAnimX = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    basicAnimX.duration = 50.0;
    basicAnimX.autoreverses = NO;
    basicAnimX.repeatCount = HUGE_VAL;
    basicAnimX.removedOnCompletion = NO;
    
    //以原点和半径
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(kScreenHeight, kScreenHeight/3*4) radius:kScreenHeight startAngle:M_PI endAngle:M_PI*2 clockwise:true];
    // 设置贝塞尔曲线路径
    basicAnimX.path = circlePath.CGPath;
    [_sunImgView.layer addAnimation:basicAnimX forKey:@"KCBasicAnimation_RotationX"];
    
    
    groupPointArr = [NSMutableArray array];
    groupImagesArr  = [NSMutableArray array];
    [self initWaveValue];
    [self startBirdsAnimation];
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
        
//        [tempGroupView addGestureRecognizer:singleTap]; // 给图片添加手势
    }
    
    for (NSInteger i = 0; i < numberBirds; i ++){
        float y = kScreenHeight - 100 + arc4random()%50 + 20;
        self.waveHeight = y;
        NSMutableArray *tempArr = [NSMutableArray array];
        if (i %2 == 0){
            for (float x = -20; x <= kScreenWidth+50; x ++){
                //y=Acos(wx+Φ)+B
                y = 5*self.wave*cos(2*M_PI/self.w*x + self.b) + self.waveHeight;
                [tempArr addObject:NSStringFromCGPoint(CGPointMake(x, y))];
            }
        }else{
            for (float x = -20; x <= kScreenWidth+50; x ++){
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
        circlePath.lineWidth = 1.0;//设置1就可以显示出来了,这里隐藏了
        circlePath.lineCapStyle = kCGLineCapRound;
        circlePath.lineJoinStyle = kCGLineJoinRound;
        
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        circleLayer.lineCap = kCALineCapRound;
        circleLayer.lineJoin =  kCALineJoinRound;
        // 设置填充颜色
        circleLayer.fillColor = [UIColor clearColor].CGColor;
        // 设置线宽
        circleLayer.lineWidth = 1.0;//设置1就可以显示出来了,这里隐藏了
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
        
        [imageView.layer addAnimation:[self setupStartLiveCircularAnimationPath:circlePath withRepatCount:10] forKey:@"Stroken1"];
        
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
#pragma mark --- <CAAnimationDelegate>
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag){
        endGroupBirdNumber ++;
        if (currentTapBirdView){
            //对点击的图片的处理
//            if ([currentTapBirdView.layer animationForKey:keyDropDowningAnimationGroup] == anim){
//                [self dropDownEndAnimationWithImageView:currentTapBirdView];
//                [self dropDownEndCABasicAnimationWithImageView:currentTapBirdView];
//            }
        }
        
        if (endGroupBirdNumber == groupBirdCount){
            [self startBirdsAnimation];
        }
    }
}

#warning --- 当进入后台重新打开,绘制的线不能清除
- (void)startBirdsAnimation{
    [self clerarGroupBirdsAnimation];
    [self groupBirdsAnimation];
    endGroupBirdNumber = 0;
    currentTapBirdView = nil;
}


#pragma mark -
- (void)tapAction:(UITapGestureRecognizer*)ges{
    UIImageView *img = (UIImageView*)ges.view;
    CGRect temp = img.frame;
    [UIView animateWithDuration:0.5 animations:^{
        img.frame = CGRectMake(CGRectGetMinX(img.frame)+100, -100, CGRectGetWidth(img.frame)-50, CGRectGetHeight(img.frame)-50);
    }completion:^(BOOL finished) {
        img.alpha = 0.0;
        img.frame = temp;
    }];
}

//- (void)setupSubviewsLayout{
//    [super setupSubviewsLayout];
//
//    [self.redImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(100);
//        make.top.mas_equalTo(100);
//        make.size.mas_equalTo(CGSizeMake(60, 130));
//    }];
//
//    [self.yellowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.redImageView);
//        make.right.mas_equalTo(-100);
//        make.size.equalTo(self.redImageView);
//    }];
//}

@end
