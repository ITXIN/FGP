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
@interface FGMathOperationManager : NSObject
+ (instancetype)shareMathOperationManager;
@property (nonatomic,strong) NSArray *operationsArr;
@property (nonatomic,strong) NSMutableDictionary *countDic;//统计已经做过的题目个数以及奖励
@property (nonatomic,strong) NSMutableDictionary *hasDoneDic;//

@property (nonatomic,strong) FGMathOperationModel *currentMathOperationModel;
@property (nonatomic,assign) BOOL isCompreOperation;

@property (nonatomic,strong) FGDateSingle *dateSingle;

- (UIImage*)getOperationImageWithOperationType:(MathOperationActionType)operationType;
- (UIImage*)getOperationNumberImageWithNumber:(NSInteger)number;
//- (QuestionModel*)generateSimpleOperationModelWithOperationType:(MathOperationActionType)mathOperationType;
- (FGMathOperationModel*)generateSimpleOperationModelWithOperationType:(MathOperationActionType)mathOperationType;

//- (MediumOperationModel*)generateMediumOperationModel;
- (FGMathOperationModel*)generateMediumOperationModel;

- (FGMathAnswerOptionsModel *)generateRandomAnswerNum:(NSInteger)answerNum;
- (void)saveCurrentDateHasDoneNumber:(NSInteger)number;
- (NSInteger)getCurrentDateHasDone;

- (void)saveMathOperationDataStatisticsWithUserOperationState:(MathSimpleOperationViewActionType)actionTypeAnswer;
@end
