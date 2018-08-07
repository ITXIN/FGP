//
//  FGMistakesOperationDataModel.m
//  FGProject
//
//  Created by 鑫龙魂 on 2018/7/22.
//  Copyright © 2018年 bert. All rights reserved.
//

#import "FGMistakesOperationDataModel.h"

@implementation FGMistakesOperationDataModel

- (instancetype)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        self.dateKey = dic[kMathOperationDateKey];
        self.typeKey = dic[kMathOperationTypeKey];
        self.objeKey = dic[kMathOperationObjKey];
        self.stateKey = dic[kMathOperationStateKey];
    }
    return self;
}
- (void)setValue:(id)value forKey:(NSString *)key{
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
