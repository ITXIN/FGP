//
//  WriteAnimationLayer.h
//  书写文字
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
//@interface WriteAnimationLayer : CALayer
@interface WriteAnimationLayer : NSObject
//+(void)animationPath:(UIBezierPath*)path inView:(UIView*)view strokeColor:(UIColor*)color lineWidth:(CGFloat)lineWidth layerFrame:(CGRect)layerFrame;
//+(void)animationPath:(UIBezierPath*)path inView:(UIView*)view strokeColor:(UIColor*)color lineWidth:(CGFloat)lineWidth layerFrame:(CGRect)layerFrame wordsLengh:(NSInteger)length;
@property (nonatomic, retain) CAShapeLayer *pathLayer;
- (void)writeWordsWithWordsStr:(NSString *)wordsStr layerFrame:(CGRect)frame layeView:(UIView*)view;
@end
