//
//  FGMathOperationManager.h
//  FGProject
//
//  Created by avazuholding on 2017/11/12.
//  Copyright © 2017年 bert. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MediumOperationModel;
@class FGMathAnswerOptionsModel;
@class FGMathOperationModel;
@class FGMathOperationDataStatisticsModel;
@class FGMathAnswerOptionsModel;
#import "FGMathOperationDataStatisticsModel.h"
@interface FGMathOperationManager : NSObject
+ (FGMathOperationManager*)shareMathOperationManager;
@property (nonatomic,strong) NSArray *operationsArr;

@property (nonatomic,strong) FGMathOperationModel *currentMathOperationModel;
@property (nonatomic, strong) FGMathAnswerOptionsModel *currentMathAnswerOperationModel;

@property (nonatomic,assign) BOOL isCompreOperation;

@property (nonatomic,strong) FGDateSingle *dateSingle;
@property (nonatomic,strong) FGMathOperationDataStatisticsModel *dataStatisticsModel;

//通过计算类型返回对应的图片
- (UIImage*)getOperationImageWithOperationType:(MathOperationActionType)operationType;
//通过数字返回对应的图片
- (UIImage*)getOperationNumberImageWithNumber:(NSInteger)number;
//计算类型返回运算模型
- (FGMathOperationModel*)generateSimpleOperationModelWithOperationType:(MathOperationActionType)mathOperationType;
//产生中等难度的运算模型
- (FGMathOperationModel*)generateMediumOperationModel;
//通过答案产生随机候选模型
- (FGMathAnswerOptionsModel *)generateRandomAnswerNum:(NSInteger)answerNum;

//获取今日已经做的个数
- (NSInteger)getCurrentDateHasDone;
//保存运算数据统计
- (void)saveMathOperationDataStatisticsWithUserOperationState:(MathSimpleOperationViewActionType)actionTypeAnswer;
//获取统计具体数据
- (void)updateDataStatistic;
//保存用户对运算类型的选择
- (void)saveMathCompreOfOperationType:(NSDictionary*)typeDic;
//获取用户对运算类型的选择
- (NSDictionary*)getMathCompreOfOperationTypeDic;
//获取用户对运算类型的选择
- (NSArray*)getMathCompreOfOperationTypeArr;
//获取存储的所有数据,
- (NSMutableDictionary*)getAllData;
//获取存储的错题
- (NSMutableArray*)getAllMistakes;
@end
