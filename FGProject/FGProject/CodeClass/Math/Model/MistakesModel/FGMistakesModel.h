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
@property (nonatomic, copy) NSString *dateKey;
@property (nonatomic, strong) FGMathOperationModel *objeKey;
@property (nonatomic, copy) NSString *stateKey;
@property (nonatomic, copy) NSString *typeKey;
- (instancetype)initWithDic:(NSDictionary*)dic;
@end
