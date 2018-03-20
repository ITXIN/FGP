//
//  MediumOperationModel.m
//  FGProject
//
//  Created by Bert on 16/1/18.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "MediumOperationModel.h"

@implementation MediumOperationModel


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSNumber numberWithInteger:self.firstNum] forKey:@"firstNum"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.secondNum] forKey:@"secondNum"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.thirdNum] forKey:@"thirdNum"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.firstOperationType] forKey:@"firstOperationType"];
     [aCoder encodeObject:[NSNumber numberWithInteger:self.secondOperationType] forKey:@"secondOperationType"];
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self){
        
        self.firstNum =  [[aDecoder decodeObjectForKey:@"firstNum"] integerValue];
        self.secondNum =  [[aDecoder decodeObjectForKey:@"secondNum"] integerValue];
        self.thirdNum =  [[aDecoder decodeObjectForKey:@"thirdNum"] integerValue];
        self.firstOperationType =  [[aDecoder decodeObjectForKey:@"firstOperationType"] integerValue];
        self.secondOperationType =  [[aDecoder decodeObjectForKey:@"secondOperationType"] integerValue];
    }
    return self;
}
#pragma mark -
#pragma mark --- 产生运算式
+ (MediumOperationModel *)generateMediumOperation
{
    NSInteger firstNum = 0;
    //第二个数字
    NSInteger secondNum = 0;
    //运算符
    NSArray *operationArr = [[FGMathOperationManager shareMathOperationManager]operationsArr];
    MathOperationActionType currentMathOperationType = [operationArr[arc4random()%operationArr.count] integerValue];
    firstNum = arc4random() % 11;
    secondNum = arc4random() % 11;
    
    MediumOperationModel *questionModel = [MediumOperationModel new];
    if (currentMathOperationType == MathOperationActionTypeSubtract)
    {
        while(firstNum < secondNum)
        {
            firstNum = arc4random() % 11;
        }
        questionModel.answerNum = firstNum - secondNum;
    }else if(currentMathOperationType == MathOperationActionTypeAdd){
        questionModel.answerNum = firstNum + secondNum;
    }else if ( currentMathOperationType == MathOperationActionTypeMultiply){
         questionModel.answerNum = firstNum * secondNum;
    }
    questionModel.firstNum = firstNum;
    questionModel.secondNum = secondNum;
    questionModel.firstOperationType = currentMathOperationType;
    
    if (questionModel.answerNum > 0){
//        NSString *secondOperStr = operatorArr[arc4random()%2];
         MathOperationActionType secondMathOperationType = [operationArr[arc4random()%2] integerValue];
        NSInteger thirdNum = arc4random() % 11;
        if (secondMathOperationType == MathOperationActionTypeSubtract)
        {
            while (questionModel.answerNum < thirdNum)
            {
                thirdNum = arc4random() % 11;
            }
            questionModel.answerNum = questionModel.answerNum - thirdNum;
        }else if(secondMathOperationType == MathOperationActionTypeAdd)
        {
             questionModel.answerNum = questionModel.answerNum + thirdNum;
        }
//        else if([secondOperStr isEqualToString:MULTIPLY_OPERATOR_STR])
//        {
//            questionModel.answerNum = questionModel.answerNum * thirdNum;
//        }
        
        
        questionModel.secondOperationType = secondMathOperationType;
        questionModel.thirdNum = thirdNum;
    }else if (questionModel.answerNum == 0)
    {
        NSInteger thirdNum = arc4random() % 11;
        while (thirdNum == 0)
        {
            thirdNum = arc4random() % 11;
        }
        questionModel.thirdNum = thirdNum;
        questionModel.answerNum = questionModel.answerNum + thirdNum;
        questionModel.secondOperationType = MathOperationActionTypeAdd;
    }
    return questionModel;
}
//混淆答案
+ (MediumOperationModel *)candidateMediumWithAnswer:(NSInteger)userAnswer
{
    NSInteger firstNum = 0;
    //第二个数字
    NSInteger secondNum = 0;
    //第三个
    NSInteger thirdNum = 0;
    firstNum  = arc4random() % 4 + userAnswer + 2;
    secondNum = arc4random() % 11;
    thirdNum = arc4random() % 11;
    
    MediumOperationModel *questionModel = [[MediumOperationModel alloc]init];
    while (firstNum == userAnswer)
    {
        firstNum = arc4random() % 11;
    }
    while(firstNum == secondNum || secondNum == userAnswer )
    {
        secondNum = arc4random() % 11;
    }
    while(firstNum == thirdNum  || secondNum == thirdNum  || thirdNum == userAnswer)
    {
        thirdNum = arc4random() % 11;
    }
    questionModel.firstNum = firstNum;
    questionModel.secondNum = secondNum;
    questionModel.thirdNum = thirdNum;
    return questionModel;
}


@end
