//
//  FGMathOperationModel.m
//  FGProject
//
//  Created by avazuholding on 2018/3/21.
//  Copyright © 2018年 bert. All rights reserved.
//

#import "FGMathOperationModel.h"

@implementation FGMathOperationModel
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSNumber numberWithInteger:self.firstNum] forKey:@"firstNum"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.secondNum] forKey:@"secondNum"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.thirdNum] forKey:@"thirdNum"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.answerNum] forKey:@"answerNum"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.mathOperationActionType] forKey:@"mathOperationActionType"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.firstOperationType] forKey:@"firstOperationType"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.secondOperationType] forKey:@"secondOperationType"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.operationLevel] forKey:@"operationLevel"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self){
        
        self.firstNum =  [[aDecoder decodeObjectForKey:@"firstNum"] integerValue];
        self.secondNum =  [[aDecoder decodeObjectForKey:@"secondNum"] integerValue];
        self.thirdNum =  [[aDecoder decodeObjectForKey:@"thirdNum"] integerValue];
        self.answerNum =  [[aDecoder decodeObjectForKey:@"answerNum"] integerValue];
        self.mathOperationActionType =  [[aDecoder decodeObjectForKey:@"mathOperationActionType"] integerValue];
        self.firstOperationType =  [[aDecoder decodeObjectForKey:@"firstOperationType"] integerValue];
        self.secondOperationType =  [[aDecoder decodeObjectForKey:@"secondOperationType"] integerValue];
        self.operationLevel =  [[aDecoder decodeObjectForKey:@"operationLevel"] integerValue];
    }
    return self;
}

#pragma mark --------产生三个随机数,和答案一起,供用户选择----
+ (FGMathOperationModel *)generateRandomAnwserNum:(NSInteger)userAnswer{
    NSInteger firstNum = 0;
    //第二个数字
    NSInteger secondNum = 0;
    //第三个
    NSInteger thirdNum = 0;
    firstNum  = arc4random() % 4 + userAnswer + 2;
    secondNum = arc4random() % kMathOperationRangeNumber;
    thirdNum = arc4random() % kMathOperationRangeNumber;
    
    FGMathOperationModel *questionModel = [FGMathOperationModel new];
    while (firstNum == userAnswer){
        firstNum = arc4random() % kMathOperationRangeNumber;
    }
    
    while(firstNum == secondNum || secondNum == userAnswer ){
        secondNum = arc4random() % kMathOperationRangeNumber;
    }
    
    while(firstNum == thirdNum  || secondNum == thirdNum  || thirdNum == userAnswer){
        thirdNum = arc4random() % kMathOperationRangeNumber;
    }
    
    questionModel.firstNum = firstNum;
    questionModel.secondNum = secondNum;
    questionModel.thirdNum = thirdNum;
    return questionModel;
}

#pragma mark --------产生运算题目---- 二元运算
+ (FGMathOperationModel *)generateMathOperationModelWithOperationType:(MathOperationActionType )operationType{
    NSInteger firstNum = 0;
    //第二个数字
    NSInteger secondNum = 0;
    //运算符
    MathOperationActionType currentOperationTyp;
    NSArray *operationArr = [[FGMathOperationManager shareMathOperationManager]getMathCompreOfOperationTypeArr];
    
    if (operationType == MathOperationActionTypeCompreOfSimple){
        currentOperationTyp = [(NSNumber*)operationArr[arc4random()%operationArr.count] integerValue];
    }else{
        currentOperationTyp = operationType;
    }
    
    firstNum = arc4random() % kMathOperationRangeNumber;
    secondNum = arc4random() % kMathOperationRangeNumber;
    if (currentOperationTyp == MathOperationActionTypeDivide) {
        while (secondNum == 0) {
            secondNum = arc4random()%kMathOperationRangeNumber;
        }
        firstNum = secondNum * firstNum;
    }
    FGMathOperationModel *questionModel = [FGMathOperationModel new];
    if (currentOperationTyp == MathOperationActionTypeSubtract){
        while(firstNum < secondNum){
            firstNum = arc4random() % kMathOperationRangeNumber;
        }
        questionModel.answerNum= firstNum - secondNum;
    }else if(currentOperationTyp == MathOperationActionTypeAdd){
        questionModel.answerNum = firstNum + secondNum;
    }else if (currentOperationTyp == MathOperationActionTypeMultiply){
        questionModel.answerNum = firstNum*secondNum;
    }else if (currentOperationTyp == MathOperationActionTypeDivide){
        questionModel.answerNum = firstNum/secondNum;
    }
    
    questionModel.firstNum = firstNum;
    questionModel.secondNum = secondNum;
    questionModel.mathOperationActionType = currentOperationTyp;
    questionModel.operationLevel = MathOperationLevelTwo;
    //    questionModel.userAnswerStr = nil;
    return questionModel;
}
// MARK: - ---------------------------------- 三个数 ----------------------------------
#pragma mark -
#pragma mark --- 产生运算式 随机
+(FGMathOperationModel *)generateMathOperationModel{
    
//    NSArray *operationArr = [[FGMathOperationManager shareMathOperationManager]operationsArr];
     NSArray *operationArr = [[FGMathOperationManager shareMathOperationManager]getMathCompreOfOperationTypeArr];
    
    MathOperationActionType firstOperationType = [operationArr[arc4random()%operationArr.count] integerValue];
    FGMathOperationModel *questModel = [FGMathOperationModel generateMathOperationModelWithOperationType:firstOperationType];
    FGMathOperationModel *mediumOperationModel = [[FGMathOperationModel alloc]init];
    mediumOperationModel.firstOperationType = firstOperationType;
    mediumOperationModel.firstNum = questModel.firstNum;
    mediumOperationModel.secondNum = questModel.secondNum;
    mediumOperationModel.answerNum = questModel.answerNum;
    
    MathOperationActionType secondMathOperationType = [operationArr[arc4random()%operationArr.count] integerValue];
    NSInteger thirdNum = arc4random() % kMathOperationRangeNumber;
    
    if (mediumOperationModel.firstOperationType == MathOperationActionTypeMultiply || mediumOperationModel.firstOperationType == MathOperationActionTypeDivide) {
        
            if (mediumOperationModel.answerNum == 0) {
                if (secondMathOperationType == MathOperationActionTypeAdd){
                    mediumOperationModel.answerNum = mediumOperationModel.answerNum + thirdNum;
                }else if (secondMathOperationType == MathOperationActionTypeSubtract) {
                    thirdNum = 0;
                    mediumOperationModel.answerNum = mediumOperationModel.answerNum - thirdNum;
                }else if(secondMathOperationType == MathOperationActionTypeMultiply){
                    mediumOperationModel.answerNum = 0;
                }else if(secondMathOperationType == MathOperationActionTypeDivide){
                    mediumOperationModel.answerNum = 0;
                }
                
            }else if(mediumOperationModel.answerNum > 0){
                
                if (secondMathOperationType == MathOperationActionTypeAdd){
                    mediumOperationModel.answerNum = mediumOperationModel.answerNum + thirdNum;
                }else if (secondMathOperationType == MathOperationActionTypeSubtract) {
                    thirdNum = arc4random() %(mediumOperationModel.answerNum +1);
                    mediumOperationModel.answerNum = mediumOperationModel.answerNum - thirdNum;
                }else if(secondMathOperationType == MathOperationActionTypeMultiply){
                    mediumOperationModel.answerNum =  mediumOperationModel.answerNum*thirdNum;
                }else if (secondMathOperationType == MathOperationActionTypeDivide){
                    NSMutableArray *tempArr = [NSMutableArray array];
                    NSInteger n = mediumOperationModel.answerNum;
                    for (NSInteger i = 1; i <= n ; i ++) {
                        if ((n%i == 0)) {
                            [tempArr addObject:@(i)];
                        }
                    }
                    thirdNum = [tempArr[arc4random()%tempArr.count] integerValue];
                    mediumOperationModel.answerNum = mediumOperationModel.answerNum / thirdNum;
                }
                
            }else{
                [SVProgressHUD showErrorWithStatus:@"Error"];
            }
       
    }else if(mediumOperationModel.firstOperationType == MathOperationActionTypeAdd || mediumOperationModel.firstOperationType == MathOperationActionTypeSubtract){
        //目前只支持先计算前面的结果
        
        if (mediumOperationModel.answerNum == 0) {
            secondMathOperationType = mediumOperationModel.firstOperationType;
            if (secondMathOperationType == MathOperationActionTypeAdd) {
                mediumOperationModel.answerNum = mediumOperationModel.answerNum + thirdNum;
            }else if(secondMathOperationType == MathOperationActionTypeSubtract){
                thirdNum = 0;
                mediumOperationModel.answerNum = 0;
            }
            
        }else if(mediumOperationModel.answerNum > 0){
            secondMathOperationType = mediumOperationModel.firstOperationType;
            
            if (secondMathOperationType == MathOperationActionTypeAdd){
                mediumOperationModel.answerNum = mediumOperationModel.answerNum + thirdNum;
            }else if (secondMathOperationType == MathOperationActionTypeSubtract) {
                thirdNum = arc4random() %(mediumOperationModel.answerNum +1);
                mediumOperationModel.answerNum = mediumOperationModel.answerNum - thirdNum;
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"Error"];
        }
        
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"异常"];
    }
    mediumOperationModel.secondOperationType = secondMathOperationType;
    mediumOperationModel.thirdNum = thirdNum;
    mediumOperationModel.operationLevel = MathOperationLevelThird;
    
    /*
    if (mediumOperationModel.answerNum > 0) {//只有加减
        
        MathOperationActionType secondMathOperationType = [operationArr[arc4random()%2] integerValue];
        NSInteger thirdNum = arc4random() % kMathOperationRangeNumber;
        if (secondMathOperationType == MathOperationActionTypeSubtract){
            while (mediumOperationModel.answerNum < thirdNum){
                thirdNum = arc4random() % kMathOperationRangeNumber;
            }
            mediumOperationModel.answerNum = mediumOperationModel.answerNum - thirdNum;
        }else if(secondMathOperationType == MathOperationActionTypeAdd){
            mediumOperationModel.answerNum = mediumOperationModel.answerNum + thirdNum;
        }
        
        mediumOperationModel.secondOperationType = secondMathOperationType;
        mediumOperationModel.thirdNum = thirdNum;
    }else{
        
        NSInteger thirdNum = arc4random() % kMathOperationRangeNumber;
        if (thirdNum == 0) {
            //当都为0，最后一个既可以为加号也可以为减号。
            MathOperationActionType secondMathOperationType = [operationArr[arc4random()%2] integerValue];
            mediumOperationModel.thirdNum = thirdNum;
            mediumOperationModel.answerNum = mediumOperationModel.answerNum + thirdNum;
            mediumOperationModel.secondOperationType = secondMathOperationType;
            
        }else{
            mediumOperationModel.answerNum = mediumOperationModel.answerNum + thirdNum;
            mediumOperationModel.secondOperationType = MathOperationActionTypeAdd;
            mediumOperationModel.thirdNum = thirdNum;
        }
        
        
    }
    mediumOperationModel.operationLevel = MathOperationLevelThird;
    
    */
    return mediumOperationModel;
}



@end
