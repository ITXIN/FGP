//
//  FGStoryPlayViewController.m
//  FGProject
//
//  Created by Bert on 16/8/8.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGStoryPlayViewController.h"
#import "FGNetworkingReachable.h"
#import "FGPlayStoryModel.h"
#import "XLSphereView.h"
#import "FGFadeStringView.h"
#import "FGStoryModel.h"
@interface FGStoryPlayViewController ()<MusicPlayerViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *musicImageView;
@property (nonatomic,strong) MusicPlayerView *playView;
@property (nonatomic,strong) FGFadeStringView *fadeStringView;
@end

@implementation FGStoryPlayViewController
static NSString *reuserID = @"reuserID";
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.playView.playerManager pause];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.playInfoArr = [NSMutableArray array];
    if (![FGNetworkingReachable sharedInstance].isReachable){
        NSArray *dataArr = [FGProjectHelper getDataWithKey:[NSString stringWithFormat:@"%@%@",STORY_MUSIC_LIST_KEY,self.playModel.home_id]];
        FGLOG(@"-----本地数据 ");
        [self setupStoryDataWithArr:dataArr];
        return;
    }
    
    [self dataOfStoryRequest];
    
}

#pragma mark -
- (void)initSubviews{
    [super initSubviews];
  
    self.titleStr = self.playModel.title;
    self.navigationView.titleLab.textColor = [UIColor whiteColor];
    self.navigationView.titleLab.font = [UIFont systemFontOfSize:15];
    self.playInfoArr = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.bgView addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuserID];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.fadeStringView = [[FGFadeStringView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.fadeStringView.foreColor = [UIColor whiteColor];
    self.fadeStringView.backColor = [UIColor whiteColor];
    self.fadeStringView.font = [UIFont systemFontOfSize:14];
    self.fadeStringView.alignment = NSTextAlignmentCenter;
    self.fadeStringView.textStr = @"正在加载。。。。";
    [self.fadeStringView fadeRightWithDuration:2];
    [self.fadeStringView iPhoneFadeWithDuration:1];
    
    self.musicImageView =  ({
        UIImageView *image = [[UIImageView alloc]init];
        [self.bgView addSubview:image];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.layer.masksToBounds = YES;
        image.layer.cornerRadius = 3.0;
        image;
    });
    [self.musicImageView addSubview:self.fadeStringView];
    
    self.playView = [[MusicPlayerView alloc]initWithFrame:CGRectMake(0, kScreenHeight*0.80- HEIGHT_PLAYERVIEW - 10, WIDTH_PLAYERVIEW, HEIGHT_PLAYERVIEW)];
    self.playView.delegate = self;
    [self.bgView addSubview:self.playView];
    
}


#pragma mark -
- (void)dataOfStoryRequest
{
    [[FGHttpsRequestManager shareInstance] getDataWithUrlStr:[NSString stringWithFormat:@"%@%@%@",FGStoryBaseURLString,FGStoryListURLString,self.playModel.home_id] succeedHandler:^(id responseObject, NSError *error) {
        NSDictionary *dataDic = (NSDictionary*)responseObject;
        NSArray *musicArr = dataDic[@"data"][@"music"];
        [self setupStoryDataWithArr:musicArr];
        [FGProjectHelper saveDataWithKey:[NSString stringWithFormat:@"%@%@",STORY_MUSIC_LIST_KEY,self.playModel.home_id] data:musicArr];
    } failedHandler:^(NSError *error) {
        FGLOG(@"-----failedHandler %@",error);
        NSArray *dataArr = [FGProjectHelper getDataWithKey:[NSString stringWithFormat:@"%@%@",STORY_MUSIC_LIST_KEY,self.playModel.home_id]];
        FGLOG(@"-----本地数据 ");
        [self.view makeToast:error.description];
        [self setupStoryDataWithArr:dataArr];
    }];
    
}

/**
 *  使用数据
 */
- (void)setupStoryDataWithArr:(NSArray*)dataArr
{
    if (dataArr.count > 0) {
        NSMutableArray *musicUrlArr = [NSMutableArray array];
        NSMutableArray *titleArr = [NSMutableArray array];
        for (NSDictionary *dic in dataArr){
            FGPlayStoryModel *modle = [[FGPlayStoryModel alloc]initWithDic:dic];
            [musicUrlArr addObject:modle.music_url];
            [titleArr addObject:modle.story_name];
            [self.playInfoArr addObject:modle];
        }
        
        [self.playView setupPlayerDataArr:musicUrlArr];
        [self updateMusicPlayviewWithIndex:0];
        
        [self.tableView reloadData];
    }
    
}

#pragma mark -
#pragma mark --- MusicPlayerViewDelegate
- (void)musicPlayBtnAction:(UIButton *)btn
{
    FGLOG(@"musicPlayBtnAction");
    [self updateMusicPlayviewWithIndex:self.playView.playerManager.currendIndex];
    
}
- (void)currentPlayMusicIndex:(NSInteger)index{
    [self updateMusicPlayviewWithIndex:index];
}

- (void)updateMusicPlayviewWithIndex:(NSInteger)index{
    FGPlayStoryModel *model = self.playInfoArr[index];
    self.fadeStringView.textStr = model.story_name;
    [self.musicImageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"home_story"] options:SDWebImageRetryFailed];
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.playInfoArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self updateMusicPlayviewWithIndex:indexPath.row];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.playView setPlayerWithMusicIndex:indexPath.row];
    });
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserID forIndexPath:indexPath];
    if (cell== nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserID];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    FGPlayStoryModel *model = self.playInfoArr[indexPath.row];
    cell.imageView.layer.cornerRadius = 3.0;
    cell.imageView.layer.masksToBounds = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:[UIImage imageNamed:@"home_story"] options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (image) {//解决cell imageview 变大
                CGSize size = CGSizeMake(60, 60);
                UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
                [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
                UIImage *tempImage = UIGraphicsGetImageFromCurrentImageContext();
                cell.imageView.image = tempImage;
                UIGraphicsEndImageContext();
            }
        }];
        cell.textLabel.text = model.story_name;
    });
    return  cell;
}

- (void)setupLayoutSubviews{
    [super setupLayoutSubviews];
    if (AVAILABLE_IOS_11) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.navigationView.mas_bottom);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
            make.width.mas_equalTo(kScreenWidth/2);
        }];
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kStatusBarHeight);
            make.top.mas_equalTo(self.navigationView.mas_bottom);
            make.width.mas_equalTo(kScreenWidth/2);
            make.bottom.mas_equalTo(0);
        }];
    }
    
    [self.musicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.playView.mas_top).offset(-10);
        make.top.equalTo(self.tableView);
        make.right.equalTo(self.playView);
        make.left.equalTo(self.playView);
    }];
    [self.fadeStringView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.right.equalTo(self.musicImageView);
        make.left.equalTo(self.musicImageView);
    }];
    [self.playView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-kStatusBarHeight);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(WIDTH_PLAYERVIEW, HEIGHT_PLAYERVIEW));
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
