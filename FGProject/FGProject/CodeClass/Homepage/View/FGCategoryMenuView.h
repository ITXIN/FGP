//
//  FGCategoryMenuView.h
//  FGProject
//
//  Created by Bert on 2016/12/22.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FGCategoryMenuViewDelegate <NSObject>

- (void)categoryAction:(UIButton*)sender;

@end
@interface FGCategoryMenuView : UIView
@property (nonatomic,strong) UIButton *actionBtn;

@property (nonatomic,strong) UIButton *gameBtn;
@property (nonatomic,strong) UIButton *mathBtn;
@property (nonatomic,strong) UIButton *aiBtn;
@property (nonatomic,strong) UIButton *storysBtn;

@property (nonatomic,strong) NSMutableArray *btnsArr;


@property (nonatomic,strong) CAShapeLayer *gameLayer;
@property (nonatomic,strong) CAShapeLayer *mathLayer;
@property (nonatomic,strong) CAShapeLayer *aiLayer;
@property (nonatomic,strong) CAShapeLayer *storyLayer;


@property (nonatomic,strong) UIBezierPath *gamePath;
@property (nonatomic,strong) UIBezierPath *mathPath;
@property (nonatomic,strong) UIBezierPath *aiPath;
@property (nonatomic,strong) UIBezierPath *storyPath;

@property (nonatomic,assign) id <FGCategoryMenuViewDelegate> categoryDelegate;


@end
