//
//  WaterWaveView.m
//  FGProject
//
//  Created by Bert on 16/2/2.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "WaterWaveView.h"
#import "WaterRippleView.h"

@implementation WaterWaveView
{
    NSInteger number;
    CGFloat tempRipplePosition;
    CAShapeLayer *circleLayer;
    NSMutableArray *positinArr;
}
/*
 - (void)drawRect:(CGRect)rect{
 [super drawRect:rect];
 if (x >= rect.size.width){
 x = 0;
 }
 
 int y1 = ((int)( self.waveHeight) + 1);
 //当大于一定高度,帆船消失换为另外的图片
 if (y1 <= rect.size.height/3){
 x += 2;
 int y2 = 10;
 UIImage *image = [UIImage imageNamed:@"fish-01"];
 if ((int)x == (int)rect.size.width/2 || (int)x == (int)rect.size.width/4 || (int)x == (int)rect.size.width/4*3){
 y2 = 30;
 image = [self imageRotatedByDegrees:90.f image:image];
 [image drawInRect:CGRectMake(x, y1- rect.size.width/4/2-(y2), rect.size.width/4, rect.size.width/4)];
 }else{
 [image drawInRect:CGRectMake(x, y1- rect.size.width/4/2-(y2), rect.size.width/4, rect.size.width/4)];
 }
 }else{
 x ++;
 [sailngImage drawInRect:CGRectMake(x, y1- rect.size.width/3+(arc4random()%(4+1)), rect.size.width/3, rect.size.width/3)];
 }
 //这个方法会把背景颜色清理掉
 //  CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
 }
 */
-(CGFloat)DegreesToRadians:(CGFloat)degress{
    return degress*M_PI/180.0;
}

//旋转
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees image:(UIImage *)m_getImageView{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,m_getImageView.size.width, m_getImageView.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation([self DegreesToRadians:degrees]);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    // // Rotate the image context
    CGContextRotateCTM(bitmap, [self DegreesToRadians:degrees]);
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-m_getImageView.size.width / 2, -m_getImageView.size.height / 2, m_getImageView.size.width, m_getImageView.size.height), [m_getImageView CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImageView *)sailngImageView{
    if (!_sailngImageView) {
        _sailngImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sailing"]];
        _sailngImageView.frame = CGRectMake(0, -20, 30, 30);
        [self insertSubview:_sailngImageView belowSubview:_countLab];
    }
    return _sailngImageView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = RGBA(255, 255, 255, 1);
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.masksToBounds = YES;
        
        number = 0;
        self.count = [[FGMathOperationManager shareMathOperationManager] getCurrentDateHasDone];
        
        _myWaterView = [[WaterRippleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/7, kScreenWidth/7)
                                              mainRippleColor:[UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1]
                                             minorRippleColor:[UIColor colorWithRed:84/255.0f green:200/255.0f blue:120/255.0f alpha:1]
                                            mainRippleoffsetX:1.0f
                                           minorRippleoffsetX:1.1f
                                                  rippleSpeed:2.0f
                                               ripplePosition:20.0f//高度
                                              rippleAmplitude:5.0f];
        _myWaterView.layer.cornerRadius = kScreenWidth/7/2;
        _myWaterView.layer.masksToBounds = YES;
        [self addSubview:_myWaterView];
        self.myWaterView.ripplePosition = CGRectGetHeight(self.myWaterView.frame) -  CGRectGetHeight(self.myWaterView.frame)*_count/DATA_WAVE_HEIGHT_SCALE;
        
        _countLab = [[UILabel alloc]initWithFrame:self.bounds];
        [_countLab setText:@"0"];
        _countLab.textAlignment = NSTextAlignmentCenter;
        _countLab.textColor = [UIColor lightGrayColor];
        _countLab.font = [UIFont boldSystemFontOfSize:50.f];
        [self addSubview:_countLab];
        
        self.titleLab = ({
            UILabel *label = [[UILabel alloc]init];
            [self addSubview:label];
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont boldSystemFontOfSize:14.0];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-10);
                make.centerX.equalTo(self);
            }];
            label.text = @"今日完成";
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
        
        [self initWaveValue];
    }
    
    return self;
}

#pragma mark 初始化波浪参数
- (void)initWaveValue{
    //公式中用到(起始幅度)
    self.wave = 1.5;
    //起始频率
    self.w = 90.0;
    self.b = 0.0;
}

- (void)setupBoardAnimation{
    //清除以前的
    [self.sailngImageView removeFromSuperview];
    self.sailngImageView = nil;
    
    NSInteger i = arc4random() %10;
    float y = self.waveHeight;
    if (!positinArr) {
        positinArr = [NSMutableArray array];
    }else{
        [positinArr removeAllObjects];
    }
    if (i %2 == 0){
        for (float x = 0; x <= kScreenWidth/7; x ++){
            //y=Acos(wx+Φ)+B
            y = 5*self.wave*cos(2*M_PI/self.w*x + self.b) + self.waveHeight;
            [positinArr addObject:NSStringFromCGPoint(CGPointMake(x, y))];
        }
    }else{
        for (float x = 0; x <= kScreenWidth/7; x ++){
            //y=Asin(wx+Φ)+B
            y = 5*self.wave*sin(2*M_PI/self.w*x + self.b) + self.waveHeight;
            [positinArr addObject:NSStringFromCGPoint(CGPointMake(x, y))];
        }
    }
    
    [self drawBoardLine];
}

#pragma mark -
#pragma mark --- 绘制路径
- (void)drawBoardLine{
    
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    circlePath.lineWidth = 0.0;//设置1就可以显示出来了,这里隐藏了
    circlePath.lineCapStyle = kCGLineCapRound;
    circlePath.lineJoinStyle = kCGLineJoinRound;
    
    if (!circlePath) {
        circleLayer = [CAShapeLayer layer];
        circleLayer.lineCap = kCALineCapRound;
        circleLayer.lineJoin =  kCALineJoinRound;
        // 设置填充颜色
        circleLayer.fillColor = [UIColor clearColor].CGColor;
        // 设置线宽
        circleLayer.lineWidth = 0.0;//设置1就可以显示出来了,这里隐藏了
        // 设置线的颜色
        circleLayer.strokeColor = UIColor.redColor.CGColor;
        circleLayer.strokeEnd = 1.0;
        circleLayer.strokeStart = 0.0;
        [self.layer addSublayer:circleLayer];
    }
    
    for (int i = 0; i < positinArr.count; i ++){
        if (i == 0){
            [circlePath moveToPoint:CGPointFromString(positinArr[i]) ];
        }else{
            [circlePath addLineToPoint:CGPointFromString(positinArr[i])];
        }
    }
    circleLayer.path = circlePath.CGPath;
    
    [self.sailngImageView.layer addAnimation:[self setupStartLiveCircularAnimationPath:circlePath withRepatCount:INT_MAX] forKey:@"Stroken1"];
}

- (CAKeyframeAnimation *)setupStartLiveCircularAnimationPath:(UIBezierPath *)path withRepatCount:(NSInteger)repeatCount{
    CAKeyframeAnimation *orbit = [CAKeyframeAnimation animation];
    orbit.keyPath = @"position";
    orbit.path = path.CGPath;
    orbit.duration = 6;
    orbit.additive = YES;
    orbit.repeatCount = repeatCount;
    orbit.calculationMode = kCAAnimationPaced;
    orbit.rotationMode = nil;
    orbit.removedOnCompletion = YES;//到了那个移动位置后,是否返回
    //    orbit.delegate = self;
    orbit.fillMode = kCAFillModeForwards;
    return orbit;
}

#pragma mark -
#pragma mark --- 显示动画
- (void)showAnimationOfWaterWave{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.sailngImageView removeFromSuperview];
        self.sailngImageView = nil;
        self.myWaterView.ripplePosition = [self getRipplePosition];
        tempRipplePosition = self.myWaterView.ripplePosition;
        self.myWaterView.ripplePosition = 0;
        [self countAnimation];
        [self waterWaveAnimation];
    });
}

- (void)countAnimation{
    if (self.count == 0){
        return;
    }
    
//    [UIView animateWithDuration:0.05 animations:^{
        _countLab.text = [NSString stringWithFormat:@"%ld",++number];
//    } completion:^(BOOL finished) {
        if (number >= self.count){
            number = 0;
            return ;
        }else{
            [self performSelector:@selector(countAnimation) withObject:nil afterDelay:0.05];
        }
//    }];
}

- (void)waterWaveAnimation{
    
//    [UIView animateWithDuration:0.05 animations:^{
        self.myWaterView.ripplePosition ++;
//    }completion:^(BOOL finished) {
        if (self.myWaterView.ripplePosition >= tempRipplePosition){
            self.myWaterView.ripplePosition = tempRipplePosition;
            self.waveHeight = self.myWaterView.ripplePosition;
            
            [self setupBoardAnimation];
            return ;
        }else{
            [self performSelector:@selector(waterWaveAnimation) withObject:nil afterDelay:0.05];
        }
//    }];
}

-(void)setCount:(NSInteger)count{
    _count = count;
    dispatch_async(dispatch_get_main_queue(), ^{
        _countLab.text = [NSString stringWithFormat:@"%ld",count];
        self.myWaterView.ripplePosition = [self getRipplePosition];
        
        //解决更新有点频繁
        if (count%10==0) {
            [self.sailngImageView removeFromSuperview];
            self.sailngImageView = nil;
            [self setupBoardAnimation];
        }
    });
}

- (CGFloat)getRipplePosition{
     return CGRectGetHeight(self.myWaterView.frame) -  CGRectGetHeight(self.myWaterView.frame)*_count/DATA_WAVE_HEIGHT_SCALE;
}

@end
