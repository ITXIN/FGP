//
//  CARadarView.h
//  FGProject
//
//  Created by Bert on 2016/11/21.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CARadarView : UIView
//fill color
@property (nonatomic, strong) UIColor *fillColor;

//instance count
@property (nonatomic, assign) NSInteger instanceCount;

//instance delay
@property (nonatomic, assign) CFTimeInterval instanceDelay;

//opacity
@property (nonatomic, assign) CGFloat opacityValue;

//animation duration
@property (nonatomic, assign) CFTimeInterval animationDuration;
- (void)startAnimation;
- (void)stopAnimation;

@end
