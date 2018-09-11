//
//  FGNavigationView.h
//  FGProject
//
//  Created by Bert on 2017/2/8.
//  Copyright © 2017年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FGNavigationViewDelegate<NSObject>
@optional
- (void)popToRootViewController;
@end
@interface FGNavigationView : UIView
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UIView *navigationView;
@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,assign) id <FGNavigationViewDelegate> delegate;

-(instancetype)initWithDelegate:(id)delegate;
@end
