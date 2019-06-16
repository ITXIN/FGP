//
//  FGMathSettingViewController.m
//  FGProject
//
//  Created by 鑫龙魂 on 2018/4/16.
//  Copyright © 2018年 bert. All rights reserved.
//

#import "FGMathSettingViewController.h"
#import "FGImageLeftTitleRightButtom.h"
@interface FGMathSettingViewController ()

@property (nonatomic, strong) UIView *compreChooseView;
@property (nonatomic, strong) NSMutableDictionary *operationsDic;
@property (nonatomic, strong) FGImageLeftTitleRightButtom *voiceBtn;
@property (nonatomic, strong) UIView *challengeView;
@property (nonatomic, assign) MathCompreOfChallengeLevel level;
@end

@implementation FGMathSettingViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[FGMathOperationManager shareMathOperationManager] saveMathCompreOfOperationType:[NSDictionary dictionaryWithDictionary:self.operationsDic]];
    [[FGMathOperationManager shareMathOperationManager] updateCurrentChallengeLevel:self.level];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)initSubviews{
    [super initSubviews];
    
    [self setupCompreOperationType];
    
    [self setupChallengeTimerLever];
    
    self.voiceBtn = ({
        FGImageLeftTitleRightButtom *btn = [FGImageLeftTitleRightButtom buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:btn];
        [btn setTitle:@"声音打开" forState:UIControlStateNormal];
        [btn setTitle:@"声音关闭" forState:UIControlStateSelected];
        btn.selected = ![SoundsProcess shareInstance].isPlaySound;
        [btn setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"non_voice"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTintColor:[UIColor whiteColor]];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [btn addTarget:self action:@selector(voiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    
//    self.compreChooseView.backgroundColor = UIColor.redColor;
//    self.challengeView.backgroundColor = UIColor.yellowColor;
//    self.voiceBtn.backgroundColor = UIColor.cyanColor;
}

#pragma mark -
- (void)setupCompreOperationType{
    
    self.operationsDic = [NSMutableDictionary dictionaryWithDictionary:[[FGMathOperationManager shareMathOperationManager] getMathCompreOfOperationTypeDic]];
    self.compreChooseView = ({
        UIView *view = [UIView new];
        [self.view addSubview:view];
        view;
    });
    
    UILabel *titleLab = ({
        UILabel *label = [[UILabel alloc]init];
        [self.compreChooseView addSubview:label];
        label.font = [UIFont boldSystemFontOfSize:15.0];
        label.text = @"综合题目类型设置(勾选要做的类型)";
        label;
    });
    
    NSArray *titleArr = @[@"加",@"减",@"乘",@"除"];
    UIButton *btnTop = nil;
    UIButton *btnBottom = nil;
    for (NSInteger i = 0; i < 4; i ++) {
        UIButton *tempBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.compreChooseView addSubview:btn];
            btn.tag = MathOperationActionTypeAdd + i;
            [btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        
        UIButton *tempImageBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            btn.backgroundColor = kColorBackground;
            btn.layer.cornerRadius = 5;
            btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
            [self.compreChooseView addSubview:btn];
            btn;
        });
        
        tempImageBtn.tag = tempBtn.tag;
        
        [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLab.mas_bottom).offset(5);
            make.left.mas_equalTo(10*(i+1) + i*(30));
        }];
        [tempImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(tempBtn.mas_bottom).offset(5);
            make.centerX.equalTo(tempBtn);
            make.bottom.equalTo(self.compreChooseView);
        }];
        
        if (i == 0) {
            btnTop = tempBtn;
            btnBottom = tempImageBtn;
        }
        if (tempBtn.tag == MathOperationActionTypeAdd) {
            tempBtn.selected = [self.operationsDic[kMathCompreOfOperationChooseAddTypeKey] isEqualToString:@"YES"]?YES:NO;
        }else if (tempBtn.tag == MathOperationActionTypeSubtract){
            tempBtn.selected = [self.operationsDic[kMathCompreOfOperationChooseSubtractTypeKey] isEqualToString:@"YES"]?YES:NO;
        }else if (tempBtn.tag == MathOperationActionTypeMultiply){
            tempBtn.selected = [self.operationsDic[kMathCompreOfOperationChooseMultiplyTypeKey] isEqualToString:@"YES"]?YES:NO;
        }else if (tempBtn.tag == MathOperationActionTypeDivide){
            tempBtn.selected = [self.operationsDic[kMathCompreOfOperationChooseDivideTypeKey] isEqualToString:@"YES"]?YES:NO;
        }
        
    }
    
    [self.compreChooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(kScreenWidth/2);
        make.bottom.mas_equalTo(btnBottom);
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
    }];
}

- (void)setupChallengeTimerLever{
    self.level = [[FGMathOperationManager shareMathOperationManager] getCurrentChallengeLevel];
    self.challengeView = ({
        UIView *view = [UIView new];
        [self.view addSubview:view];
        view;
    });
    
    UILabel *titleLab = ({
        UILabel *label = [UILabel new];
        [self.challengeView addSubview:label];
        label.font = [UIFont boldSystemFontOfSize:15.0];
        label.text = @"挑战模式等级设置";
        label;
    });
    
    MathCompreOfChallengeLevel timerLev ;
    NSString *titleStr = @"";
    UIButton *btnTop = nil;
    UIButton *btnBottom = nil;
    for (NSInteger i = 0; i < 3; i++) {
        
        UIButton *tempBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.challengeView addSubview:btn];
            [btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(challengeLeveAction:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        
        UIButton *tempLab = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.challengeView addSubview:btn];
            btn.backgroundColor = kColorBackground;
            btn.layer.cornerRadius = 5;
            btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
            btn;
        });
        
        if (i == 0) {
            timerLev = MathCompreOfChallengeLevelOne;
            titleStr = @"初级";
            
            btnTop = tempBtn;
            btnBottom = tempLab;
        }else if (i == 1){
            timerLev = MathCompreOfChallengeLevelTwo;
            titleStr = @"中级";
        }else{
            timerLev = MathCompreOfChallengeLevelThree;
            titleStr = @"高级";
        }
        
        tempBtn.tag = timerLev;
        if (tempBtn.tag == self.level) {
            tempBtn.selected = YES;
        }else{
            tempBtn.selected = NO;
        }

        [tempLab setTitle:titleStr forState:UIControlStateNormal];
        
        [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLab.mas_bottom).offset(5);
            make.left.mas_equalTo(10*(i+1) + i*(30));
        }];
        [tempLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(tempBtn.mas_bottom).offset(5);
            make.centerX.equalTo(tempBtn);
        }];
    }
    
    [self.challengeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.compreChooseView.mas_bottom).offset(15);
        make.left.mas_equalTo(self.compreChooseView);
        make.width.mas_equalTo(kScreenWidth/2);
        make.bottom.mas_equalTo(btnBottom);
    }];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
    }];
    
}

#pragma mark -----------
- (void)voiceBtnAction:(UIButton*)sender{
    sender.selected = !sender.selected;
    [SoundsProcess shareInstance].isPlaySound = !sender.selected;
}

- (void)challengeLeveAction:(UIButton*)sender{
    for (UIView *view  in self.challengeView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*)view;
            btn.selected = NO;
        }
    }
    sender.selected = YES;
    if (sender.selected) {
        self.level = sender.tag;
    }
    [[FGMathOperationManager shareMathOperationManager] updateCurrentChallengeLevel:self.level];
}

- (void)actionBtn:(UIButton*)sender{
    //至少选择一个
    NSInteger count = 0;
    for (NSString *values in self.operationsDic.allValues) {
        if ([values isEqualToString:@"YES"]) {
            count ++;
        }
    }
    
    if (count == 1 && sender.selected == YES) {
        [SVProgressHUD showInfoWithStatus:@"至少选择一种计算类型"];
        return;
    }
    
    sender.selected = !sender.selected;
    
    NSString *tagStr = @"";
    if (sender.tag == MathOperationActionTypeAdd) {
        tagStr = kMathCompreOfOperationChooseAddTypeKey;
    }else if (sender.tag == MathOperationActionTypeSubtract){
        tagStr = kMathCompreOfOperationChooseSubtractTypeKey;
    }else if (sender.tag == MathOperationActionTypeMultiply){
        tagStr = kMathCompreOfOperationChooseMultiplyTypeKey;
    }else if (sender.tag == MathOperationActionTypeDivide){
        tagStr = kMathCompreOfOperationChooseDivideTypeKey;
    }
    
    if (sender.selected) {
        [self.operationsDic setValue:@"YES" forKey:tagStr];
    }else{
        [self.operationsDic setValue:@"NO" forKey:tagStr];
    }
}

#pragma mark -----------
- (void)setupLayoutSubviews{
    [super setupLayoutSubviews];
    
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.compreChooseView).offset(-15);
        make.top.equalTo(self.challengeView.mas_bottom).offset(5);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(130);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
