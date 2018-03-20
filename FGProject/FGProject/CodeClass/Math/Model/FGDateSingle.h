//
//  DateSingle.h
//  FGProject
//
//  Created by XL on 15/7/6.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  时间单例
 */
@interface FGDateSingle : NSObject

+ (FGDateSingle *)shareInstance;

//当前的日期
- (NSString *)curretDate;
//当前详细日期
- (NSString*)getDetailDate;
//昨天的日期
- (NSString *)yesterDayDate;

@end
