//
//  FGFadeStringView.h
//  FGProject
//
//  Created by Bert on 2016/11/9.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGFadeStringView : UIView
@property (nonatomic,strong) NSString *textStr;
@property (nonatomic,assign) NSTextAlignment alignment;
@property (nonatomic,strong) UIColor *backColor;
@property (nonatomic,strong) UIColor *foreColor;
@property (nonatomic,strong) UIFont *font;


- (void)fadeRightWithDuration:(NSTimeInterval)duration;
- (void)iPhoneFadeWithDuration:(NSTimeInterval)duration;
@end
