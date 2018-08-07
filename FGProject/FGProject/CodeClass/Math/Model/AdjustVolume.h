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

@property (nonatomic,weak) id delegate;
+ (instancetype)shareAdjustVolumeManager;
- (void)setCallDelegate:(id)callDelegate;
@end
