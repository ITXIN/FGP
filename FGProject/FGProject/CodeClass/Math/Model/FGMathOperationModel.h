//
//  FGMathOperationModel.h
//  FGProject
//
//  Created by avazuholding on 2018/3/21.
//  Copyright © 2018年 bert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGMathOperationModel : NSObject<NSCoding>
//为两个数运算
@property (nonatomic, assign) MathOperationActionType mathOperationActionType;

@property (nonatomic, assign) MathOperationLevel operationLevel;
@property (nonatomic, assign) NSInteger firstNum;
@property (nonatomic, assign) NSInteger secondNum;
//正确答案
@property (nonatomic, assign) NSInteger answerNum;

@property (nonatomic, assign) NSInteger thirdNum;//候选答案
/**
 *  两个运算符 为三个数运算
 */
@property (nonatomic,assign) MathOperationActionType firstOperationType;
@property (nonatomic,assign) MathOperationActionType secondOperationType;

+ (FGMathOperationModel *)generateMathOperationModelWithOperationType:(MathOperationActionType )operationType;
+ (FGMathOperationModel *)generateCompreMathOperationModelWithOperationType:(MathOperationActionType )operationType;
+ (FGMathOperationModel *)generateRandomAnwserNum:(NSInteger)userAnswer;
@end
