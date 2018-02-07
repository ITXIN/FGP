//
//  FGPlayStoryModel.m
//  FGProject
//
//  Created by Bert on 16/8/8.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGPlayStoryModel.h"

@implementation FGPlayStoryModel
-(instancetype)initWithDic:(NSDictionary*)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"])
    {
        [self setValue:value forKey:@"ID"];
    }
}
- (void)setValue:(id)value forKey:(NSString *)key
{
    NSString *string = [NSString stringWithFormat:@"%@", value];
    [super setValue:string forKey:key];
}
@end
