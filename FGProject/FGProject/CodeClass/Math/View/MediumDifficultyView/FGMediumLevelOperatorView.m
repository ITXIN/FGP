//
//  MediumLevelOperatorView.m
//  FGProject
//
//  Created by Bert on 16/1/18.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGMediumLevelOperatorView.h"
#import "MediumOperationModel.h"
#import "BubbleButton.h"
@implementation FGMediumLevelOperatorView

-(void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
//        CGFloat topMargin = (frame.size.height -OPERATOR_HEIGHT)/2;
//        CGFloat leftMargin = (frame.size.width - 7*OPERATOR_HEIGHT)/2;
//        CGFloat width = self.frame.size.width - 2*leftMargin;
//        CGFloat height = self.frame.size.height - 2*topMargin;
        self.bgView = ({
            UIView *view = [[UIView alloc]init];
            [self addSubview:view];
            
            view;
        });
        
        [self setupTimer];
    }
    return self;
}

#pragma mark --------model 的 setter 方法----
//-(void)setMediumOperationModel:(MediumOperationModel *)questionModel
-(void)setMediumOperationModel:(FGMathOperationModel *)questionModel
{
    for (UIButton *btn in self.bgView.subviews){
        [btn removeFromSuperview];
    }
    FGMathOperationManager *mathManager = [FGMathOperationManager shareMathOperationManager];
    CGFloat btnWidth = OPERATOR_HEIGHT;
    //间距
    CGFloat padding = (ScreenWidth-7*btnWidth)/2;
    NSInteger firstNum = questionModel.firstNum;
    //第二个数
    NSInteger secondNum = questionModel.secondNum;
    MathOperationActionType operationType = questionModel.firstOperationType;
    NSString *picStr = nil;
    NSArray *imageArr = @[[UIImage imageNamed:@"fireworks-01"],[UIImage imageNamed:@"fireworks-02"],[UIImage imageNamed:@"fireworks-03"],[UIImage imageNamed:@"fireworks-04"],[UIImage imageNamed:@"start-02"],[UIImage imageNamed:@"Sparkle"]];
    UIImage *operationImage = nil;
    for (int i = 0; i < 7; i ++){
        BubbleButton *numAndOperBtn = [[BubbleButton alloc]initWithFrame:CGRectMake(padding + i*btnWidth ,0, btnWidth, btnWidth) leftWidth:ScreenWidth/2 rightWidth:ScreenWidth/2 bottomHeight:ScreenHeight/4];
        numAndOperBtn.imagesArr = imageArr;
        numAndOperBtn.duration = 2.0;
        numAndOperBtn.tag = 100 + i;
        if (i == 0){
            operationImage = [mathManager getOperationNumberImageWithNumber:firstNum] ;
        }else if (i == 1){
            operationImage = [mathManager getOperationImageWithOperationType:operationType];
        }else if (i == 2){
            operationImage = [mathManager getOperationNumberImageWithNumber:secondNum];
        }else if (i == 3){
            operationImage = [mathManager getOperationImageWithOperationType:questionModel.secondOperationType];
        }else if (i == 4){
            
            operationImage = [mathManager getOperationNumberImageWithNumber:questionModel.thirdNum];
        }else if(i == 5){
            picStr =  [NSString stringWithFormat:@"dengyu.png"];
            operationImage = [UIImage imageNamed:picStr];
        }else{
            picStr = [NSString stringWithFormat:@"wenhao.png"];
            operationImage = [UIImage imageNamed:picStr];
        }
        numAndOperBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [numAndOperBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [numAndOperBtn setBackgroundImage:operationImage forState:UIControlStateNormal];
        
        [_bgView addSubview:numAndOperBtn];
        [AnimationProcess springAnimationProcessWithView:numAndOperBtn upHeight:arc4random()%(100-30+1)+30];
    }//end for
    
}
#pragma mark -
#pragma mark ---init Timer
- (void)setupTimer
{
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(autoAction) userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}
#pragma mark -
#pragma mark --- timeAction
- (void)autoAction
{
    //    NSLog(@"-----autoaction ");
    [[self.bgView viewWithTag:(arc4random() %(106 - 100 + 1)+ 100)] generateBubbleInRandom];
    [AnimationProcess springAnimationProcessWithView:[self.bgView viewWithTag:(arc4random() %(106 - 100 + 1)+ 100)] upHeight:arc4random()%(40-20+1)+20];
    [AnimationProcess scaleAnmiationProcessWithView:[self.bgView viewWithTag:(arc4random() %(106 - 100 + 1)+ 100)]];
}

#pragma mark -
#pragma mark --- btnClick
- (void)btnClick:(BubbleButton *)btn
{
#warning 点击过快会导致动画不能继续执行
    [[SoundsProcess shareInstance]playSoundOfTock];
    [btn generateBubbleInRandom];
    [AnimationProcess springAnimationProcessWithView:btn upHeight:arc4random()%(40-20+1)+20];
    [AnimationProcess scaleAnmiationProcessWithView:btn];
    
    //    int rand = arc4random() %(360 -(-360)+1)+(-360);
    //    CABasicAnimation *animation  = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //    animation.toValue = [NSNumber numberWithFloat:(M_PI/180 *rand)];
    //    animation.duration = 0.8;
    //    [btn.layer removeAllAnimations];
    //    [btn.layer addAnimation:animation forKey:nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


@end
