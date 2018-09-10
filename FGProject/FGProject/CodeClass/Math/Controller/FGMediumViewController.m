//
//  MediumViewController.m
//  FGProject
//
//  Created by Bert on 16/1/18.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGMediumViewController.h"
#import "FGRewardsView.h"
#import "FGMediumLevelOperatorView.h"
#import "FGMediumCandidateAnswerView.h"
#import "MCFireworksButton.h"
#import "FGMathRootViewController.h"
#import "FGClickRandomAnswerCountModel.h"
#import "FGMathAnswerOptionsModel.h"
@interface FGMediumViewController ()<FGMediumCandidateAnswerViewDelegate>
{
    FGClickRandomAnswerCountModel *clickRandomCounModel;
}
@property (nonatomic,strong) FGMediumLevelOperatorView *mediumLOV;
@property (nonatomic,strong) FGMediumCandidateAnswerView *candidateAV;
@property (nonatomic,strong) FGMathOperationModel *currentOperaModel;
@end

@implementation FGMediumViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mediumLOV.timer setFireDate:[NSDate distantFuture]];
    [self.candidateAV.timer setFireDate:[NSDate distantFuture]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mediumLOV.timer setFireDate:[NSDate distantPast]];
    [self.candidateAV.timer setFireDate:[NSDate distantPast]];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initSubviews{
    [super initSubviews];
   
    //运算式
    self.mediumLOV  = [[FGMediumLevelOperatorView alloc]init];
    [self.view addSubview:self.mediumLOV];
    
    //候选答案
    self.candidateAV = [[FGMediumCandidateAnswerView alloc]init];
    self.candidateAV.delegate = self;
    [self.view addSubview:self.candidateAV];
    [self updateView];
    
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

#pragma mark -
#pragma mark --- update view
- (void)updateView{
    self.currentOperaModel = [self.mathManager generateCompreMathOperationModelWithOperationType:MathOperationActionTypeCompreOfMedium];
    [self.mediumLOV setMediumOperationModel:self.currentOperaModel];
    FGMathAnswerOptionsModel *answerOptionModel = [self.mathManager generateRandomAnswerNum:self.currentOperaModel.answerNum];
    [self.candidateAV setupAnswerModel:answerOptionModel];
}

#pragma mark -
#pragma mark --- MediumCandidateAnswerViewDelegate
- (void)didClickCandidateActionType:(MathOperationChooseResultType)actionType{
    
    [self.mathManager saveMathOperationDataStatisticsWithUserOperationState:actionType];
    [self updatCircleviewData];
    
    if (actionType == MathOperationChooseResultTypeCorrect) {
        [[SoundsProcess shareInstance] playSoundOfWonderful];
        dispatch_after(7.0, dispatch_get_main_queue(), ^{
            NSInteger _doneCount = [self.mathManager getCurrentDateHasDone];
            //每间隔6道题弹出一次
            if (_doneCount %6 == 0){
                [HasDoneOperation setStarNumberWithDiffcultyLevelMark:MEDIUM_STAR_NUMBER_MARK];
                
                if (![self.view.subviews containsObject:self.toolView]){
                    [self.view addSubview:self.toolView];
                    @weakify(self);
                    self.toolView.actionIndexBlock = ^(NSInteger index) {
                        @strongify(self);
                        [self.toolView removeFromSuperview];
                        if (index == REST_BTN_TAG_TOOLTIP){
                            [self.navigationController popViewControllerAnimated:YES];
                        }else{
                            CATransition *animation=[CATransition animation];
                            animation.type=@"rippleEffect";
                            animation.duration=2.0;
                            [self.view.superview.layer addAnimation:animation forKey:@"donghua"];
                            [self updateView];
                            [self showCircleAnimationOfWaterWave];
                        }
                    };
                }
                [self fireworksProcess];
            }else{
                [self updateView];
            }
        });
    }else{
        [[SoundsProcess shareInstance] playSoundOfWrong];
        [self updateView];
    }
}

/**
 *  烟花效果
 */
- (void)fireworksProcess{
    [FGRewardViewHUD show];
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
            [likeButton popOutsideWithDuration:5.5];
            [likeButton animate];
            [shadowView addSubview:likeButton];
        }
    });
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 汇总结果
        [UIView animateWithDuration:3 delay:1.2 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [self.view viewWithTag:10012].alpha = 0;
        } completion:^(BOOL finished) {
            [[self.view viewWithTag:10012] removeFromSuperview];
            
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
