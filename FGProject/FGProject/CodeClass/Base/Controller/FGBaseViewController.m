//
//  FGBaseViewController.m
//  FGProject
//
//  Created by avazuholding on 2017/11/9.
//  Copyright © 2017年 bert. All rights reserved.
//

#import "FGBaseViewController.h"

@interface FGBaseViewController ()<FGNavigationViewDelegate>

@end

@implementation FGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.userManager = [FGUserManager standard];
    
    [self initSubviews];
    [self setupLayoutSubviews];
}

- (void)initSubviews{
    self.bgView= ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = [UIColor yellowColor];
        [self.view addSubview:view];
        view;
    });
    self.blurView = [[FGBlurEffectView alloc]init];
    [self.bgView addSubview:self.blurView];
    self.navigationView = [[FGNavigationView alloc]initWithDelegate:self];
    self.navigationView.delegate = self;
    self.navigationView.navigationView.backgroundColor = [UIColor clearColor];
    [self.bgView addSubview:self.navigationView];

    
}
#pragma mark - FGNavigationviewDelegate
-(void)popToRootViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
//默认是有image,特殊情况去设置
- (void)setupBlurEffectImage:(UIImage*)image{
    self.blurView.bgImageView.image = image;
}

#pragma mark -
- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.navigationView.titleStr = [NSString stringWithFormat:@"%@",titleStr];
}
- (void)setupLayoutSubviews{

//    if (AVAILABLE_IOS_11) {
//        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//            if (kiPhoneX) {
//                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
//                make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
//                make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
//                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
//            }else{
//              make.edges.equalTo(self.view);
//            }
//
//        }];
//    }else{
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
//    }
    
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.mas_equalTo(self.view);
        make.height.mas_equalTo(64);
        make.top.mas_equalTo(0);
    }];
    [self.blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgView);
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
