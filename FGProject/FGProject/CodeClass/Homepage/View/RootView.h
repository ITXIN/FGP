//
//  RootView.h
//  FGProject
//
//  Created by XL on 15/7/8.
//  Copyright (c) 2015年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol RootViewDelegate <NSObject>
//@optional
//- (void)startBtnAction;
//@end
@interface RootView : UIView

//@property (nonatomic,weak) id <RootViewDelegate> delegate;
//太阳图片
@property (nonatomic, strong) UIImageView *sunImgView;
@property (nonatomic, strong) UIImageView *redImageView;
@property (nonatomic, strong) UIImageView *yellowImageView;
@property (nonatomic, strong) UIButton *startBtn;
@end
