//
//  FGMyCenterViewController.m
//  FGProject
//
//  Created by avazuholding on 2017/11/15.
//  Copyright © 2017年 bert. All rights reserved.
//

#import "FGMyCenterViewController.h"
#import "FGMyCenterCell.h"
#import "CusLayerView.h"
#import "FGSetupPhotoViewController.h"
@interface FGMyCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation FGMyCenterViewController
static NSString *myCenterIdentifier = @"myCenterIdentifier";
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initSubviews{
    [super initSubviews];
    self.dataArr = @[@"设置按钮点击音效",@"设置头像"];
    CusLayerView * cus = [[CusLayerView alloc]initWithFrame:self.view.bounds];
    cus.backgroundColor = [UIColor clearColor];
    [self.bgView insertSubview:cus belowSubview:self.navigationView];
    cus.myCenterViewActionBlock = ^(MyCenterViewActionType type) {
        switch (type) {
            case MyCenterViewActionTypeEditeUserIcon:
            {
                FGSetupPhotoViewController *setupPhotoVC = [[FGSetupPhotoViewController alloc]init];
                [self.navigationController pushViewController:setupPhotoVC animated:YES];
                break;
            }
            
                
            default:
                break;
        }
    };
    
//    UIButton *myCenterBtn = ({
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.bgView addSubview:btn];
//        [btn setImage:[UIImage imageNamed:@"my_center"] forState:UIControlStateNormal];
//        btn.layer.cornerRadius = 50;
//        btn.layer.masksToBounds = YES;
//        btn.backgroundColor = [UIColor whiteColor];
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(30);
//            make.centerX.equalTo(self.bgView);
//            make.size.mas_equalTo(CGSizeMake(100, 100));
//        }];
////        [btn addTarget:self action:@selector(myCenterAction:) forControlEvents:UIControlEventTouchUpInside];
//        btn;
//    });
//
//    for (NSInteger i = 0 ; i < 2; i ++) {
//        UIButton *editeBtn = ({
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [self.bgView addSubview:btn];
//            [btn setImage:[UIImage imageNamed:@"my_center"] forState:UIControlStateNormal];
//            btn.layer.cornerRadius = 5;
//            btn.layer.masksToBounds = YES;
//            btn.backgroundColor = [UIColor whiteColor];
//            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(myCenterBtn.mas_bottom).offset(15);
//                if (i == 0) {
//                    make.right.mas_equalTo(myCenterBtn.mas_left).offset(-15);
//                }else{
//                    make.left.mas_equalTo(myCenterBtn.mas_right).offset(15);
//                }
//                make.size.mas_equalTo(CGSizeMake(100, 50));
//            }];
//            //        [btn addTarget:self action:@selector(myCenterAction:) forControlEvents:UIControlEventTouchUpInside];
//            btn;
//        });
//    }
//    
    
    
    
//    self.tableView = ({
//        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//        tableView.delegate = self;
//        tableView.dataSource = self;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        tableView.showsVerticalScrollIndicator = NO;
//        [self.bgView insertSubview:tableView belowSubview:self.navigationView];
////        tableView.backgroundColor = HEX_ARGB(@"f6f6f6");
//        tableView.delaysContentTouches = NO;
//        [tableView registerClass:[FGMyCenterCell class] forCellReuseIdentifier:myCenterIdentifier];
//        tableView;
//    });
    
    
    
}


#pragma mark - UITableviewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FGMyCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:myCenterIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLab.text = self.dataArr[indexPath.row];
   
    return cell;
}




- (void)setupLayoutSubviews{
    [super setupLayoutSubviews];
    
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
