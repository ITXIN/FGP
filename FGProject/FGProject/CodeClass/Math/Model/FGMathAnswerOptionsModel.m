//
//  FGMathAnswerOptionsModel.m
//  FGProject
//
//  Created by avazuholding on 2017/11/16.
//  Copyright © 2017年 bert. All rights reserved.
//

#import "FGMathAnswerOptionsModel.h"

@implementation FGMathAnswerOptionsModel

- (instancetype)init{
    self = [super init];
    if (self){
        self.answerIndex =  arc4random() % 4;
    }
    return self;
}

@end
