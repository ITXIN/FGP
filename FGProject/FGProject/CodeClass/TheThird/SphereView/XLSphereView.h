//
//  XLSphereView.h
//  XLSphereView
//
//  Created by 袁小龙 on 16/4/4.
//  Copyright © 2016年 xiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XLSphereViewDelegate<NSObject>
@required
- (void)storyBtnClick:(UIButton*)sender;

@end


@interface XLSphereView : UIView
@property (nonatomic,strong) UIColor *itemTitleColor;
@property(nonatomic,assign) BOOL isTimerStart;

@property (nonatomic,assign) id <XLSphereViewDelegate> sphereDelegate;
- (void)setItems:(NSArray *)items;

- (void)timerStart;

- (void)timerStop;

//- (void)setupViewWithModelArr:(NSArray*)modelArr;
//- (void)setupViewWithCount:(NSInteger)count titleArr:(NSArray*)titleArr;
- (void)setupViewWithDataArr:(NSArray*)dataArr;
@end
