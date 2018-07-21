//
//  StartView.m
//  FGProject
//
//  Created by XL on 15/7/5.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import "FGRewardsView.h"

@implementation FGRewardsView
- (instancetype)initWithFrame:(CGRect)frame startNum:(NSInteger)num todayDoneNum:(NSInteger )todayNum
{
    self  = [super initWithFrame:frame];
    if (self){
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/2-120, kScreenHeight/2-55)];
        bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:bgView];
    
        _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, bgView.frame.size.width, bgView.frame.size.height/3-5)];
        _numLabel.backgroundColor = [UIColor clearColor];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.textColor = [UIColor redColor];
        _numLabel.font = [UIFont boldSystemFontOfSize:13.f];
        [bgView addSubview:_numLabel];
        
        CGFloat startWidth = bgView.frame.size.width/5-5;
        CGFloat heigth = bgView.frame.size.height/3;
        
        NSString *startImgStr = @"start-02.png";
        NSString *moonImgStr  = @"yueliang.png";
        NSString *sunImgStr = @"taiyang-02";
        
        NSInteger startNum = num;
        NSInteger moonNum = 0;//月亮个数
        NSInteger sunNum = 0;//太阳个数
        
        NSString *titleStr = @"";
        if (todayNum > 0)
        {
            titleStr = [NSString stringWithFormat:@"完成%ld道", todayNum];
        }
        
        if (startNum >= 10)
        {
            moonNum = startNum / 10;
            startNum = startNum % 10;
        }
      
        if (moonNum >= 5)
        {
            sunNum = moonNum / 5;
            moonNum = moonNum % 5;
        }
         _numLabel.text = titleStr;

        for (int i = 0; i < startNum + moonNum  + sunNum; i ++)
        {
          UIButton  *_startImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _startImgBtn.backgroundColor = [UIColor clearColor];
            if (i < 5)
            {
                _startImgBtn.frame = CGRectMake(i*startWidth,heigth , startWidth, startWidth);
                
            }else if(i < 10)
            {
                _startImgBtn.frame = CGRectMake((i-5)*startWidth, 2*heigth, startWidth, startWidth);
            }
            
            if (i< sunNum)
            {
                [_startImgBtn setImage:[UIImage imageNamed:sunImgStr] forState:UIControlStateNormal];
 
            }else if( i < sunNum + moonNum)
            {
               [_startImgBtn setImage:[UIImage imageNamed:moonImgStr] forState:UIControlStateNormal];
            }else
            {
                [_startImgBtn setImage:[UIImage imageNamed:startImgStr] forState:UIControlStateNormal];
            }
           
            [bgView addSubview:_startImgBtn];
            
            CABasicAnimation *basicAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            basicAnim.duration = 2.0;
            basicAnim.autoreverses = YES;
            basicAnim.repeatCount = HUGE_VAL;
            basicAnim.removedOnCompletion = NO;
            basicAnim.toValue = [NSNumber numberWithFloat:M_PI_2/5];
            [_startImgBtn.layer addAnimation:basicAnim forKey:@"KCBasicAnimation_Rotation"];
            
            [self setBtnActionWithBtn:_startImgBtn];
        }
    }
    return self;
}

- (void)setMediumStarNumber:(NSInteger)starNumber
{
    if (![self.subviews containsObject:self.bgView])
    {
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.bgView];
    }else
    {
        for (id view in self.bgView.subviews)
        {
            [view removeFromSuperview];
        }
    }
    CGFloat startWidth = self.frame.size.width/10;
    CGFloat heigth = startWidth;

    NSString *startImgStr = @"start-02.png";
    NSString *moonImgStr  = @"yueliang.png";
    NSString *sunImgStr = @"taiyang-02";
    NSInteger startNum = starNumber;
    NSInteger moonNum = 0;//月亮个数
    NSInteger sunNum = 0;//太阳个数
    
    if (startNum >= 10)
    {
        moonNum = startNum / 10;
        startNum = startNum % 10;
    }
    
    if (moonNum >= 5)
    {
        sunNum = moonNum / 5;
        moonNum = moonNum % 5;
    }
    for (int i = 0; i < startNum + moonNum  + sunNum; i ++)
    {
       UIButton *_startImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startImgBtn.backgroundColor = [UIColor clearColor];
        _startImgBtn.frame = CGRectMake(i*startWidth,0 , startWidth, heigth);
        
        if (i< sunNum)
        {
            [_startImgBtn setImage:[UIImage imageNamed:sunImgStr] forState:UIControlStateNormal];
        }else if( i < sunNum + moonNum)
        {
            [_startImgBtn setImage:[UIImage imageNamed:moonImgStr] forState:UIControlStateNormal];
        }else
        {
            [_startImgBtn setImage:[UIImage imageNamed:startImgStr] forState:UIControlStateNormal];
        }
        [self.bgView addSubview:_startImgBtn];
        
        CABasicAnimation *basicAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        basicAnim.duration = 2.0;
        basicAnim.autoreverses = YES;
        basicAnim.repeatCount = HUGE_VAL;
        basicAnim.removedOnCompletion = NO;
        basicAnim.toValue = [NSNumber numberWithFloat:M_PI_2/5];
        [_startImgBtn.layer addAnimation:basicAnim forKey:@"KCBasicAnimation_Rotation"];
        
        [self setBtnActionWithBtn:_startImgBtn];
    }

}
- (void)setBtnActionWithBtn:(UIButton *)btn
{
    [btn addTarget:self action:@selector(starAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)starAction:(UIButton *)btn
{
    [[SoundsProcess shareInstance]playSoundOfTock];
}
@end
