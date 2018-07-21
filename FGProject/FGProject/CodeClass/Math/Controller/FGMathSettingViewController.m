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

@property (nonatomic,strong) UILabel *operationSettingTitleLab;
@property (nonatomic,strong) NSMutableDictionary *operationsDic;
//@property (nonatomic, strong) FGImageTopTitleBottomButton *voiceBtn;
@property (nonatomic, strong) FGImageLeftTitleRightButtom *voiceBtn;
@end

@implementation FGMathSettingViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[FGMathOperationManager shareMathOperationManager]saveMathCompreOfOperationType:[NSDictionary dictionaryWithDictionary:self.operationsDic]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)initSubviews{
    [super initSubviews];
    
    self.voiceBtn = ({
        FGImageLeftTitleRightButtom *btn = [FGImageLeftTitleRightButtom buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:btn];
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
    
    
    self.operationsDic = [NSMutableDictionary dictionaryWithDictionary:[[FGMathOperationManager shareMathOperationManager]getMathCompreOfOperationTypeDic]];
    self.operationSettingTitleLab = ({
        UILabel *label = [[UILabel alloc]init];
        [self.bgView addSubview:label];
        label.font = [UIFont boldSystemFontOfSize:18.0];
        label.text = @"综合题目类型设置(勾选要做的类型)";
        label;
    });
    
    
    UIImageView *preImageView;
    NSArray *titleArr = @[@"setting_add",@"setting_subtract",@"setting_multiply",@"setting_divide"];
    
    for (NSInteger i = 0; i < 4; i ++) {
        UIImageView *tempImageView =  ({
            UIImageView *imgView = [[UIImageView alloc]init];
            [self.bgView addSubview:imgView];
            imgView.image = [UIImage imageNamed:titleArr[i]];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView;
        });
        
        UIButton *tempBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.bgView addSubview:btn];
            //            [btn setTitle:titleLab[i] forState:UIControlStateNormal];
            btn.tag = MathOperationActionTypeAdd + i;
            [btn setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn;
        });
        
        [tempImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kScreenWidth/2+15);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            if (i == 0) {
                make.top.mas_equalTo(self.operationSettingTitleLab.mas_bottom).offset(20);
            }else{
                make.top.mas_equalTo(preImageView.mas_bottom).offset(20);
            }
        }];
        
        [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(tempImageView.mas_right).offset(100);
            make.centerY.equalTo(tempImageView);
        }];
        
        preImageView = tempImageView;
        NSString *tagStr = [NSString stringWithFormat:@"%ld",tempBtn.tag];
        if (self.operationsDic.allValues.count == 4) {
            if ([self.operationsDic[tagStr]isEqualToString:@"YES"]) {
                tempBtn.selected = YES;
            }else{
                tempBtn.selected = NO;
            }
        }else{
            tempBtn.selected = YES;
            self.operationsDic[tagStr] = @"YES";
        }
        
    }
    
}
#pragma mark -----------
- (void)voiceBtnAction:(UIButton*)sender{
    sender.selected = !sender.selected;
    [SoundsProcess shareInstance].isPlaySound = !sender.selected;
}
#pragma mark -------action----
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
    NSString *tagStr = [NSString stringWithFormat:@"%ld",sender.tag];
    if (sender.selected) {
        [self.operationsDic setValue:@"YES" forKey:tagStr];
    }else{
        [self.operationsDic setValue:@"NO" forKey:tagStr];
    }
    
}

#pragma mark -----------
- (void)setupLayoutSubviews{
    [super setupLayoutSubviews];
    [self.operationSettingTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.mas_equalTo(kScreenWidth/2);
    }];
    [self.voiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50);
        make.top.equalTo(self.operationSettingTitleLab
                         .mas_bottom).offset(5);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(130);
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
