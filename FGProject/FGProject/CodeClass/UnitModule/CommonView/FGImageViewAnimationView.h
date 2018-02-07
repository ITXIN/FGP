//
//  FGImageViewAnimationView.h
//  FGProject
//
//  Created by Bert on 2016/12/30.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FGImageViewAnimationView : UIView
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIView *bgView;
//设置后便开始动画
- (void)imageViewAnimationWithName:(NSString *)name count:(NSInteger)count;

- (void)startImageAnimation;//再次调用开始动画
@end
