//
//  FGMathBaseViewController.m
//  FGProject
//
//  Created by avazuholding on 2017/11/14.
//  Copyright © 2017年 bert. All rights reserved.
//

#import "FGMathBaseViewController.h"
#import "CircleView.h"
#import "TooltipForAnswerView.h"
@interface FGMathBaseViewController ()

@end

@implementation FGMathBaseViewController

- (TooltipForAnswerView *)toolView{
    if (!_toolView) {
        _toolView = [[TooltipForAnswerView alloc]initWithFrame:self.view.bounds];
    }
    return _toolView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.circleView circleViewWillApper];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.circleView circleViewWillDisapper];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initSubviews{
    [super initSubviews];
    //调节声音和拖拽进度条有时有冲突
    //    AdjustVolume *adjustVolume = [AdjustVolume shareAdjustVolumeManager];
    //    [adjustVolume setCallDelegate:self];
    
    self.mathManager = [FGMathOperationManager shareMathOperationManager];
    self.circleView = [[CircleView alloc]initWithFrame:CGRectMake(ScreenWidth- ScreenWidth/7 - 20, 20 , ScreenWidth/7, ScreenWidth/7)];
    [self.bgView addSubview:self.circleView];
    
}

- (void)updatCircleviewData{
    [self.circleView updatCircleviewData];
}
- (void)showCircleAnimationOfWaterWave{
    [self.circleView.waterWaveView showAnimationOfWaterWave];
}

@end
