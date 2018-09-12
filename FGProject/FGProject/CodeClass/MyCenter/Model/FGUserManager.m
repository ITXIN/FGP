//
//  FGUserManager.m
//  FGProject
//
//  Created by avazuholding on 2017/11/17.
//  Copyright © 2017年 bert. All rights reserved.
//

#import "FGUserManager.h"
#import <objc/message.h>
#import "objc/Runtime.h"
@implementation FGUserManager

static NSString *userInfoKey = @"userInfoKey";

static FGUserManager *defaultUser = nil;
+ (FGUserManager*)standard{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultUser = [[FGUserManager alloc]init];
        NSDictionary *userInfoDic = [FGProjectHelper getDataWithKey:userInfoKey];
 
        
        if (userInfoDic && userInfoDic.allValues.count>0) {
            [defaultUser setValuesForKeysWithDictionary:userInfoDic];
        }else{
            NSString *uidStr = [FLDeviceUID uid];
            userInfoDic = @{@"name":@"聪明宝贝",@"ID":[NSString stringWithFormat:@"%@",uidStr],@"isPlaySound":@"Y"};
             [defaultUser setValuesForKeysWithDictionary:userInfoDic];
        }
    });
    return defaultUser;
}


- (void)saveUserDataWithDic:(NSDictionary*)infoDic{
    [FGProjectHelper saveDataWithKey:userInfoKey data:infoDic];
    [defaultUser setValuesForKeysWithDictionary:infoDic];
}

- (void)clearUserData{
    FGLOG(@"清除以前的数据");
    [FGProjectHelper saveDataWithKey:userInfoKey data:[NSDictionary dictionary]];
    
    //(1)获取类的属性及属性对应的类型
    NSMutableArray * keys = [NSMutableArray array];
    NSMutableArray * attributes = [NSMutableArray array];
    unsigned int outCount;
    objc_property_t * properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i ++) {
        objc_property_t property = properties[i];
        //通过property_getName函数获得属性的名字
        NSString * propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [keys addObject:propertyName];
        //通过property_getAttributes函数可以获得属性的名字和@encode编码
        NSString * propertyAttribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
        [attributes addObject:propertyAttribute];
    }
    //立即释放properties指向的内存
    free(properties);
    
    //(2)根据类型给属性赋值
    for (NSString * key in keys) {
        [self setValue:@"" forKey:key];
    }
    
}

#pragma mark -
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)setValue:(id)value forKey:(NSString *)key{
    NSString *string = [NSString stringWithFormat:@"%@", value];
    [super setValue:string forKey:key];
}



@end
