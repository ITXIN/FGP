//
//  FGChatBaseTableViewCell.h
//  FGProject
//
//  Created by Bert on 2016/12/6.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WriteAnimationLayer.h"
@interface FGChatBaseTableViewCell : UITableViewCell
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *chatLab;
@property (nonatomic,strong) UIImageView *chatBGView;
//@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UIButton *iconBtn;


@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,assign) CGFloat chatBgViewMaxWidth;
@property (nonatomic, strong) UIDynamicAnimator *animator; 
- (void)updateViewWithContens:(NSString *)str;
@end
