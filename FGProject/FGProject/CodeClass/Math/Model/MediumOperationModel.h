//
//  MediumOperationModel.h
//  FGProject
//
//  Created by Bert on 16/1/18.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  中等难度运算模型
 */
@interface MediumOperationModel : NSObject
/**
 *  三个运算数字
 */
@property (nonatomic,assign) NSInteger firstNum;
@property (nonatomic,assign) NSInteger secondNum;
@property (nonatomic,assign) NSInteger thirdNum;

/**
 *  两个运算符
 */
@property (nonatomic,assign) MathOperationActionType firstOperationType;
@property (nonatomic,assign) MathOperationActionType secondOperationType;

/**
 *  正确答案
 */
@property (nonatomic,assign) NSInteger answerNum;
/**
 *  产生中等难度的运算式
 *
 */
+ (MediumOperationModel *)generateMediumOperation;

/**
 *  产生候选答案
 */
+ (MediumOperationModel *)candidateMediumWithAnswer:(NSInteger)userAnswer;



/**
 *  产生乘除运算
 */
@end
