//
//  FGMathDiffcultyViewController.m
//  FGProject
//
//  Created by 鑫龙魂 on 2018/8/26.
//  Copyright © 2018年 bert. All rights reserved.
//

#import "FGMathDiffcultyViewController.h"
#import "FGRewardsView.h"
#import "FGMediumLevelOperatorView.h"
#import "MCFireworksButton.h"
#import "FGMathRootViewController.h"
#import "FGClickRandomAnswerCountModel.h"
#import "FGMathAnswerOptionsModel.h"
#import "FGDiffcultyCandidateAnswerView.h"
@interface FGMathDiffcultyViewController ()<FGDiffcultyCandidateAnswerViewDelegate>
{
    FGClickRandomAnswerCountModel *clickRandomCounModel;
}
@property (nonatomic,strong) FGMediumLevelOperatorView *mediumLOV;
@property (nonatomic,strong) FGDiffcultyCandidateAnswerView *candidateAV;
@property (nonatomic,strong) FGMathOperationModel *currentOperaModel;
@property (nonatomic, assign) NSInteger currentNumber;
@property (nonatomic, assign) NSInteger currentHighestRecord;
@end

@implementation FGMathDiffcultyViewController


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mediumLOV.timer setFireDate:[NSDate distantFuture]];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mediumLOV.timer setFireDate:[NSDate distantPast]];
    self.currentHighestRecord =  [[FGMathOperationManager shareMathOperationManager] getCurrentChallengeHighestRecord];
    [self updateTitleStr];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initSubviews{
    [super initSubviews];

    self.currentNumber = 0;
    //隐藏
    [self hiddenCircleView];
    //运算式
    self.mediumLOV = [[FGMediumLevelOperatorView alloc]init];
    [self.view addSubview:self.mediumLOV];
    
    //候选答案
    self.candidateAV = [[FGDiffcultyCandidateAnswerView alloc]init];
    self.candidateAV.delegate = self;
    [self.view addSubview:self.candidateAV];
    [self updateView];
    
   __unused UIButton *paustBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(25);
            make.right.mas_equalTo(-25);
            make.size.mas_equalTo(CGSizeMake(90, 40));
        }];
       [btn addTarget:self action:@selector(paustAction:) forControlEvents:UIControlEventTouchUpInside];
       [btn setTitle:@"暂停" forState:UIControlStateNormal];
       btn.titleLabel.font = [UIFont systemFontOfSize:18.0];
       [btn setBackgroundColor:kColorBackground];
       [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
       btn.layer.cornerRadius = 5.0;
       btn.layer.masksToBounds = YES;
       btn;
   });

}

#pragma mark -
#pragma mark --- update view
- (void)updateView{
    self.currentOperaModel = [self.mathManager generateCompreMathOperationModelWithOperationType:MathOperationActionTypeCompreOfChallenge];
    [self.mediumLOV setMediumOperationModel:self.currentOperaModel];
    FGMathAnswerOptionsModel *answerOptionModel = [self.mathManager generateRandomAnswerNum:self.currentOperaModel.answerNum];
    [self.candidateAV setupAnswerModel:answerOptionModel];
}

- (void)paustAction:(UIButton*)sender{
    [self.candidateAV pauseWaterRipper];
    NSString *message = [NSString stringWithFormat:@"目前%@",[self getAlertViewMessage]];
    [JCAlertView showOneButtonWithTitle:@"暂停挑战" Message:message ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"继续挑战" Click:^{
        sender.selected = !sender.selected;
        [self.candidateAV continueWaterRipper];
    }];
}

#pragma mark -
#pragma mark --- MediumCandidateAnswerViewDelegate
- (void)didClickCandidateActionType:(MathOperationChooseResultType)actionType{
    
    [self.mathManager saveMathOperationDataStatisticsWithUserOperationState:actionType];
    
    if (actionType == MathOperationChooseResultTypeCorrect) {
        [[SoundsProcess shareInstance] playSoundOfWonderful];
        self.currentNumber ++;
        [self updateView];
        [self updateTitleStr];
    }else{
        [self showErrorView];
    }
}

- (void)challengeFailure{
    [self updateTitleStr];
    [self showErrorView];
}

- (void)showErrorView{
    [[SoundsProcess shareInstance] playSoundOfWrong];

    NSString *message = [NSString stringWithFormat:@"本次%@",[self getAlertViewMessage]];
 
    [JCAlertView showOneButtonWithTitle:@"挑战结束" Message:message ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"确定" Click:^{
        
        if (self.currentNumber > self.currentHighestRecord) {
            [self fireworksProcess];
            [[FGMathOperationManager shareMathOperationManager] updateCurrentChallengeHighestRecordWithNumber:self.currentNumber];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else{
          [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (NSString *)getAlertViewMessage{
    NSString *message = [NSString stringWithFormat:@"得分: %ld 最高记录得分: %ld",self.currentNumber,self.currentHighestRecord];
    return message;
}

- (void)updateTitleStr{
    
    NSString *levStr = @"";
    UIColor *color = UIColor.redColor;
    UIFont *font = [UIFont boldSystemFontOfSize:18.f];
    MathCompreOfChallengeLevel lev = [[FGMathOperationManager shareMathOperationManager] getCurrentChallengeLevel];
    if (lev == MathCompreOfChallengeLevelOne) {
        levStr = @"初级";
    }else if (lev == MathCompreOfChallengeLevelTwo){
        levStr = @"中级";
    }else{
        levStr = @"高级";
    }
    
    NSString *message = [NSString stringWithFormat:@"挑战模式等级:%@ 目前得分: %ld 最高记录得分: %ld",levStr,self.currentNumber,self.currentHighestRecord];

    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:message];
    NSRange levRange = [message rangeOfString:@"挑战模式等级:"];
    NSRange numberRange = [message rangeOfString:@" 目前得分: "];
    NSRange hightestRange = [message rangeOfString:@" 最高记录得分: "];
    
    NSRange levR = NSMakeRange(levRange.length, (numberRange.location-levRange.length));
    NSRange numberR = NSMakeRange(numberRange.location+numberRange.length, hightestRange.location-(numberRange.length+numberRange.location));
    NSRange hightestR = NSMakeRange(hightestRange.location+hightestRange.length, message.length-(hightestRange.location+hightestRange.length));

    [attr addAttribute:NSForegroundColorAttributeName value:color range:levR];
    [attr addAttribute:NSFontAttributeName value:font range:levR];
    
    [attr addAttribute:NSForegroundColorAttributeName value:color range:numberR];
    [attr addAttribute:NSFontAttributeName value:font range:numberR];

    [attr addAttribute:NSForegroundColorAttributeName value:color range:hightestR];
    [attr addAttribute:NSFontAttributeName value:font range:hightestR];

    self.attributedTitleStr = attr;
}


/**
 *  烟花效果
 */
- (void)fireworksProcess{
//    [FGRewardViewHUD show];
    //播放烟花声音
    [[SoundsProcess shareInstance] playSoundOfFireworks];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        NSMutableArray *arr = [NSMutableArray array];
        for (int i = 0; i < 10; i ++)
        {
            int x = arc4random()%((int)kScreenWidth - 10 + 1) + 1;
            int y = arc4random()%((int)kScreenHeight - 10 + 1) + 1;
            int w = arc4random()%((int)kScreenHeight/6 - 50 + 1) + 1;
            int h = w;
            
            MCFireworksButton *likeButton = [MCFireworksButton buttonWithType:UIButtonTypeCustom];
            likeButton.backgroundColor = [UIColor clearColor];
            int num = (arc4random()%(5-1+1)+1);
            likeButton.particleImage = [UIImage imageNamed:[NSString stringWithFormat:@"fireworks-0%d",num]];
            likeButton.particleScale = 0.5;
            likeButton.particleScaleRange = 0.02;
            likeButton.frame = CGRectMake(x, y, w, h);
            [arr addObject:likeButton];
        }
        UIView *shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        shadowView.tag = 10012;
        shadowView.backgroundColor = [UIColor blackColor];
        [self.view insertSubview:shadowView aboveSubview:self.view.superview];
        
        for (int i = 0; i < arr.count; i ++)
        {
            // 并行执行的线程一
            MCFireworksButton *likeButton = arr[i];
            [likeButton popOutsideWithDuration:1.5];
            [likeButton animate];
            [shadowView addSubview:likeButton];
        }
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 汇总结果
        [UIView animateWithDuration:2 delay:1.2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [self.view viewWithTag:10012].alpha = 0;
        } completion:^(BOOL finished) {
            [[self.view viewWithTag:10012] removeFromSuperview];
            
        }];
    });
}


- (void)setupLayoutSubviews{
    [super setupLayoutSubviews];
    [self.mediumLOV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight/4));
    }];
    
    [self.candidateAV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mediumLOV.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenHeight/4));
    }];
}

@end
