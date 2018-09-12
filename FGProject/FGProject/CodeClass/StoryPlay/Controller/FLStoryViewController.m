//
//  FLStoryViewController.m
//  FGProject
//
//  Created by Bert on 2016/12/23.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FLStoryViewController.h"
#import "XLSphereView.h"
#import "FGStoryModel.h"
#import "FGStoryPlayViewController.h"
#import "FGDateView.h"
@interface FLStoryViewController ()<XLSphereViewDelegate>
@property (nonatomic,strong) XLSphereView *sphereView;
@property (nonatomic,strong) NSMutableArray *storyDataArr;
@property (nonatomic,strong) FGDateView *dateView;
@end

@implementation FLStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightTextColor];
    
    self.storyDataArr = [NSMutableArray array];
    if (![FGNetworkingReachable sharedInstance].isReachable){
        NSArray *dataArr = [FGProjectHelper getDataWithKey:STORY_HOMEPAGE_KEY];
        FGLOG(@"-----本地数据 ");
        [self setupStoryDataWithArr:dataArr];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self dataOfStoryRequest];
    });
   
}

- (void)initSubviews{
    [super initSubviews];
    //    self.dateView = [[FGDateView alloc]init];
    //    [self.view addSubview:self.dateView];
    //    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.mas_equalTo(-10);
    //        make.right.mas_equalTo(-10);
    //        make.size.mas_equalTo(CGSizeMake(300, 85));
    //    }];
    _sphereView = [[XLSphereView alloc] init];
    _sphereView.sphereDelegate = self;
    [self.bgView addSubview:_sphereView];
    
    [_sphereView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenHeight*0.75, kScreenHeight*0.75));
    }];
}

- (void)dataOfStoryRequest{
    [[FGHttpsRequestManager shareInstance] getDataWithUrlStr:[NSString stringWithFormat:@"%@%@",FGStoryBaseURLString,FGStoryHomePageURLString] succeedHandler:^(id responseObject, NSError *error) {
        NSDictionary *dataDic = (NSDictionary*)responseObject;
        NSArray *musicArr = dataDic[@"data"][@"music"];
        FGLOG(@"-----网络数据 ");
        [self setupStoryDataWithArr:musicArr];
        [FGProjectHelper saveDataWithKey:STORY_HOMEPAGE_KEY data:musicArr];
        [SVProgressHUD dismiss];
    } failedHandler:^(NSError *error) {
        FGLOG(@"-----failedHandler %@",error);
        NSArray *dataArr = [FGProjectHelper getDataWithKey:STORY_HOMEPAGE_KEY];
        FGLOG(@"-----本地数据 ");
        [self setupStoryDataWithArr:dataArr];
        [SVProgressHUD dismiss];
    }];
    
}

/**
 *  使用数据
 */
- (void)setupStoryDataWithArr:(NSArray*)dataArr{
    for (NSDictionary *dic in dataArr){
        FGStoryModel *modle = [[FGStoryModel alloc]initWithDic:dic];
        [self.storyDataArr addObject:modle];
    }
    [self.sphereView setupViewWithDataArr:self.storyDataArr];
}

#pragma mark -
#pragma mark --- XLSphereViewDelegate 3D旋转 按钮点击
- (void)storyBtnClick:(UIButton*)sender{
    FGLOG(@"-----sneder %@",sender);
    FGStoryPlayViewController *storyPlayVC = [[FGStoryPlayViewController alloc]init];
    for (FGStoryModel *model in self.storyDataArr){
        if ([model.title isEqualToString:sender.currentTitle]){
            storyPlayVC.playModel = model;
            [self.navigationController pushViewController:storyPlayVC animated:YES];
            return;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
