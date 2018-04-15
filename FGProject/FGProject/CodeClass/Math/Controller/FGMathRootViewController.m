//
//  ChoiceViewController.m
//  FGProject
//
//  Created by XL on 15/7/4.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import "FGMathRootViewController.h"
#define TAG 1000

#import "FGSimpleViewController.h"
#import "FGMathRootView.h"
#import "DiffcultyLevelView.h"
#import "FGMediumViewController.h"
#import "MusicPlayerManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FGMathOperationDataStatisticsViewController.h"
@interface FGMathRootViewController ()<DiffcultyLevelViewDelegate,MusicPlayerViewDelegate,FGMathRootViewDelegate>
@property (nonatomic, strong) FGMathRootView *choiceView;
@property (nonatomic, strong) DiffcultyLevelView *diffView;
@property (nonatomic, strong) UILabel *playSoundLab;
@property (nonatomic, strong) UISwitch *switchView;
@end

@implementation FGMathRootViewController

#warning ---频繁的从本试图返回根视图内存会持续的增加
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[FGMathOperationManager shareMathOperationManager] getDataStatistic];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}
- (void)initSubviews{
    [super initSubviews];
    
    self.choiceView = [[FGMathRootView alloc]initWithFrame:self.view.frame];
    self.choiceView.delegate = self;
    [self.bgView insertSubview:self.choiceView belowSubview:self.navigationView];
    
    self.playSoundLab = ({
        UILabel *label = [[UILabel alloc]init];
        [self.bgView addSubview:label];
        label.textColor = [UIColor whiteColor];
        if (@available(iOS 8.2, *)) {
            label.font = [UIFont systemFontOfSize:15 weight:10];
        } else {
            // Fallback on earlier versions
        }
        label.text = @"声音开关";
        label;
    });
    self.switchView = [[UISwitch alloc]initWithFrame:CGRectMake(100, 150, 100, 30)];
    self.switchView.on = [SoundsProcess shareInstance].isPlaySound;
    [self.switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    self.switchView.tintColor = [UIColor whiteColor];
    [self.bgView addSubview:self.switchView];
    
}
#pragma mark -----------
- (void)switchAction:(UISwitch*)sender{
    [SoundsProcess shareInstance].isPlaySound = sender.isOn;
}
#pragma mark -------FGMathRootViewDelegate-点击按钮进入题目页面----
- (void)choiceBtnAction:(MathRootViewActionType)mathRootViewActionType
{
    switch (mathRootViewActionType) {
        case MathRootViewActionTypeAdd:
        case MathRootViewActionTypeSubtract:
        case MathRootViewActionTypeMultiply:
        case MathRootViewActionTypeDivide:
        {
            FGSimpleViewController *operationVC = [[FGSimpleViewController alloc]init];
            MathOperationActionType operationTyp = MathOperationActionTypeAdd;
            switch (mathRootViewActionType) {
                case MathRootViewActionTypeAdd:
                {
                    operationTyp = MathOperationActionTypeAdd;
                    break;
                }
                case MathRootViewActionTypeSubtract:
                {
                    operationTyp = MathOperationActionTypeSubtract;
                    break;
                }
                case MathRootViewActionTypeMultiply:
                {
                    operationTyp = MathOperationActionTypeMultiply;
                    break;
                }
                case MathRootViewActionTypeDivide:
                {
                    operationTyp = MathOperationActionTypeDivide;
                    
                    break;
                }
                default:
                    break;
            }
            
            operationVC.mathOperationActionType = operationTyp;
            CATransition *animation=[CATransition animation];
            animation.type = @"pageCurl";
            animation.duration=2.0;
            [self.view.superview.layer addAnimation:animation forKey:@"donghua"];
            [self.navigationController pushViewController:operationVC animated:YES];
            break;
        }
        case MathRootViewActionTypeCompre:
        {
            [AnimationProcess springAnimationProcessWithView:self.choiceView.compreBtn upHeight:30.f];
            if (![self.view.subviews containsObject:self.diffView])
            {
                CGPoint compreBtnCenter = self.choiceView.compreBtn.center;
                CGFloat pace = 10.0;
                CGFloat height = HEIGHT_BTN_CHOICEVIEW/2;
                CGFloat colMargin = 20.0;
                CGFloat width = height*3 + 2*colMargin;
                
                self.diffView = [[DiffcultyLevelView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
                self.diffView.delegate = self;
                CGPoint newCenter;
                newCenter.x = compreBtnCenter.x;
                newCenter.y = compreBtnCenter.y + (HEIGHT_BTN_CHOICEVIEW + height + pace)/2;
                self.diffView.center = newCenter;
                self.diffView.centerPoint = compreBtnCenter;
                [self.view insertSubview:self.diffView aboveSubview:self.view.superview];
            }else{
                [self.diffView removeFromSuperview];
            }
            break;
        }
        default:
            break;
    }
    
    
    
}

#pragma mark -
#pragma mark --- difficultyView delegate
- (void)diffcultyBtnAction:(MathOperationActionType)operationActionType{
    switch (operationActionType) {
        case MathOperationActionTypeCompreOfSimple:
        {
            FGSimpleViewController *view = [[FGSimpleViewController alloc]init];
            view.mathOperationActionType = operationActionType;
            CATransition *animation=[CATransition animation];
            animation.type = @"pageCurl";
            animation.duration=2.0;
            [self.view.superview.layer addAnimation:animation forKey:@"donghua"];
            [self.navigationController pushViewController:view animated:YES];
            break;
        }
        case MathOperationActionTypeCompreOfMedium:
        {
            FGMediumViewController *mediumVC = [[FGMediumViewController alloc]init];
            [self.navigationController pushViewController:mediumVC animated:YES];
            break;
        }
        case MathOperationActionTypeCompreOfDiffculty:
        {
            [self.view makeToast:@"还在施工中。。。。"];
            break;
        }
            
        default:
            break;
    }
    
}
- (void)setupLayoutSubviews{
    [super setupLayoutSubviews];
    [self.choiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.choiceView.sunBtn.mas_right).offset(10);
        make.centerY.mas_equalTo(self.choiceView.sunBtn);
    }];
    [self.playSoundLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.switchView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.switchView);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
