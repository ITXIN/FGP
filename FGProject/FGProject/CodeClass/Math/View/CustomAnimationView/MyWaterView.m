//
//  MyWaterView.m
//  WaterVavesDemo
//
//  Created by Bert on 16/2/1.
//  Copyright © 2016年 Bert. All rights reserved.
//http://blog.it985.com/13697.html

#import "MyWaterView.h"
//static NSInteger pastCout;
@interface MyWaterView()
{
    UIColor *currentWaterColor;
    BOOL isHasBGImage;
    UIImage *image;
}
//公式中用到(起始相位)
@property (assign, nonatomic) float b;
@end
@implementation MyWaterView
-(void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
#warning --- 占用 cup 较高 22%,绘制图片占用 cup 较高
    // Drawing code
    CGContextRef contxt = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    //画水
    CGContextSetLineWidth(contxt, 1);
    CGContextSetFillColorWithColor(contxt, [currentWaterColor CGColor]);
    
    float y = self.waveHeight;
    CGPathMoveToPoint(path, NULL, 0, y);
    for (float x = 0; x <= rect.size.width; x ++)
    {
//        //y=Asin(wx+Φ)+B
////       y = self.wave*sin(x/self.w*M_PI + 4*self.b/M_PI)*5 + self.waveHeight;//原来的
        y =5*self.wave*sin(2*M_PI/self.w*x + self.b) + self.waveHeight;
        CGPathAddLineToPoint(path, nil, x, y);
        
    }

    //从左到右填充颜色
    CGPathAddLineToPoint(path, nil, rect.size.width, rect.size.height);
    CGPathAddLineToPoint(path, nil, 0,rect.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.waveHeight);//成为闭环
    CGContextAddPath(contxt, path);
    CGContextFillPath(contxt);
    CGContextDrawPath(contxt, kCGPathStroke);
    CGPathRelease(path);
    
  
    //绘制 cos()
    CGContextRef contxt1 = UIGraphicsGetCurrentContext();
    CGMutablePathRef path1 = CGPathCreateMutable();
    //画水波
    CGContextSetLineWidth(contxt1, 1);
//    CGContextSetFillColorWithColor(contxt1, [[UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1] CGColor]);
    
    CGContextSetFillColorWithColor(contxt1, currentWaterColor.CGColor );
    float y1 = self.waveHeight;
    CGPathMoveToPoint(path1, NULL, 0, y1);
    for (float x = 0; x <= rect.size.width; x ++)
    {
        y1 =5*self.wave*cos(2*M_PI/self.w*x + self.b) + self.waveHeight;
        CGPathAddLineToPoint(path1, nil, x, y1);
    }
    
    //从左到右填充颜色
    CGPathAddLineToPoint(path1, nil, rect.size.width, rect.size.height);
    CGPathAddLineToPoint(path1, nil, 0,rect.size.height);
    CGPathAddLineToPoint(path1, nil, 0, self.waveHeight);//成为闭环
    CGContextAddPath(contxt1, path1);
    CGContextFillPath(contxt1);
    CGContextDrawPath(contxt1, kCGPathStroke);
    CGPathRelease(path1);
    
    
//    [self drawTextWithRect:rect];
}
- (void)drawTextWithRect:(CGRect)rect
{
    //绘制文字
    //由于一直在绘制清除,遮住了
    CGFloat sizeFont = 50.0;
    CGPoint point ;
    point.x = (rect.size.width - sizeFont)/2;
    point.y = (rect.size.height - sizeFont)/2;
    NSString *str = [NSString stringWithFormat:@"%ld",self.count];
    if (str.length == 1)
    {
        str = [NSString stringWithFormat:@" %ld",self.count];
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //设置文字前景颜色
    dic [NSForegroundColorAttributeName] = [UIColor whiteColor];
    //设置背景颜色
    dic [NSBackgroundColorAttributeName] = [UIColor clearColor];
    dic [NSFontAttributeName] = [UIFont boldSystemFontOfSize:sizeFont];
    [str drawAtPoint:point withAttributes:dic];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self.b = 0.0;
    self = [super initWithFrame:frame];
    if (self)
    {
        isHasBGImage = NO;
        [self setBackgroundColor:[UIColor clearColor]];
        currentWaterColor = [UIColor colorWithRed:86/255.0f green:202/255.0f blue:139/255.0f alpha:1];
//         currentWaterColor = [UIColor colorWithRed:46/255.0f green:173/255.0f blue:151/255.0f alpha:1];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(animateWave) userInfo:nil repeats:YES];
        [self initWaveValue];
    }
    return self;
}

#pragma mark 初始化波浪参数
- (void)initWaveValue
{
    //公式中用到(起始幅度)
    self.wave = 1.5;
    //判断加减
    self.jia = NO;
    //幅度增长速度
    self.waveIncrease = 0.1;
    //减阈值 a
    self.waveMin = 0.97;
    //增阈值 a
    self.waveMax = 1.93;
    //b的增幅（速度控制）
    self.waveSpeed = 0.1;
    //起始Y值
    self.waveHeight = ScreenWidth/7;
    //起始频率
    self.w = 180;
}

- (void)animateWave
{
    if (self.jia == YES) {
        self.wave += self.waveIncrease;
        self.wave = (self.wave < self.waveMin ? self.waveMin : self.wave);
    }else{
        self.wave -= self.waveIncrease;
        self.wave = (self.wave > self.waveMax ? self.waveMax : self.wave);
    }
    
    if (self.wave <= self.waveMin) {
        self.jia = YES;
    }
    
    if (self.wave >= self.waveMax) {
        self.jia = NO;
    }
    
    self.b += self.waveSpeed;
    //该方法会重新调用drawRect方法
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark --- 重写方法

- (void)setCount:(NSInteger)count
{
    _count = count;
}
- (void)setWave:(float)wave
{
    _wave = wave;
    [self upDateLableFromTag:kWave_Tag value:wave];
}

- (void)setWaveIncrease:(float)waveIncrease
{
    _waveIncrease = waveIncrease;
    [self upDateLableFromTag:kWaveIncrease_Tag value:waveIncrease];
}

-(void)setWaveMin:(float)waveMin
{
    _waveMin = waveMin;
    [self upDateLableFromTag:kWaveMin_Tag value:waveMin];
}

- (void)setWaveMax:(float)waveMax
{
    _waveMax = waveMax;
    [self upDateLableFromTag:kWaveMax_Tag value:waveMax];
}

- (void)setWaveSpeed:(float)waveSpeed
{
    _waveSpeed = waveSpeed;
    [self upDateLableFromTag:kSpeed_Tag value:waveSpeed];
}

- (void)setWaveHeight:(float)waveHeight
{
    _waveHeight = waveHeight;
    [self upDateLableFromTag:kHeight_Tag value:waveHeight];
}

- (void)setW:(float)w
{
    _w = w;
    [self upDateLableFromTag:kWaveW_Tag value:w];
}

#pragma mark -
#pragma mark --- 更新显示slider 的数据
- (void)upDateLableFromTag:(NSInteger)tag value:(CGFloat)value
{
//    if (tag == 0) {
//        return;
//    }
//    UIView *parentView = [[self superview] viewWithTag:tag];
//    for (id tempView in parentView.subviews) {
//        if ([tempView isKindOfClass:[UISlider class]]) {
//            UISlider *tempSlider = (UISlider *)tempView;
//            if (tempSlider.tag == tag) {
//                //更新指示器的数值
//                tempSlider.value = value;
//                //更新显示的数据
//                UILabel *tempLabel = (UILabel *)[parentView viewWithTag:showValueLableTag];
//                tempLabel.text = [NSString stringWithFormat:@"%0.2f", value];
//                [tempLabel sizeToFit];
//            }
//        }
//    }
}

@end
