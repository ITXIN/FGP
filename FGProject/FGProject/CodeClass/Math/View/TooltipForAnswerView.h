//
//  TooltipForAnswerView.h
//  FGProject
//
//  Created by XL on 15/7/3.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  答对10个弹出提示框
 */
typedef void (^ActionIndexBlock)(NSInteger index);
//@protocol TooltipForAnswerViewDelegate <NSObject>
//
//- (void)passTag:(NSInteger)tag;
//
//@end
@interface TooltipForAnswerView : UIView
//大的视图
@property (nonatomic, strong) UIView *bgView;
//图片
@property (nonatomic, strong) UIImageView *imgView;
//继续按钮
@property (nonatomic, strong) UIButton *cotinueBtn;
//取消按钮(返回到上一页)
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, copy) ActionIndexBlock actionIndexBlock;

@end
