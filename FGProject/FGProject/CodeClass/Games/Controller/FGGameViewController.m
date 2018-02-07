//
//  FGGameViewController.m
//  FGProject
//
//  Created by Bert on 2017/2/7.
//  Copyright © 2017年 XL. All rights reserved.
//

#import "FGGameViewController.h"
#import "FGGameModel.h"
#import "FGGameCollectionViewCell.h"
#import "FGWebViewGameViewController.h"
#import "FGTomViewController.h"
@interface FGGameViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,FGNavigationViewDelegate>
{
    UICollectionViewFlowLayout *flowLayout;
}
@property (nonatomic,strong) UICollectionView *myCollectionView;
@property (nonatomic,strong) NSMutableArray *englisthModelArr;
@property (nonatomic,strong) NSMutableArray *onLineModelArr;

@end
static NSString *identify = @"identify";
static NSString *headerIdentifier = @"ReuseHeader";
@implementation FGGameViewController
- (UICollectionView *)myCollectionView
{
    if (!_myCollectionView)
    {
        flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        if (ScreenWidth == Screen58InchWidth) {
            flowLayout.itemSize = CGSizeMake(130, 130);
//            flowLayout.itemSize = CGSizeMake((ScreenWidth-10-88-83)/3, (ScreenWidth-10-88-83)/3);
        }else{
            flowLayout.itemSize = CGSizeMake((ScreenWidth-10)/3, (ScreenWidth-10)/3);
        }
        _myCollectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.backgroundColor =  RGB(50, 215, 228);
        _myCollectionView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    }
    return _myCollectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.englisthModelArr = [NSMutableArray array];
    self.onLineModelArr = [NSMutableArray array];
    [self.myCollectionView registerClass:[FGGameCollectionViewCell class] forCellWithReuseIdentifier:identify];
    [self.myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    
    [self.view addSubview:self.myCollectionView];
    [self.myCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (AVAILABLE_IOS_11) {
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }else{
            make.edges.equalTo(self.view);
        }
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    [self dataOfGameRequest];
    [self loactionData];
    
    FGNavigationView *navigationView = [[FGNavigationView alloc]initWithDelegate:self];
    navigationView.titleLab.text = @"益智小游戏";
    [self.view addSubview:navigationView];
    
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
   
}

- (void)dataOfGameRequest
{
    //sign 会过期改变
    [[FGHttpsRequestManager shareInstance] getDataWithUrlStr:[NSString stringWithFormat:@"%@",GAME_CHILDERN_API] succeedHandler:^(id responseObject, NSError *error) {
        NSDictionary *dataDic = (NSDictionary*)responseObject;
        NSArray *musicArr = dataDic[@"data"];
        NSLog(@"----dataOfGameRequest-网络数据 %@",musicArr);
        NSDictionary *gameDic = (NSDictionary*)musicArr[1];
        NSArray *gamelistArr = gameDic[@"gamelist"];
        
        for (NSDictionary *dic in gamelistArr) {
            FGGameModel *model = [[FGGameModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            if ([model.game_link containsString:@".bin"]) {
                NSLog(@"-----link %@",model.game_link);
                continue;
            }
//            [self.listModelArr addObject:model];
        }
        
        [self.myCollectionView reloadData];
//        [self setupStoryDataWithArr:musicArr];
//        [FGProjectHelper saveDataWithKey:[NSString stringWithFormat:@"%@%@",STORY_MUSIC_LIST_KEY,self.homeID] data:musicArr];
        [SVProgressHUD dismiss];
    } failedHandler:^(NSError *error) {
        NSLog(@"----dataOfGameRequest-failedHandler %@",error);
//        NSArray *dataArr = [FGProjectHelper getDataWithKey:[NSString stringWithFormat:@"%@%@",STORY_MUSIC_LIST_KEY,self.homeID]];
        NSLog(@"----dataOfGameRequest-本地数据 ");
//        [self setupStoryDataWithArr:dataArr];
        [self loactionData];

        
        [SVProgressHUD dismiss];
    }];
    
}

- (void)loactionData
{
    NSArray *enlisthDataArr = @[
                      @{
                          @"game_name": @"认识五官",
                          @"game_coverurl": @"http://7xr1xh.com1.z0.glb.clouddn.com/EYES.png",
                          @"game_link": @"http://gamecdn.bbwansha.com/w1d1_face/index.html",
                          },
                      @{
                          @"game_name": @"学习家庭成员称谓",
                          @"game_coverurl": @"http://7xr1xh.com1.z0.glb.clouddn.com/%E5%AE%B6%E5%BA%AD%E6%88%90%E5%91%98%E5%8F%91%E9%9F%B3.png",
                          @"game_link": @"http://gamecdn.bbwansha.com/game_a34m1w1d1/index.html",
                          },
                      @{
                          @"game_name": @"学习身体部位",
                          @"game_coverurl": @"http://7xr1xh.com1.z0.glb.clouddn.com/body-parts.png",
                          @"game_link": @"http://gamecdn.bbwansha.com/game_week2_day1/index.html",
                          
                          },
                      ];
    
    NSArray *onLineDataArr = @[
                           @{
                               @"game_name": @"狂奔的赛车",
                               @"game_coverurl": @"http://imga999.5054399.com/upload_pic/2016/11/24/4399_15371041427.jpg",
                               @"game_link": @"http://h.4399.com/play/182580.htm",
                               },
                           
                           ];
    
    
    
    
    [self.englisthModelArr removeAllObjects];
    [self.onLineModelArr removeAllObjects];

    for (NSDictionary *dic in enlisthDataArr) {
        FGGameModel *model = [[FGGameModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        if ([model.game_link containsString:@".bin"]) {
            NSLog(@"-----link %@",model.game_link);
            continue;
        }
        [self.englisthModelArr addObject:model];
    }
    for (NSDictionary *dic in onLineDataArr) {
        FGGameModel *model = [[FGGameModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        if ([model.game_link containsString:@".bin"]) {
            NSLog(@"-----link %@",model.game_link);
            continue;
        }
        [self.onLineModelArr addObject:model];
    }
    
    [self.myCollectionView reloadData];
}
#pragma mark -
#pragma mark --- UICollectionViwDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    if (section == 0) {
        return self.englisthModelArr.count;
    }else if(section == 1)
    {
        return self.onLineModelArr.count;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}
// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(ScreenWidth, 30);

}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FGGameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (indexPath.section == 0 ) {
        if (self.englisthModelArr.count > 0)
        {
            [cell setGameModel:self.englisthModelArr[indexPath.row]];
        }
        return cell;
    }else if (indexPath.section == 1){
        if (self.onLineModelArr.count > 0)
        {
            [cell setGameModel:self.onLineModelArr[indexPath.row]];
        }
        return cell;
    }else{
        cell.gameImage.image = [UIImage imageNamed:@"angry_11.jpg"];
        cell.gameNameLab.text = @"Tom 猫";
        return cell;
    }
  
}
//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                            withReuseIdentifier:headerIdentifier
                                                                forIndexPath:indexPath];
    
    headView.backgroundColor = RGB(34, 164, 191);

    if (headView.subviews.count == 0) {
        UILabel *titleLab = ({
            UILabel *label = [[UILabel alloc]init];
            [headView addSubview:label];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont boldSystemFontOfSize:21];
            label.textAlignment = NSTextAlignmentCenter;
            
            label;
        });
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(headView);
        }];
        titleLab.text = @"";
        
        if(indexPath.section == 0)
        {
            titleLab.text = @"学英语";
        }else if (indexPath.section == 1) {
            titleLab.text = @"在线小游戏";
        }else{
            titleLab.text = @"本地小游戏";
        }
    }
   
    return headView;
}
#pragma mark -
#pragma mark --- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  
    if (indexPath.section == 0 || indexPath.section == 1) {
        FGWebViewGameViewController *webVC = [[FGWebViewGameViewController alloc]init];
        FGGameModel *model = indexPath.section ==0? self.englisthModelArr[indexPath.row]:self.onLineModelArr[indexPath.row];
        webVC.gameUrl = model.game_link;
        [self.navigationController pushViewController:webVC animated:YES];
    }else
    {
        FGTomViewController *tomVc = [[FGTomViewController alloc]init];
        [self.navigationController pushViewController:tomVc animated:YES];
    }
    
}


#pragma mark -
#pragma mark --- UICollectionViewDelegateFlowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
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
