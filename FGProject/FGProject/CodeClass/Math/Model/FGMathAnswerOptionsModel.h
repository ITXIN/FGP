//
//  FGMathAnswerOptionsModel.h
//  FGProject
//
//  Created by avazuholding on 2017/11/16.
//  Copyright © 2017年 bert. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGMathAnswerOptionsModel : NSObject
//@property (nonatomic,assign) NSInteger firstNum;
//@property (nonatomic,assign) NSInteger secondNum;
//@property (nonatomic,assign) NSInteger thirdNum;
//@property (nonatomic,assign) NSInteger answerNum;
@property (nonatomic,strong) NSString *firstNum;
@property (nonatomic,strong) NSString *secondNum;
@property (nonatomic,strong) NSString *thirdNum;
@property (nonatomic,strong) NSString *answerNum;
@property (nonatomic,assign) NSInteger answerIndex;

@end
