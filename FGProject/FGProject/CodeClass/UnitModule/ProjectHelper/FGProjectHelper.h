//
//  FGProjectHelper.h
//  FGProject
//
//  Created by Bert on 16/8/8.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FGClickRandomAnswerCountModel;
@interface FGProjectHelper : NSObject
/**
 *  保存故事的数据

 */
+ (void)saveDataWithKey:(NSString *)keyStr data:(id)data;
//获取数据
+ (id)getDataWithKey:(NSString *)key;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (CGRect)stringRect:(NSString *)string fontSize:(CGFloat)fontSize constraintWidth:(CGFloat)width constraintHeight:(CGFloat)height;
+(UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;
+ (NSString *)logTimeStringFromDate:(NSDate *)date;
+ (NSDictionary*)postDataWithClickRandomModel:(FGClickRandomAnswerCountModel*)clickModel;
+ (BOOL)getIsiPad;
//晃动动画
+ (CABasicAnimation*)animationRotationZ;
@end
