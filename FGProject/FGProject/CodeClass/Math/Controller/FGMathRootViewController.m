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
@interface FGMathRootViewController ()<DiffcultyLevelViewDelegate,MusicPlayerViewDelegate,FGMathRootViewDelegate>
{

    MusicPlayerView *playView;
    NSTimer *timer;
}

@property (nonatomic, strong) FGMathRootView *choiceView;
@property (nonatomic, strong) DiffcultyLevelView *diffView;
@property (nonatomic, strong) UIImageView *flowerImageView;
@end

@implementation FGMathRootViewController

#warning ---频繁的从本试图返回根视图内存会持续的增加
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    
//    playView = [[MusicPlayerView alloc]initWithFrame:CGRectMake(ScreenWidth/2 + RIGHT_MARGIN_PLAYERVIEW, ScreenHeight - HEIGHT_PLAYERVIEW - 10, WIDTH_PLAYERVIEW, HEIGHT_PLAYERVIEW)];
//    playView.delegate = self;
//    [playView.playerManager setUpMusic];
//    [self.view addSubview:playView];



}
- (void)initSubviews{
    [super initSubviews];
    
    self.choiceView = [[FGMathRootView alloc]initWithFrame:self.view.frame];
    self.choiceView.delegate = self;
    [self.bgView insertSubview:self.choiceView belowSubview:self.navigationView];
    
    self.flowerImageView =  ({
        UIImageView *image = [[UIImageView alloc]init];
        [self.bgView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10);
            make.right.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(100, 105));
            
        }];
        image;
    });
    self.flowerImageView.image = [UIImage imageNamed:@"flower_smile"];
    [self flowerAnimation:@"flower_walk" count:2];
    
}
- (void)flowerAnimation:(NSString *)imageName count:(int )count
{
    if ([self.flowerImageView isAnimating]){
        return;
    }
    NSMutableArray *imageArr = [NSMutableArray array];
    
    for (int i = 0; i < count; i ++){
        NSString *str = [NSString stringWithFormat:@"%@_0%d.png",imageName,i+1];
        NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:nil];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [imageArr addObject:image];
    }
    
    [self.flowerImageView setAnimationImages:imageArr];
    [self.flowerImageView setAnimationDuration:imageArr.count *0.5];
    [self.flowerImageView setAnimationRepeatCount:NSIntegerMax];
    [self.flowerImageView startAnimating];
    
//    [self.flowerImageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:self.flowerImageView.animationDuration];
}

- (void)setupLayoutSubviews{
    [super setupLayoutSubviews];
    [self.choiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
    }];
}
#pragma mark -
#pragma mark --- MusicPlayView delegate
- (void)musicPlayBtnAction:(UIButton *)btn
{

}

- (void)progressGerstureWithlocation:(CGFloat)locationX
{

}

#pragma mark -------FGMathRootViewDelegate-点击按钮进入题目页面----
//- (void)choiceBtnAction:(UIButton *)btn
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
