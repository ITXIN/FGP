//
//  BubbleButton.h
//  FGProject
//
//  Created by Bert on 2016/12/20.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 水泡效果
 */
//http://code.cocoachina.com/view/126534
@interface BubbleButton : UIButton
- (instancetype)initWithFrame:(CGRect)frame
                    leftWidth:(CGFloat)leftWidth
                   rightWidth:(CGFloat)rightWidth
                 bottomHeight:(CGFloat)bottomHeight;

@property (nonatomic,assign) CGFloat leftWidth;
@property (nonatomic,assign) CGFloat rightWidth;
@property (nonatomic,assign) CGFloat bottomHeight;

@property (nonatomic,assign) CGFloat duration;
@property (nonatomic,strong) NSArray *imagesArr;

@property (nonatomic,strong) UILabel *thumbNumberLab;

- (void)generateBubbleWithImage:(UIImage *)image;
- (void)generateBubbleInRandom;
@end
