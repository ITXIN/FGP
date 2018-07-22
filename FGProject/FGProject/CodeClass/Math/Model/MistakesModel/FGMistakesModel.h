//
//  FGMistakesModel.h
//  FGProject
//
//  Created by 鑫龙魂 on 2018/7/21.
//  Copyright © 2018年 bert. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FGMathOperationModel;
@interface FGMistakesModel : NSObject
@property (nonatomic, copy) NSString *mainTitle;//日期
@property (nonatomic, copy) NSString *count;
@property (nonatomic, strong) NSArray *dataArr;
@end
