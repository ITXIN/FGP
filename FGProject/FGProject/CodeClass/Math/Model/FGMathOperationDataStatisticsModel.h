//
//  FGMathOperationDataStatisticsModel.h
//  FGProject
//
//  Created by avazuholding on 2018/3/21.
//  Copyright © 2018年 bert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGMathOperationDataStatisticsModel : NSObject
//总数
@property (nonatomic,assign) NSInteger totalNumber;
//总共正确的
@property (nonatomic,assign) NSInteger totalAccuracyNumber;
//总共错误的
@property (nonatomic,assign) NSInteger totalMistakesNumber;

//各个类型的总数
@property (nonatomic,assign) NSInteger addTotalNumber;
@property (nonatomic,assign) NSInteger subtractTotalNumber;
@property (nonatomic,assign) NSInteger multiplyTotalNumber;
@property (nonatomic,assign) NSInteger divideTotalNumber;
@property (nonatomic,assign) NSInteger compreOfSimpleTotalNumber;
@property (nonatomic,assign) NSInteger compreOfMediumTotalNumber;
@property (nonatomic,assign) NSInteger compreOfDiffcultyTotalNumber;

//正确率
@property (nonatomic,assign) CGFloat addAccuracy;
@property (nonatomic,assign) CGFloat subtractAccuracy;
@property (nonatomic,assign) CGFloat multiplyAccuracy;
@property (nonatomic,assign) CGFloat divideAccuracy;
@property (nonatomic,assign) CGFloat compreOfSimpleAccuracy;
@property (nonatomic,assign) CGFloat compreOfMediumAccuracy;
@property (nonatomic,assign) CGFloat compreOfDiffcultyAccuracy;

@property (nonatomic,strong) NSMutableArray *mistakesOperationModelArr;



//@property (nonatomic,assign) NSInteger divideTotalNumber;
//@property (nonatomic,assign) NSInteger divideTotalNumber;


@end
