//
//  StartView.h
//  FGProject
//
//  Created by XL on 15/7/5.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  奖励的视图
 */
@interface FGRewardsView : UIView
//图片
@property (nonatomic, strong) UIImageView *startImgView;

//@property (nonatomic, strong) UIButton *startImgBtn;

//个数
@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic,strong) UIView *bgView;

/**
 *  属于容易题目视图
 */
- (instancetype)initWithFrame:(CGRect)frame startNum:(NSInteger)num todayDoneNum:(NSInteger )todayNum;
/**
 *    属于中等难度题目视图
 */
//- (instancetype)initWithFrame:(CGRect)frame;
- (void)setMediumStarNumber:(NSInteger)starNumber;
@end
