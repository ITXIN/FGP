//
//  MediumLevelOperatorView.h
//  FGProject
//
//  Created by Bert on 16/1/18.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  中等难度运算视图
 */
@class MediumOperationModel;

@interface FGMediumLevelOperatorView : UIView
//大的背景视图,方便修改
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) NSTimer *timer;

-(void)setMediumOperationModel:(MediumOperationModel *)questionModel;
@end
