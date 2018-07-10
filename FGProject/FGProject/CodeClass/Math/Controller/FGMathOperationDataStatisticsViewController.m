//
//  FGMathOperationDataStatisticsViewController.m
//  FGProject
//
//  Created by avazuholding on 2018/3/21.
//  Copyright © 2018年 bert. All rights reserved.
//

#import "FGMathOperationDataStatisticsViewController.h"

@interface FGMathOperationDataStatisticsViewController ()
@property (nonatomic,strong) PNPieChart *pieChart;
@property (nonatomic,strong) UIView  *legendView;
@property (nonatomic,strong) FGMathOperationManager *mathManager;
@property (nonatomic,strong) UIButton *totalPercentageBtn;
@property (nonatomic,strong) UILabel *totalNumberLab;

@property (nonatomic,strong) PNPieChart *detailPieChart;
@property (nonatomic,strong) UIView  *detailLegendView;
@end

@implementation FGMathOperationDataStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mathManager = [FGMathOperationManager shareMathOperationManager];
    FGLOG(@"2%@",self.mathManager);
}
- (void)initSubviews{
    [super initSubviews];
    //先调用这个而后调用 viewDidLoad
    FGLOG(@"1%@",self.mathManager);
    self.mathManager = [FGMathOperationManager shareMathOperationManager];
    
    //    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:[UIColor fgPieChartLightGreenColor]],
    //                       [PNPieChartDataItem dataItemWithValue:20 color:[UIColor fgPieChartFreshGreenColor] description:@"WWDC"],
    //                       [PNPieChartDataItem dataItemWithValue:70 color:[UIColor fgPieChartDeepGreenColor] description:@"GOOG I/O"],
    //                       ];
    NSInteger mistakeTotal = self.mathManager.dataStatisticsModel.totalMistakesNumber;
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:mistakeTotal color:[UIColor fgPieChartDeepRedColor] description:@"错误"],
                       [PNPieChartDataItem dataItemWithValue:self.mathManager.dataStatisticsModel.totalAccuracyNumber color:[UIColor fgPieChartFreshGreenColor] description:@"正确"],
                       ];
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake((CGFloat) (ScreenWidth / 2.0 - 100), 135, 200.0, 200.0) items:items];
    [self setupPieChart:self.pieChart];
    self.legendView = [self.pieChart getLegendWithMaxWidth:200];
    [self.bgView addSubview:self.legendView];
    [self.bgView addSubview:self.pieChart];
    
    self.totalPercentageBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:btn];
        btn.tag = 1000;
        btn.backgroundColor = [UIColor fgPieChartLightGreenColor];
        btn.layer.cornerRadius = 10;
        btn.layer.masksToBounds = YES;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:@"显示百分比样式" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.hidden = self.mathManager.dataStatisticsModel.totalNumber == 0?YES:NO;
        btn;
    });
    
    self.totalNumberLab = ({
        UILabel *label = [[UILabel alloc]init];
        [self.pieChart addSubview:label];
        label.textColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"总答题数:\n%ld",self.mathManager.dataStatisticsModel.totalNumber];
        label.numberOfLines = 0;
        label;
    });
    
    
    NSArray *itemsTotalArr = @[[PNPieChartDataItem dataItemWithValue:self.mathManager.dataStatisticsModel.addTotalNumber color:[UIColor fgPieChartDeepRedColor] description:@"加法"],
                               [PNPieChartDataItem dataItemWithValue:self.mathManager.dataStatisticsModel.subtractTotalNumber color:[UIColor fgPieChartFreshGreenColor] description:@"减法"],
                               [PNPieChartDataItem dataItemWithValue:self.mathManager.dataStatisticsModel.multiplyTotalNumber color:[UIColor fgPieChartFreshGreenColor] description:@"乘法"],
                               [PNPieChartDataItem dataItemWithValue:self.mathManager.dataStatisticsModel.divideTotalNumber color:[UIColor fgPieChartFreshGreenColor] description:@"除法"],
                               [PNPieChartDataItem dataItemWithValue:self.mathManager.dataStatisticsModel.compreOfSimpleTotalNumber color:[UIColor fgPieChartFreshGreenColor] description:@"简单混合运算"],
                               [PNPieChartDataItem dataItemWithValue:self.mathManager.dataStatisticsModel.compreOfMediumTotalNumber color:[UIColor fgPieChartFreshGreenColor] description:@"中等混合运算"],
                               [PNPieChartDataItem dataItemWithValue:self.mathManager.dataStatisticsModel.compreOfDiffcultyTotalNumber color:[UIColor fgPieChartFreshGreenColor] description:@"困难混合运算"],
                               ];
    self.detailPieChart = [[PNPieChart alloc] initWithFrame:CGRectMake((CGFloat) (ScreenWidth / 2.0 - 100), 135, 200.0, 200.0) items:itemsTotalArr];
    [self setupPieChart:self.detailPieChart];
    self.detailLegendView = [self.detailPieChart getLegendWithMaxWidth:200];
    [self.bgView addSubview:self.detailLegendView];
    [self.bgView addSubview:self.detailPieChart];
    
    self.detailPieChart.hidden = YES;
    self.detailLegendView.hidden = YES;
}

#pragma mark -
- (void)btnAction:(UIButton*)sender{
    NSInteger tag = sender.tag;
    if (tag == 1000) {
        sender.selected = !sender.selected;
        if (!sender.selected) {
            [sender setTitle:@"显示百分比样式" forState:UIControlStateNormal];
        }else{
            [sender setTitle:@"显示数量样式" forState:UIControlStateNormal];
        }
        
        self.pieChart.showAbsoluteValues = !sender.selected;
        [self.pieChart strokeChart];
    }
    
}

#pragma mark -
- (void)setupPieChart:(PNPieChart*)pieChart{
    pieChart.descriptionTextColor = [UIColor whiteColor];
    pieChart.descriptionTextFont = [UIFont fontWithName:@"Avenir-Medium" size:20.0];
    pieChart.descriptionTextShadowColor = [UIColor yellowColor];
    pieChart.showAbsoluteValues = YES;
    pieChart.showOnlyValues = NO;
    [pieChart strokeChart];
    pieChart.legendStyle = PNLegendItemStyleStacked;
    pieChart.legendFont = [UIFont boldSystemFontOfSize:15.0f];
}

- (void)setupLayoutSubviews{
    [super setupLayoutSubviews];
    [self.pieChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    [self.totalNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.pieChart);
        make.size.mas_equalTo(CGSizeMake(100, 50));
        
    }];
    [self.legendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pieChart);
        make.top.mas_equalTo(self.pieChart.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.totalPercentageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.legendView.mas_right).offset(20);
        make.top.mas_equalTo(self.legendView).offset(10);
//        make.bottom.mas_equalTo(self.legendView);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(25);
    }];
    
    [self.detailPieChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pieChart);
        make.left.mas_equalTo(self.pieChart.mas_right).offset(50);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    [self.detailLegendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.detailPieChart);
        make.top.mas_equalTo(self.detailPieChart.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 20));
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
