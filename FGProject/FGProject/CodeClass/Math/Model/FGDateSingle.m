//
//  DateSingle.m
//  FGProject
//
//  Created by XL on 15/7/6.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import "FGDateSingle.h"

@implementation FGDateSingle
+ (FGDateSingle *)shareInstance
{
    
    static FGDateSingle *dateSingle = nil;//声明一个全局的指针
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateSingle = [[self alloc] init];
    });
    return dateSingle;
}
- (NSDate*)date{
     NSDate *senddate = [NSDate date];
    return senddate;
}
//获取当前的时间
- (NSString *)curretDate
{
//    NSDate *senddate = [NSDate date];
    return [self stringWithDate:[self date]];
}

- (NSString *)stringWithDate:(NSDate *)date
{
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *locationString = [dateformatter stringFromDate:date];
    NSLog(@"今天日期 %@",locationString);
    return locationString;
}

- (NSString*)getDetailDate{
//    NSDate *senddate = [NSDate date];
    return [self detailDateWithDate:[self date]];
}
- (NSString *)detailDateWithDate:(NSDate *)date
{
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *locationString = [dateformatter stringFromDate:date];
    NSLog(@"今天日期 %@",locationString);
    return locationString;
}

//获取昨天的时间
- (NSString *)yesterDayDate
{
    NSDate *yesterdayDate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    return [self stringWithDate:yesterdayDate];
}

@end
