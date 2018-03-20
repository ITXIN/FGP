//
//  QuestionModel.h
//  FGProject
//
//  Created by XL on 15/7/1.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  简单题目的 model
 */
@interface QuestionModel : NSObject<NSCoding>
@property (nonatomic,assign) MathOperationActionType mathOperationActionType;
@property (nonatomic, assign) NSInteger firstNum;
@property (nonatomic, assign) NSInteger secondNum;
//正确答案
@property (nonatomic, assign) NSInteger answerNum;
//用户的答案
@property (nonatomic, strong) NSString *userAnswerStr;
@property (nonatomic, assign) NSInteger thirdNum;


+ (QuestionModel *)GenerateRandomNumWithOperationType:(MathOperationActionType )operationType;
+ (QuestionModel *)GenerateRandomAnwserNum:(NSInteger )userAnswer mathOperationActionType:(MathOperationActionType)operationType;

@end
