//
//  FGBaseView.h
//  FGProject
//
//  Created by avazuholding on 2018/3/20.
//  Copyright © 2018年 bert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGBaseView : UIView
@property (nonatomic,strong) UIView *bgView;
- (void)initSubviews;
- (void)setupSubviewsLayout;
@end
