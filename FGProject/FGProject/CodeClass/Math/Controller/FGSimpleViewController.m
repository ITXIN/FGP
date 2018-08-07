//
//  ViewController.m
//  FGProject
//
//  Created by XL on 15/6/30.
//  Copyright (c) 2015年 XL. All rights reserved.
//

/**
 *  分为上下册的
 *
 */
#import "FGSimpleViewController.h"
#import "FGSimpleOperationView.h"
#import "TooltipForAnswerView.h"
@interface FGSimpleViewController ()<FGSimpleOperationViewDelegate>
@property (nonatomic,strong) FGSimpleOperationView *answerView;
@end

@implementation FGSimpleViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self setupSimplewOperationViewNewQuestionModel];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initSubviews{
    [super initSubviews];
    
    self.answerView = [[FGSimpleOperationView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) operationType:self.mathOperationActionType];
    self.answerView.delegate = self;
    [self.bgView insertSubview:self.answerView belowSubview:self.navigationView];
}

#pragma mark -
#pragma mark --- FGSimpleViewdeletate
- (void)simpleViewOperationActionType:(MathSimpleOperationViewActionType)actionType{
    
    [self.mathManager saveMathOperationDataStatisticsWithUserOperationState:actionType];
    [self updatCircleviewData];
    switch (actionType) {
        case MathSimpleOperationViewActionTypeAnswer:
        {
            [[SoundsProcess shareInstance] playSoundOfTock];
            [[SoundsProcess shareInstance] playSoundOfWonderful];
            
            if ([self.mathManager getCurrentDateHasDone] %10 == 0){//每隔10道 显示一次统计个数动画
                [self showCircleAnimationOfWaterWave];
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
                            [self setupSimplewOperationViewNewQuestionModel];
                        }
                    };
                }
               
            }else{
                //产生新的视图
                [self setupSimplewOperationViewNewQuestionModel];
            }
            break;
        }
        case MathSimpleOperationViewActionTypeOperation:
        {
            [[SoundsProcess shareInstance]playSoundOfWrong];
            [self setupSimplewOperationViewNewQuestionModel];
            break;
        }
        default:
            break;
    }
}

- (void)setupSimplewOperationViewNewQuestionModel{
    FGMathOperationModel *questModel = [self.mathManager generateSimpleOperationModelWithOperationType:self.mathOperationActionType];
    [self.answerView operationSubjectByQuestionModel:questModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
