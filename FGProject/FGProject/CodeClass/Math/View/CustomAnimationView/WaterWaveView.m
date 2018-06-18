//
//  WaterWaveView.m
//  FGProject
//
//  Created by Bert on 16/2/2.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "WaterWaveView.h"
static CGFloat x;
@implementation WaterWaveView
{
    NSInteger number;
    CGFloat myWaterWaveHeigh;
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
    if (x >= rect.size.width)
    {
        x = 0;
    }
    
    int y1 = ((int)( self.waveHeight) + 1);
    //当大于一定高度,帆船消失换为另外的图片
    if (y1 <= rect.size.height/3)
    {    x += 2;
        int y2 = 10;
        UIImage *image = [UIImage imageNamed:@"fish-01"];
        //        NSLog(@"----x %f",x);
        if ((int)x == (int)rect.size.width/2 || (int)x == (int)rect.size.width/4 || (int)x == (int)rect.size.width/4*3)
        {
            //            NSLog(@"-----y2 %d",y2);
            y2 = 30;
            image = [self imageRotatedByDegrees:90.f image:image];
            [image drawInRect:CGRectMake(x, y1- rect.size.width/4/2-(y2), rect.size.width/4, rect.size.width/4)];
        }else
        {
            [image drawInRect:CGRectMake(x, y1- rect.size.width/4/2-(y2), rect.size.width/4, rect.size.width/4)];
        }
        
    }else
    {
        x ++;
        [[UIImage imageNamed:@"sailing"] drawInRect:CGRectMake(x, y1- rect.size.width/3+(arc4random()%(4+1)), rect.size.width/3, rect.size.width/3)];
    }
    //这个方法会把背景颜色清理掉
    //  CGContextClearRect(UIGraphicsGetCurrentContext(), rect);
    
    //   NSLog(@"-----self.waveHeight %f - %f",self.waveHeight,rect.size.height);
}

-(CGFloat)DegreesToRadians:(CGFloat)degress
{
    return degress*M_PI/180.0;
}
//旋转
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees image:(UIImage *)m_getImageView
{
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
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //        self.backgroundColor = [UIColor colorWithRed:53/255.0 green:190/255.0 blue:46/255.0 alpha:0.8];
        self.backgroundColor = RGBA(255, 255, 255, 1);
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.masksToBounds = YES;
        //设置背景图片
        //        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        //        [bgImageView setImage:[UIImage imageNamed:@"countNum-bg"]];
        //        [self addSubview:bgImageView];
        
        x = 0;
        _myWaterView = [[MyWaterView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth/7, ScreenWidth/7)];
        _myWaterView.layer.cornerRadius = ScreenWidth/7/2;
        _myWaterView.layer.masksToBounds = YES;
        [self addSubview:_myWaterView];
        number = 0;
        myWaterWaveHeigh = 0;
        //绘制文字占用空间已经 cup 使用情况和在 MyWaterView 一样
        //但是如果要设置文字动画就需要在这设置为属性
        _countLab = [[UILabel alloc]initWithFrame:self.bounds];
        [_countLab setText:@"0"];
        _countLab.textAlignment = NSTextAlignmentCenter;
        _countLab.textColor = [UIColor lightGrayColor];
        _countLab.font = [UIFont boldSystemFontOfSize:50.f];
        [self addSubview:_countLab];
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(animateWaveFish) userInfo:nil repeats:YES];
        self.titleLab = ({
            UILabel *label = [[UILabel alloc]init];
            [self addSubview:label];
            label.textColor = [UIColor lightGrayColor];
            if (@available(iOS 8.2, *)) {
                label.font = [UIFont systemFontOfSize:14 weight:50];
            } else {
                // Fallback on earlier versions
            }
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-15);
                make.centerX.equalTo(self);
            }];
            label.text = @"今日完成";
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
        
    }
    return self;
}

#pragma mark -
#pragma mark --- 绘制 fish
- (void)animateWaveFish
{
    [self setNeedsDisplay];
}

#pragma mark -
#pragma mark --- 显示动画
- (void)showAnimationOfWaterWave
{
    
    [UIView animateWithDuration:1 animations:^{
        [self countAnimation];
        [self waterWaveAnimation];
    }];
    
}

- (void)countAnimation
{
    if (self.count == 0)
    {
        return;
    }
    _countLab.text = [NSString stringWithFormat:@"%ld",number];
    [UIView animateWithDuration:1 animations:^{
        number ++;
        _countLab.text = [NSString stringWithFormat:@"%ld",number];
        if (number > self.count)
        {
            number = 0;
            return ;
        }
    } completion:^(BOOL finished) {
        if (number == self.count)
        {
            number = 0;
            return ;
        }else
        {
            [self performSelector:@selector(countAnimation) withObject:nil afterDelay:0.05];
        }
    }];
}
- (void)waterWaveAnimation
{
    _myWaterView.waveHeight = myWaterWaveHeigh;
    [UIView animateWithDuration:2 animations:^{
        myWaterWaveHeigh ++;
        _myWaterView.waveHeight = myWaterWaveHeigh;
        //        NSLog(@"-----animation count %f %f %f",self.waveHeight,myWaterWaveHeigh,_myWaterView.waveHeight);
        if (myWaterWaveHeigh > self.waveHeight)
        {
            myWaterWaveHeigh = 0;
            return ;
        }
    } completion:^(BOOL finished) {
        if ((int)myWaterWaveHeigh ==(int) self.waveHeight)
        {
            //            NSLog(@"-----equle %f %f",myWaterWaveHeigh,self.waveHeight);
            myWaterWaveHeigh = 0;
            return;
        }else
        {
            [self performSelector:@selector(waterWaveAnimation) withObject:nil afterDelay:0.05];
        }
    }];
}
- (void)setWaveHeight:(float)waveHeight
{
    _myWaterView.waveHeight = waveHeight;
    _waveHeight = waveHeight;
}
-(void)setCount:(NSInteger)count
{
    _countLab.text = [NSString stringWithFormat:@"%ld",count];
    _myWaterView.count = count;
}

- (NSInteger)count
{
    return _myWaterView.count;
}

- (NSTimer *)timer
{
    return _myWaterView.timer;
}
@end
