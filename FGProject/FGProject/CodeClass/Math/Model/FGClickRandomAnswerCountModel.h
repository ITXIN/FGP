//
//  FGClickRandomAnswerCountModel.h
//  FGProject
//
//  Created by Bert on 2017/1/10.
//  Copyright © 2017年 XL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediumOperationModel.h"
@interface FGClickRandomAnswerCountModel : NSObject
//@property (nonatomic,strong) QuestionModel *questionModel;//运算式
//@property (nonatomic,strong) QuestionModel *randomAnswerModel;//随机答案


@property (nonatomic,strong) MediumOperationModel *questionMediumModel;
@property (nonatomic,strong) MediumOperationModel *randomMediumModel;


@property (nonatomic, assign) NSInteger firstNum;
@property (nonatomic, assign) NSInteger secondNum;
@property (nonatomic, assign) NSInteger thirdNum;

@end
