//
//  FGMathOperationManager.h
//  FGProject
//
//  Created by avazuholding on 2017/11/12.
//  Copyright © 2017年 bert. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MediumOperationModel;
@class QuestionModel;
@class FGMathAnswerOptionsModel;
@class FGMathOperationModel;
@class FGMathOperationDataStatisticsModel;
#import "FGMathOperationDataStatisticsModel.h"
@interface FGMathOperationManager : NSObject
+ (FGMathOperationManager*)shareMathOperationManager;
@property (nonatomic,strong) NSArray *operationsArr;
@property (nonatomic,strong) NSMutableDictionary *countDic;//统计已经做过的题目个数以及奖励
@property (nonatomic,strong) NSMutableDictionary *hasDoneDic;//

@property (nonatomic,strong) FGMathOperationModel *currentMathOperationModel;
@property (nonatomic,assign) BOOL isCompreOperation;

@property (nonatomic,strong) FGDateSingle *dateSingle;
@property (nonatomic,strong) FGMathOperationDataStatisticsModel *dataStatisticsModel;


- (UIImage*)getOperationImageWithOperationType:(MathOperationActionType)operationType;
- (UIImage*)getOperationNumberImageWithNumber:(NSInteger)number;

- (FGMathOperationModel*)generateSimpleOperationModelWithOperationType:(MathOperationActionType)mathOperationType;

- (FGMathOperationModel*)generateMediumOperationModel;

- (FGMathAnswerOptionsModel *)generateRandomAnswerNum:(NSInteger)answerNum;
- (void)saveCurrentDateHasDoneNumber:(NSInteger)number;
- (NSInteger)getCurrentDateHasDone;

- (void)saveMathOperationDataStatisticsWithUserOperationState:(MathSimpleOperationViewActionType)actionTypeAnswer;
- (void)getDataStatistic;
@end
