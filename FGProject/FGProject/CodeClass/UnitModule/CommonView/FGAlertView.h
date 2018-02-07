//
//  FGAlertView.h
//  FGProject
//
//  Created by Bert on 2017/1/16.
//  Copyright © 2017年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FGAlertViewDelegate <NSObject>
- (void)itemBtnAction:(UIButton*)sender;
@end
@interface FGAlertView : UIView
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UILabel *confirmLab;
@property (nonatomic,strong) NSArray *otherTitles;
@property (nonatomic,strong) UIView *bgView;

@property (nonatomic,assign) id <FGAlertViewDelegate> fgAlertDelegate;
- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id )delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ...;
@end
