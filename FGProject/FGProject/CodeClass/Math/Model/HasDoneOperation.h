//
//  HasDoneOperation.h
//  FGProject
//
//  Created by Bert on 16/1/18.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  对已经做过的题目的获取与更新
 */
@interface HasDoneOperation : NSObject
/**
 *  获取star 个数
 */
+ (NSInteger)starNumberWithDiffcultyLevelMark:(NSString *)leveMark;

/**
 *  设置 star 个数
 */
+ (void)setStarNumberWithDiffcultyLevelMark:(NSString *)leveMark;

/**
 *  清理题目统计
 */
+ (void)clearHadDoneDataWithDifcultyLevelMark:(NSString *)leveMark;

@end
