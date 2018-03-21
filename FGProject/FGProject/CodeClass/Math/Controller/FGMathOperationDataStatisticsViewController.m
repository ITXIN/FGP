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
@end

@implementation FGMathOperationDataStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mathManager = [FGMathOperationManager shareMathOperationManager];
   FGLOG(@"");
}
- (void)initSubviews{
    [super initSubviews];
     self.mathManager = [FGMathOperationManager shareMathOperationManager];
    
//    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:[UIColor fgPieChartLightGreenColor]],
//                       [PNPieChartDataItem dataItemWithValue:20 color:[UIColor fgPieChartFreshGreenColor] description:@"WWDC"],
//                       [PNPieChartDataItem dataItemWithValue:70 color:[UIColor fgPieChartDeepGreenColor] description:@"GOOG I/O"],
//                       ];
    NSInteger mistakeTotal = [self.mathManager.dataStatisticsModel.totalStr integerValue]-self.mathManager.dataStatisticsModel.totalAccuracyNumber;
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:mistakeTotal color:[UIColor fgPieChartLightGreenColor]],
                       [PNPieChartDataItem dataItemWithValue:self.mathManager.dataStatisticsModel.totalNumber color:[UIColor fgPieChartFreshGreenColor] description:@"WWDC"],
                       ];
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake((CGFloat) (ScreenWidth / 2.0 - 100), 135, 200.0, 200.0) items:items];
    self.pieChart.descriptionTextColor = [UIColor whiteColor];
    self.pieChart.descriptionTextFont = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = NO;
    self.pieChart.showOnlyValues = NO;
    [self.pieChart strokeChart];
    
    
    self.pieChart.legendStyle = PNLegendItemStyleStacked;
    self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    
    self.legendView = [self.pieChart getLegendWithMaxWidth:200];
//    [legend setFrame:CGRectMake(130, 100, legend.frame.size.width, legend.frame.size.height)];
    [self.bgView addSubview:self.legendView];
    
    [self.bgView addSubview:self.pieChart];
    
    
}
- (void)setupLayoutSubviews{
    [super setupLayoutSubviews];
    [self.pieChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    [self.legendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pieChart);
        make.top.mas_equalTo(self.pieChart.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 20));
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
