//
//  AdjustVolume.h
//  FGProject
//
//  Created by Bert on 16/1/27.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  调节音量
 */

@interface AdjustVolume : NSObject
//{
//    SEL sele;
//}
@property (nonatomic,weak) id delegate;
//- (void)setDelegate:(id)callDelegate sel:(SEL)callSel;
//- (void)setDelegate:(id)callDelegate;//使用这个名字和系统默认的 set一样了
+ (instancetype)shareAdjustVolumeManager;
- (void)setCallDelegate:(id)callDelegate;
@end
