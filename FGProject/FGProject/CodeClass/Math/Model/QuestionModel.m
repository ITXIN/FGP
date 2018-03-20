//
//  QuestionModel.m
//  FGProject
//
//  Created by XL on 15/7/1.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSNumber numberWithInteger:self.firstNum] forKey:@"firstNum"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.secondNum] forKey:@"secondNum"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.mathOperationActionType] forKey:@"mathOperationActionType"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self){
       
        self.firstNum =  [[aDecoder decodeObjectForKey:@"firstNum"] integerValue];
        self.secondNum =  [[aDecoder decodeObjectForKey:@"secondNum"] integerValue];
        self.mathOperationActionType =  [[aDecoder decodeObjectForKey:@"mathOperationActionType"] integerValue];
    }
    return self;
}


#pragma mark --------产生三个随机数,和答案一起,供用户选择----
+ (QuestionModel *)GenerateRandomAnwserNum:(NSInteger )userAnswer mathOperationActionType:(MathOperationActionType)operationType{
    NSInteger firstNum = 0;
    //第二个数字
    NSInteger secondNum = 0;
    //第三个
    NSInteger thirdNum = 0;
    firstNum  = arc4random() % 4 + userAnswer + 2;
    //运算符
    if (operationType == MathOperationActionTypeSubtract){
        firstNum = arc4random() % 4 + userAnswer + 1;
    }
    
    secondNum = arc4random() % kMathOperationRangeNumber;
    thirdNum = arc4random() % kMathOperationRangeNumber;
    
    QuestionModel *questionModel = [QuestionModel new];
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

#pragma mark --------产生运算题目----
+ (QuestionModel *)GenerateRandomNumWithOperationType:(MathOperationActionType )operationType{
    NSInteger firstNum = 0;
    //第二个数字
    NSInteger secondNum = 0;
    //运算符
    MathOperationActionType currentOperationTyp;
    NSArray *operationArr = [[FGMathOperationManager shareMathOperationManager]operationsArr];
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
    QuestionModel *questionModel = [QuestionModel new];
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
    questionModel.userAnswerStr = nil;
    return questionModel;
}


@end
