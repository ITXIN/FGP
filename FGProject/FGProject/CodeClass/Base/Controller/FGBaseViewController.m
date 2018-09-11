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
        [self.view addSubview:view];
        view;
    });
    self.blurView = [[FGBlurEffectView alloc] init];
    [self.bgView addSubview:self.blurView];
    self.navigationView = [[FGNavigationView alloc] initWithDelegate:self];
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
    if (titleStr && titleStr.length > 0) {
        _titleStr = titleStr;
        self.navigationView.titleLab.text = [NSString stringWithFormat:@"%@",titleStr];
    }
}

- (void)setAttributedTitleStr:(NSAttributedString *)attributedTitleStr{
    if (attributedTitleStr) {
        _attributedTitleStr = attributedTitleStr;
        self.navigationView.titleLab.attributedText = attributedTitleStr;
    }
}

- (void)setupLayoutSubviews{
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
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

@end
