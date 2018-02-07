//
//  FGCalculateVerticalView.m
//  FGProject
//
//  Created by Bert on 16/8/10.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGCalculateVerticalView.h"
#import "QuestionModel.h"
#import "FSDAirportFlipLabel.h"
@implementation FGCalculateVerticalView

-(instancetype)init
{
    self = [super init];
    if (self)
    {
       
        UIButton * voiceToWordsBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [voiceToWordsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [voiceToWordsBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        voiceToWordsBtn.layer.cornerRadius = 5;
        voiceToWordsBtn.layer.masksToBounds = YES;
        [self addSubview:voiceToWordsBtn];
        [voiceToWordsBtn setTitle:@"语音转文字" forState:UIControlStateNormal];
        [voiceToWordsBtn setBackgroundColor:[UIColor redColor]];
        [voiceToWordsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(100, 30));
            make.left.mas_equalTo(10);
        }];
        [voiceToWordsBtn addTarget:self action:@selector(setupVoiceToWords:) forControlEvents:UIControlEventTouchUpInside];

        
        self.operatorLabel = [[FSDAirportFlipLabel alloc]init];
        [self.operatorLabel setupTextSize:50 fixedLenght:55 numberOfFlips:1];
        [self addSubview:self.operatorLabel];
        [self.operatorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(100, 30));
            make.left.mas_equalTo(10);
        }];
        self.operatorLabel.startedFlippingLabelsBlock = ^{
            NSLog(@"started flipping");
        };
        self.operatorLabel.finishedFlippingLabelsBlock = ^{
            NSLog(@"Stopped flipping");
        };
        self.operatorLabel.text = @"+";
        
        
        //第一个数
        self.firstNumLabel = [[FSDAirportFlipLabel alloc]init];
        [self.firstNumLabel setupTextSize:50 fixedLenght:55 numberOfFlips:2];
        [self addSubview:self.firstNumLabel];
        [self.firstNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(100, 30));
            make.left.mas_equalTo(self.operatorLabel.mas_right).offset(10);
        }];
        self.firstNumLabel.text = @"00";
        
        self.secondNumLabel = [[FSDAirportFlipLabel alloc]init];
        [self.secondNumLabel setupTextSize:50 fixedLenght:55 numberOfFlips:2];
        [self addSubview:self.secondNumLabel];
        [self.secondNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.firstNumLabel.mas_bottom).offset(30);
            make.size.mas_equalTo(CGSizeMake(100, 30));
            make.left.mas_equalTo(self.firstNumLabel.mas_left);
        }];
        self.secondNumLabel.text = @"00";
        
        
        
        
        
        UILabel *timeLab = [[UILabel alloc]init];
        [self addSubview:timeLab];
        [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
        timeLab.backgroundColor = [UIColor yellowColor];
        timeLab.textAlignment = NSTextAlignmentCenter;
        POPAnimatableProperty *prop = [POPAnimatableProperty propertyWithName:@"countdown" initializer:^(POPMutableAnimatableProperty *prop) {
            prop.writeBlock = ^(id obj, const CGFloat values[]) {
                timeLab.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)values[0]/60,(int)values[0]%60,(int)(values[0]*100)%100];
            };
            prop.threshold = 0.01f;
        }];
        POPBasicAnimation *anBasic = [POPBasicAnimation linearAnimation];   //秒表当然必须是线性的时间函数
        anBasic.property = prop;    //自定义属性
        anBasic.fromValue = @(0);   //从0开始
        anBasic.toValue = @(3*60);  //180秒
        anBasic.duration = 3*60;    //持续3分钟
        anBasic.beginTime = CACurrentMediaTime() + 1.0f;    //延迟1秒开始
        [timeLab pop_addAnimation:anBasic forKey:@"countdown"];
        
        
        
        
        
       
    }
    return self;
}
- (void)setupVoiceToWords:(UIButton*)sender
{
    [UIView beginAnimations:@"View Filp" context:nil];
    [UIView setAnimationDelay:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:sender cache:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:sender cache:NO];
    [UIView commitAnimations];
    //100以内加不进位
    //产生的随机数
    QuestionModel *questModel;
    NSInteger number = arc4random()%2;
    if (number == 0)
    {
        //加
//        questModel = [QuestionModel GenerateRandomNumWithOperationStr:ADD_OPERATOR_STR];
        questModel = [QuestionModel GenerateRandomNumWithOperationType:MathOperationActionTypeAdd];
    }else
    {
//        questModel = [QuestionModel GenerateRandomNumWithOperationStr:SUBSTRACT_OPERATOR_STR];

        questModel = [QuestionModel GenerateRandomNumWithOperationType:MathOperationActionTypeSubtract];
    }
    
//    self.operatorLabel.text = ([questModel.operatorStr isEqualToString:ADD_OPERATOR_STR])? @"+":@"-";
    
    self.operatorLabel.text = (questModel.mathOperationActionType == MathOperationActionTypeAdd)? @"+":@"-";
    self.firstNumLabel.text = [NSString stringWithFormat:@"%ld",questModel.firstNum];
     self.secondNumLabel.text = [NSString stringWithFormat:@"%ld",questModel.secondNum];
}
- (CAAnimation *)SetupRotationAnimation{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    rotationAnimation.duration = 1;
    rotationAnimation.autoreverses = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    rotationAnimation.toValue = [NSNumber numberWithFloat:4 * M_PI];
    rotationAnimation.fillMode = kCAFillModeBoth;
    return rotationAnimation;
}

@end
