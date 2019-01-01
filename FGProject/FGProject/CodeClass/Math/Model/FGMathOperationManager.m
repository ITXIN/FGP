//
//  FGMathOperationManager.m
//  FGProject
//
//  Created by avazuholding on 2017/11/12.
//  Copyright © 2017年 bert. All rights reserved.
//

#import "FGMathOperationManager.h"
#import "FGMathAnswerOptionsModel.h"
#import "FGMathOperationDataStatisticsModel.h"
#import "FGMathOperationModel.h"
#import "FGMistakesModel.h"
#import "FGMistakesOperationDataModel.h"
@implementation FGMathOperationManager

+ (FGMathOperationManager*)shareMathOperationManager{
    static FGMathOperationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FGMathOperationManager alloc] init];
        manager.operationsArr = @[@(MathOperationActionTypeAdd),@(MathOperationActionTypeSubtract),@(MathOperationActionTypeMultiply),@(MathOperationActionTypeDivide)];
        manager.dateSingle = [FGDateSingle shareInstance];
        manager.dataStatisticsModel = [[FGMathOperationDataStatisticsModel alloc]init];
        
    });
    return manager;
}

//获取运算符图片
- (UIImage*)getOperationImageWithOperationType:(MathOperationActionType)operationType{
    NSString *picStr;
    switch (operationType) {
        case MathOperationActionTypeAdd:
        {
            picStr = @"Add";
            break;
        }
        case MathOperationActionTypeSubtract:
        {
            picStr = @"Subtract";
            break;
        }
        case MathOperationActionTypeMultiply:
        {
            picStr = @"Multiply";
            break;
        }
        case MathOperationActionTypeDivide:
        {
            picStr = @"Divide";
            break;
        }
        default:
            break;
    }
    UIImage *operationImage = [UIImage imageNamed:picStr];
    return operationImage;
}

//获取运算数字的图片
- (UIImage*)getOperationNumberImageWithNumber:(NSInteger)number{
    
    NSString *numberStr = [NSString stringWithFormat:@"%ld",number];
    if (numberStr.length == 1) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"0%ld.png",(long)number]];
    }else{
        NSMutableArray *numberArr = [NSMutableArray array];
        for(int i =0; i < numberStr.length; i++){
            NSString *temp  = [NSString stringWithFormat:@"%@",[numberStr substringWithRange:NSMakeRange(i,1)]];
            UIImage *temImage = [UIImage imageNamed:[NSString stringWithFormat:@"0%@.png",temp]];
            [numberArr addObject:temImage];
        }
        if (numberArr.count == 0) {
            return nil;
        }
        UIImage *resultImage = [self drawImagesWithArr:numberArr];
        return resultImage;
    }
}

//拼接图片
- (UIImage *)drawImagesWithArr:(NSArray*)imagesArr{
    CGFloat sumWidth = 0;
    for (UIImage *image in imagesArr) {
        sumWidth = image.size.width;
        sumWidth += sumWidth;
    }
    
    CGSize contextSize = CGSizeMake(OPERATOR_HEIGHT, OPERATOR_HEIGHT);
    UIGraphicsBeginImageContext(contextSize);
    CGRect preFrame = CGRectZero;
    for (NSInteger i = 0 ; i < imagesArr.count; i ++) {
        UIImage *tempImage = (UIImage*)imagesArr[i];
        CGRect currentFrame;
        if (i == 0) {
            currentFrame = CGRectMake(0, 0, OPERATOR_HEIGHT/imagesArr.count, OPERATOR_HEIGHT);
        }else{
            currentFrame = CGRectMake(CGRectGetMinX(preFrame)+CGRectGetWidth(preFrame), 0, OPERATOR_HEIGHT/imagesArr.count, OPERATOR_HEIGHT);
        }
        [tempImage drawInRect:currentFrame];
        preFrame = currentFrame;
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

/**
 两级运算
 */

- (FGMathOperationModel*)generateMathOperationModelWithOperationType:(MathOperationActionType)mathOperationType{
    FGMathOperationModel *questModel = [FGMathOperationModel generateMathOperationModelWithOperationType:mathOperationType];
    self.currentMathOperationModel = questModel;
    return questModel;
}

/**
 产生三级加减混合运算
 */
- (FGMathOperationModel*)generateCompreMathOperationModelWithOperationType:(MathOperationActionType)mathOperationType{
    FGMathOperationModel *questModel = [FGMathOperationModel generateCompreMathOperationModelWithOperationType:mathOperationType];
    self.currentMathOperationModel = questModel;
    return questModel;
}

//随机答案选项
- (FGMathAnswerOptionsModel *)generateRandomAnswerNum:(NSInteger)answerNum{
    NSInteger firstNum = 0;
    //第二个数字
    NSInteger secondNum = 0;
    //第三个
    NSInteger thirdNum = 0;
    firstNum  = arc4random() % 4 + answerNum + 2;
    
    //运算符
    secondNum = arc4random() % kMathOperationRangeNumber;
    thirdNum = arc4random() % kMathOperationRangeNumber;
    
    FGMathAnswerOptionsModel *answerOptionModel = [[FGMathAnswerOptionsModel alloc]init];
    while (firstNum == answerNum){
        firstNum = arc4random() % kMathOperationRangeNumber;
    }
    
    while(firstNum == secondNum || secondNum == answerNum ){
        secondNum = arc4random() % kMathOperationRangeNumber;
    }
    
    while(firstNum == thirdNum  || secondNum == thirdNum  || thirdNum == answerNum){
        thirdNum = arc4random() % kMathOperationRangeNumber;
    }
    
    answerOptionModel.firstNum = [NSString stringWithFormat:@"%ld",firstNum];
    answerOptionModel.secondNum = [NSString stringWithFormat:@"%ld",secondNum];
    answerOptionModel.thirdNum = [NSString stringWithFormat:@"%ld",thirdNum];
    answerOptionModel.answerNum = [NSString stringWithFormat:@"%ld",answerNum];
    self.currentMathAnswerOperationModel = answerOptionModel;
    return answerOptionModel;
}

// MARK: - ----------------------------------  ----------------------------------
- (void)getOperationActionTypeStr:(MathOperationActionType)type{
//    NSString *operationStr = @"";
//    switch (type) {
//        case MathOperationActionTypeAdd:
//            operationStr = @"+";
//            break;
//        case MathOperationActionTypeSubtract:
//            operationStr = @"-";
//            break;
//        case MathOperationActionTypeMultiply:
//            operationStr = @"x";
//            break;
//        case MathOperationActionTypeDivide:
//            operationStr = @"/";
//            break;
//        case MathOperationActionTypeCompreOfSimple:
//            operationStr = @"+";
//            break;
//        case MathOperationActionTypeCompreOfMedium:
//            operationStr = @"+";
//            break;
//        case MathOperationActionTypeCompreOfChallenge:
//            operationStr = @"+";
//            break;
//        default:
//            break;
//    }
}

//保存运算数据统计
- (void)saveMathOperationDataStatisticsWithUserOperationState:(MathOperationChooseResultType)actionTypeAnswer{
    
    NSMutableDictionary *dataDic = [self getAllData];
    FGMathOperationModel *mathOperationModel = self.currentMathOperationModel;
    MathOperationActionType operationActionType = self.currentMathOperationModel.mathOperationActionType;
    
    MathCompreOfChallengeLevel timerLeverl = [self getCurrentChallengeLevel];
    NSDictionary *detailDic = @{
                                kMathOperationTypeKey:[NSString stringWithFormat:@"%ld",operationActionType],
                                kMathOperationStateKey:[NSString stringWithFormat:@"%@",actionTypeAnswer == MathOperationChooseResultTypeCorrect? @"YES":@"NO"],
                                kMathOperationObjKey:self.currentMathOperationModel ,
                                kMathOperationDateKey:[NSString stringWithFormat:@"%@",[self.dateSingle getDetailDate]],
                                kMathOperationCompreOfChallengeLevelKey:[NSString stringWithFormat:@"%ld",timerLeverl]
                                };
    
    FGLOG(@"%ld %ld %ld = %ld",mathOperationModel.firstNum,mathOperationModel.mathOperationActionType,mathOperationModel.secondNum,mathOperationModel.answerNum);
    
    if (dataDic.allValues.count == 0) {
        
        dataDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                  [self.dateSingle curretDate]:
                                                                      @{
                                                                          kMathOperationDetailDataKey:@[detailDic],
                                                                          kMathOperationDetailDataTotalNumberKey:[NSString stringWithFormat:@"%ld",[self getCurrentDateHasDone]],
                                                                          },
                                                                  kMathOperationDataStatisticsTotalNumberKey:@"1",
                                                                  kMathOperationCompreOfChallengeDataKey:
                                                                      @{
                                                                          kMathOperationCompreOfChallengeLevelOneTotalNumberKey:@"0",
                                                                          kMathOperationCompreOfChallengeLevelTwoTotalNumberKey:@"0",
                                                                          kMathOperationCompreOfChallengeLevelThreeTotalNumberKey:@"0",
                                                                          kMathOperationCompreOfChallengeTotalNumberKey:@"0",
                                                                          kMathOperationCompreOfChallengeHighestRecord:@"0",
                                                                          kMathOperationCompreOfChallengeLevelKey:[NSString stringWithFormat:@"%ld",timerLeverl]
                                                                          }
                                                                  }];
    }else{
        
        NSMutableDictionary *currentDateDic = [NSMutableDictionary dictionaryWithDictionary: dataDic[[self.dateSingle curretDate]]];
        
        NSMutableArray *currentDateDetailArr = [NSMutableArray arrayWithArray:
                                                currentDateDic[kMathOperationDetailDataKey]];
        [currentDateDetailArr addObject:detailDic];
        
        [currentDateDic setValue:[NSString stringWithFormat:@"%ld",currentDateDetailArr.count] forKey:kMathOperationDetailDataTotalNumberKey];
        [currentDateDic setValue:currentDateDetailArr forKey:kMathOperationDetailDataKey];
        
        [dataDic setValue:currentDateDic forKey:[self.dateSingle curretDate]];
        
        NSInteger totalNumber = [dataDic[kMathOperationDataStatisticsTotalNumberKey] integerValue];
        [dataDic setValue:[NSString stringWithFormat:@"%ld",++totalNumber] forKey:kMathOperationDataStatisticsTotalNumberKey];
      
        if (operationActionType == MathOperationActionTypeCompreOfChallenge) {
            
            NSMutableDictionary *challengeDataDic = [NSMutableDictionary dictionaryWithDictionary: dataDic[kMathOperationCompreOfChallengeDataKey]];
            
            NSInteger totalChallenge =  [challengeDataDic[kMathOperationCompreOfChallengeTotalNumberKey] integerValue];
            [challengeDataDic setValue:[NSString stringWithFormat:@"%ld",++totalChallenge] forKey:kMathOperationCompreOfChallengeTotalNumberKey];
            
            if (timerLeverl == MathCompreOfChallengeLevelOne) {
                NSInteger leveOne = [challengeDataDic[kMathOperationCompreOfChallengeLevelOneTotalNumberKey] integerValue];
                [challengeDataDic setValue:[NSString stringWithFormat:@"%ld",++leveOne] forKey:kMathOperationCompreOfChallengeLevelOneTotalNumberKey];
            }else if (timerLeverl == MathCompreOfChallengeLevelTwo){
                NSInteger leveTwo = [challengeDataDic[kMathOperationCompreOfChallengeLevelTwoTotalNumberKey] integerValue];
                [challengeDataDic setValue:[NSString stringWithFormat:@"%ld",++leveTwo] forKey:kMathOperationCompreOfChallengeLevelTwoTotalNumberKey];
            }else{
                NSInteger leveThree = [challengeDataDic[kMathOperationCompreOfChallengeLevelThreeTotalNumberKey] integerValue];
                [challengeDataDic setValue:[NSString stringWithFormat:@"%ld",++leveThree] forKey:kMathOperationCompreOfChallengeLevelThreeTotalNumberKey];
            }
            
            [dataDic setValue:challengeDataDic forKey:kMathOperationCompreOfChallengeDataKey];
            
        }
    }
    
    [FGProjectHelper saveDataWithKey:kMathOperationDataStatisticsKey data:dataDic];
    
    //更新统计
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self updateDataStatistic];
    });
    
}

#pragma mark -----------
- (NSMutableDictionary*)getAllData{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:[FGProjectHelper getDataWithKey:kMathOperationDataStatisticsKey]];
    return dataDic;
}

//获取错题数据
- (NSMutableArray*)getAllMistakes{
    NSMutableDictionary *dataDic = [self getAllData];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (id key in dataDic.allKeys) {
        if ([key isKindOfClass:[NSString class]] ) {
            if (![(NSString*)key hasPrefix:@"k"] ) {//日期
                NSMutableArray *mistakeOperationDataArr = [NSMutableArray array];
                for (NSDictionary*dic in dataDic[key][kMathOperationDetailDataKey]) {//模型
                    if ([dic[kMathOperationStateKey] isEqualToString:@"NO"]) {
                        FGMistakesOperationDataModel *mistakeOperationDataModel = [[FGMistakesOperationDataModel alloc]initWithDic:dic];
                        [mistakeOperationDataArr addObject:mistakeOperationDataModel];
                    }
                }
                if (mistakeOperationDataArr.count != 0) {
                    FGMistakesModel *mistakesModel = [[FGMistakesModel alloc]init];
                    mistakesModel.dataArr = mistakeOperationDataArr;
                    mistakesModel.mainTitle = [NSString stringWithFormat:@"%@",key];
                    mistakesModel.count = [NSString stringWithFormat:@"%@",dataDic[key][kMathOperationDetailDataTotalNumberKey]];
                    [dataArr addObject:mistakesModel];
                }
            }
        }
    }
    return dataArr;
}

//获取挑战模式最高记录
- (NSInteger)getCurrentChallengeHighestRecord{
    NSMutableDictionary *dataDic = [self getAllData];
    NSInteger heightRecode = [dataDic[kMathOperationCompreOfChallengeDataKey][kMathOperationCompreOfChallengeHighestRecord] integerValue];
    return heightRecode;
}

//更新挑战模式最高记录
- (void)updateCurrentChallengeHighestRecordWithNumber:(NSInteger)number{
    
    if (number > [self getCurrentChallengeHighestRecord]) {
        NSMutableDictionary *dataDic = [self getAllData];
        NSMutableDictionary *chanllengeDic = [NSMutableDictionary dictionaryWithDictionary: dataDic[kMathOperationCompreOfChallengeDataKey]];
        [chanllengeDic setValue:[NSString stringWithFormat:@"%ld",number] forKey:kMathOperationCompreOfChallengeHighestRecord];
        dataDic[kMathOperationCompreOfChallengeDataKey] = chanllengeDic;
        [FGProjectHelper saveDataWithKey:kMathOperationDataStatisticsKey data:dataDic];
    }
}

//获取挑战模式难度等级
- (MathCompreOfChallengeLevel)getCurrentChallengeLevel{
    NSMutableDictionary *dataDic = [self getAllData];
    if (!dataDic[kMathOperationCompreOfChallengeDataKey][kMathOperationCompreOfChallengeLevelKey]) {
        
        dataDic = [NSMutableDictionary dictionaryWithDictionary:
                   @{
                     kMathOperationCompreOfChallengeDataKey:@{
                             kMathOperationCompreOfChallengeLevelKey:[NSString stringWithFormat:@"%ld",MathCompreOfChallengeLevelOne]
                             }
                     }];
        
        [FGProjectHelper saveDataWithKey:kMathOperationDataStatisticsKey data:dataDic];
        return MathCompreOfChallengeLevelOne;
    }
    
    NSMutableDictionary *chanllengeDic = [NSMutableDictionary dictionaryWithDictionary: dataDic[kMathOperationCompreOfChallengeDataKey]];
    NSString *level = chanllengeDic[kMathOperationCompreOfChallengeLevelKey];
    
    if ([level integerValue] == MathCompreOfChallengeLevelOne) {
        return MathCompreOfChallengeLevelOne;
    }else if ([level integerValue] == MathCompreOfChallengeLevelTwo){
        return MathCompreOfChallengeLevelTwo;
    }else{
        return MathCompreOfChallengeLevelThree;
    }
}

- (void)updateCurrentChallengeLevel:(MathCompreOfChallengeLevel)level{
    NSMutableDictionary *dataDic = [self getAllData];
    NSMutableDictionary *chanllengeDic = [NSMutableDictionary dictionaryWithDictionary: dataDic[kMathOperationCompreOfChallengeDataKey]];
    chanllengeDic[kMathOperationCompreOfChallengeLevelKey] = [NSString stringWithFormat:@"%ld",level];
    dataDic[kMathOperationCompreOfChallengeDataKey] = chanllengeDic;
    [FGProjectHelper saveDataWithKey:kMathOperationDataStatisticsKey data:dataDic];
}




//数据统计
- (void)updateDataStatistic{
    
    NSMutableDictionary *dataDic = [self getAllData];
    
    NSInteger totalNumber = [dataDic[kMathOperationDataStatisticsTotalNumberKey] integerValue];
    self.dataStatisticsModel.totalNumber = totalNumber;
    
    NSArray *allKeys =  dataDic.allKeys;
    NSMutableArray *mistakesOperationModelArr = [NSMutableArray array];
    NSInteger addTotalNumber = 0;
    NSInteger subtractTotalNumber = 0;
    NSInteger multiplyTotalNumber = 0;
    NSInteger divideTotalNumber = 0;
    NSInteger compreOfSimpleTotalNumber = 0;
    NSInteger compreOfMediumTotalNumber = 0;
    NSInteger compreOfDiffcultyTotalNumber = 0;
    //正确的个数
    NSInteger addAccuracyNumber = 0;
    NSInteger subtractAccuracyNumber = 0;
    NSInteger multiplyAccuracyNumber = 0;
    NSInteger divideAccuracyNumber = 0;
    NSInteger compreOfSimpleAccuracyNumber = 0;
    NSInteger compreOfMediumAccuracyNumber = 0;
    NSInteger compreOfDiffcultyAccuracyNumber = 0;
    
    NSInteger totalAccuracyNumber = 0;
    for (NSString *key in allKeys) {
        if ([dataDic[key] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = dataDic[key];
            NSArray *detailArr = dic[kMathOperationDetailDataKey];
            
            for (NSDictionary *detailDic in detailArr) {
                FGMathOperationModel *mathOperationModel = detailDic[kMathOperationObjKey];
                [mistakesOperationModelArr addObject:mathOperationModel];
                NSInteger operationType =  [detailDic[kMathOperationTypeKey] integerValue];
                NSString *state =  detailDic[kMathOperationStateKey];
                BOOL isState = NO;
                if ([state isEqualToString:@"YES"]) {
                    isState = YES;
                    totalAccuracyNumber ++;
                }
                
                switch (operationType) {
                    case MathOperationActionTypeAdd:
                        addTotalNumber ++;
                        if (isState) {
                            addAccuracyNumber ++;
                        }
                        break;
                    case MathOperationActionTypeSubtract:
                        subtractTotalNumber ++;
                        if (isState) {
                            subtractAccuracyNumber ++;
                        }
                        break;
                    case MathOperationActionTypeMultiply:
                        multiplyTotalNumber ++;
                        if (isState) {
                            multiplyAccuracyNumber ++;
                        }
                        break;
                    case MathOperationActionTypeDivide:
                        divideTotalNumber ++;
                        if (isState) {
                            divideAccuracyNumber ++;
                        }
                        break;
                    case MathOperationActionTypeCompreOfSimple:
                        compreOfSimpleTotalNumber ++;
                        if (isState) {
                            compreOfSimpleAccuracyNumber ++;
                        }
                        break;
                    case MathOperationActionTypeCompreOfMedium:
                        compreOfMediumTotalNumber ++;
                        if (isState) {
                            compreOfMediumAccuracyNumber ++;
                        }
                        break;
                    case MathOperationActionTypeCompreOfChallenge:
                        compreOfDiffcultyTotalNumber ++;
                        if (isState) {
                            compreOfDiffcultyAccuracyNumber ++;
                        }
                        break;
                    default:
                        break;
                }
            }
        }
    }
    
    self.dataStatisticsModel.addTotalNumber = addTotalNumber;
    self.dataStatisticsModel.subtractTotalNumber = subtractTotalNumber;
    self.dataStatisticsModel.multiplyTotalNumber = multiplyTotalNumber;
    self.dataStatisticsModel.divideTotalNumber = divideTotalNumber;
    self.dataStatisticsModel.compreOfSimpleTotalNumber = compreOfSimpleTotalNumber;
    self.dataStatisticsModel.compreOfMediumTotalNumber = compreOfMediumTotalNumber;
    self.dataStatisticsModel.compreOfDiffcultyTotalNumber = compreOfDiffcultyTotalNumber;
    self.dataStatisticsModel.totalAccuracyNumber = totalAccuracyNumber;
}

#pragma mark -------保存综合练习题目类型设置----
- (void)saveMathCompreOfOperationType:(NSDictionary*)typeDic{
    NSMutableDictionary *dataDic = [self getAllData];
    dataDic[kMathCompreOfOperationChooseTypeKey] = typeDic;
    [FGProjectHelper saveDataWithKey:kMathOperationDataStatisticsKey data:dataDic];
}

- (NSDictionary*)getMathCompreOfOperationTypeDic{
    NSMutableDictionary *dataDic = [self getAllData];
    if (!dataDic[kMathCompreOfOperationChooseTypeKey]) {
        dataDic = [NSMutableDictionary dictionaryWithDictionary:
                   @{
                     kMathCompreOfOperationChooseTypeKey:@{
                             kMathCompreOfOperationChooseAddTypeKey:@"YES",
                             kMathCompreOfOperationChooseSubtractTypeKey:@"YES",
                             kMathCompreOfOperationChooseMultiplyTypeKey:@"YES",
                             kMathCompreOfOperationChooseDivideTypeKey:@"YES"
                             }}
                   ];
    }
    NSDictionary *typeDic = [NSDictionary dictionaryWithDictionary:dataDic[kMathCompreOfOperationChooseTypeKey]];
    return typeDic;
}

- (NSArray*)getMathCompreOfOperationTypeArr{
    NSDictionary *typeDic = [self getMathCompreOfOperationTypeDic];
    NSMutableArray *typeArr = [NSMutableArray array];
    for (NSString *key in typeDic.allKeys) {
        if ([typeDic[key] isEqualToString:@"YES"]) {
            if ([key isEqualToString:kMathCompreOfOperationChooseAddTypeKey]) {
                [typeArr addObject: @(MathOperationActionTypeAdd)];
            }else if ([key isEqualToString:kMathCompreOfOperationChooseSubtractTypeKey]){
                 [typeArr addObject: @(MathOperationActionTypeSubtract)];
            }else if ([key isEqualToString:kMathCompreOfOperationChooseMultiplyTypeKey]){
                 [typeArr addObject: @(MathOperationActionTypeMultiply)];
            }else if ([key isEqualToString:kMathCompreOfOperationChooseDivideTypeKey]){
                 [typeArr addObject: @(MathOperationActionTypeDivide)];
            }
        }
    }
    
    if (typeArr.count == 0) {
        return self.operationsArr;
    }
    
    return typeArr;
}

- (void)statisticOperationTypeWith:(NSInteger)operationType{
    switch (operationType) {
        case MathOperationActionTypeAdd:
            
            break;
        case MathOperationActionTypeSubtract:
            
            break;
        case MathOperationActionTypeMultiply:
            
            break;
        case MathOperationActionTypeDivide:
            
            break;
        case MathOperationActionTypeCompreOfSimple:
            
            break;
        case MathOperationActionTypeCompreOfMedium:
            
            break;
        case MathOperationActionTypeCompreOfChallenge:
            
            break;
        default:
            break;
    }
    
}

- (NSInteger)getCurrentDateHasDone{
    NSMutableDictionary *dataDic = [self getAllData];
    NSDictionary *currentDic = [dataDic objectForKey:[self.dateSingle curretDate]];
    NSString *hasDoneStr = currentDic[kMathOperationDetailDataTotalNumberKey];
    return [hasDoneStr integerValue];
}

@end
