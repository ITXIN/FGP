//
//  FGDateView.m
//  FGProject
//
//  Created by Bert on 2016/11/3.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGDateView.h"

@implementation FGDateView
{
    UILabel *timeLab;
    NSDateFormatter *timeFormmatter;
    NSDateFormatter *tempDateFormatter;
}

- (instancetype)init{
    self = [super init];
    if (self){
        UIVisualEffectView *effView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
        [self addSubview:effView];
        [effView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        effView.layer.cornerRadius = 5;
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
        [[NSRunLoop  currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        
        
        UIView *dateView = [[UIView alloc]init];
        UIView *timeView = [[UIView alloc]init];
        
        [self addSubview:dateView];
        [self addSubview:timeView];
        
        [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.width.mas_equalTo(self);
            make.height.equalTo(self.mas_height).multipliedBy(0.5);
            make.top.mas_equalTo(0);
        }];
        
        [dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.width.mas_equalTo(self);
            make.height.equalTo(self.mas_height).multipliedBy(0.5);
            make.top.mas_equalTo(timeView.mas_bottom).offset(0);
        }];
        
        NSDate *nowDate = [NSDate date];
        
        timeFormmatter = [[NSDateFormatter alloc]init];
        [timeFormmatter setDateFormat:@"hh:mm"];
        
        NSString *timeStr = [timeFormmatter stringFromDate:nowDate];
        //为了区分上午还是下午
        tempDateFormatter = [[NSDateFormatter alloc]init];
        [tempDateFormatter setDateFormat:@"HH"];
        
        timeLab = [[UILabel alloc]init];
        [timeView addSubview:timeLab];
        
        timeLab.textColor = [UIColor whiteColor];
        [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(timeView.mas_centerY);
            make.width.mas_equalTo(timeView);
            make.height.equalTo(self.mas_height).multipliedBy(0.5);
            make.left.mas_equalTo(00);
            
        }];
        timeLab.textAlignment = NSTextAlignmentCenter;
        timeLab.font = [UIFont boldSystemFontOfSize:50.0];
        timeLab.text = [NSString stringWithFormat:@"%@ %@",timeStr,[self isAmDateWithDate:nowDate]];
        
        NSDateFormatter *dateFormmatter = [[NSDateFormatter alloc]init];
        [dateFormmatter setDateFormat:@"YYYY-MM-dd"];
        NSString *dateStr = [dateFormmatter stringFromDate:nowDate];
        
        NSMutableArray *array = [NSMutableArray arrayWithArray: [dateStr componentsSeparatedByString:@"-"]];
        [array removeObjectAtIndex:0];
        NSArray *dateArr = @[@"月",@"日"];
        
        CGFloat itemW = 80;
        CGFloat space = 15;
        CGFloat fontSize = 45;
        CGFloat fontWeight = 10;
        
        for (int i = 0; i < 5; i ++){
            UILabel *dateLab = [[UILabel alloc]init];
            [dateView addSubview:dateLab];
            dateLab.textAlignment = NSTextAlignmentCenter;
            if (i %2 == 0){
                dateLab.textColor = [UIColor whiteColor];
                [dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(dateView.mas_centerY);
                    make.left.mas_equalTo(i/2*(itemW+space+5));
                    make.height.equalTo(self.mas_height).multipliedBy(0.5);
                    make.width.mas_equalTo(itemW);
                    
                }];
                if (i != 4){
                    dateLab.font = [UIFont boldSystemFontOfSize:fontSize];
                    dateLab.text = array[i/2];
                }else{
                    dateLab.font = [UIFont boldSystemFontOfSize:fontSize/2];
                    dateLab.text = [self weekdayStringFromDate:nowDate];
                }
            }else{
                
                dateLab.font = [UIFont boldSystemFontOfSize:fontSize/2];
                dateLab.textColor = [UIColor whiteColor];
                [dateLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(dateView);
                    make.left.mas_equalTo((i-1)/2*(itemW+space)+itemW);
                    make.size.mas_equalTo(CGSizeMake(20, 15));
                }];
                dateLab.text = dateArr[(i-1)/2];
            }
        }
    }
    
    return self;
}

#pragma mark -
#pragma mark --- 更新时间
- (void)updateTime:(NSTimer*)timer{
    [self updateTimeWithdate:[NSDate date]];
}

- (void)updateTimeWithdate:(NSDate*)date{
    timeLab.text = [NSString stringWithFormat:@"%@ %@",[timeFormmatter stringFromDate:date],[self isAmDateWithDate:date]];
    [UIView animateWithDuration:0.2 animations:^{
        timeLab.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        timeLab.transform = CGAffineTransformIdentity;
        
    }];
}

#pragma mark -
#pragma mark --- 判断是上午还是下午
- (NSString *)isAmDateWithDate:(NSDate*)date{
    NSInteger tempdateStr = [[tempDateFormatter stringFromDate:date] integerValue];;
    if (tempdateStr > 12) {
        return @"PM";
    }else{
        return @"AM";
    }
}

#pragma mark -
#pragma mark --- 获取星期
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

@end
