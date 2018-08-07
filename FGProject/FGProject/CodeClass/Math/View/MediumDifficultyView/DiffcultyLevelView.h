//
//  DiffcultyLevelView.h
//  FGProject
//
//  Created by Bert on 16/1/8.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  综合的菜单项
 */
@protocol DiffcultyLevelViewDelegate <NSObject>

- (void)diffcultyBtnAction:(MathOperationActionType)operationActionType;

@end
@interface DiffcultyLevelView : UIView
{
    CGPoint velocity;
    CGFloat mass;
    CADisplayLink * displayLink;
}

@property (nonatomic,strong) NSMutableArray *menuBtnArr;
@property (nonatomic,assign) CGPoint centerPoint;
@property (nonatomic,strong) NSMutableArray *menuBtnCenterArr;
@property (nonatomic,strong) UIPanGestureRecognizer * panGestureRecognizer;
@property (nonatomic, assign) CGFloat panDragCoefficient;
@property (nonatomic, assign) CGPoint restCenter;
@property (nonatomic, assign) UIEdgeInsets panDistanceLimits;
@property (nonatomic, readonly) BOOL panning;
@property (nonatomic, assign) BOOL springEnabled;
@property (nonatomic, assign) CGFloat springConstant;
@property (nonatomic, assign) CGFloat dampingCoefficient;

@property (nonatomic,weak) id <DiffcultyLevelViewDelegate> delegate;
@end
