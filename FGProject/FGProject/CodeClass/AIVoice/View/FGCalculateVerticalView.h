//
//  FGCalculateVerticalView.h
//  FGProject
//
//  Created by Bert on 16/8/10.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  竖式计算
 */
@class FSDAirportFlipLabel;
@interface FGCalculateVerticalView : UIView
@property (nonatomic,strong) FSDAirportFlipLabel *operatorLabel;//运算符号
@property (nonatomic,strong) FSDAirportFlipLabel *firstNumLabel;
@property (nonatomic,strong) FSDAirportFlipLabel *secondNumLabel;
@end
