//
//  FGImageViewAnimationView.m
//  FGProject
//
//  Created by Bert on 2016/12/30.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGImageViewAnimationView.h"

@implementation FGImageViewAnimationView
{
    NSMutableArray *imageArr;
    NSString *imgesName;
    NSInteger imagesCount;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        imageArr = [NSMutableArray array];
        self.bgView = ({
            UIView *view = [[UIView alloc]init];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            view;
        });
        
        self.imageView =  ({
            UIImageView *imgView = [[UIImageView alloc]init];
            [self.bgView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_bgView);
            }];
            imgView;
        });
        
    }
    return self;
}

- (void)imageViewAnimationWithName:(NSString *)name count:(NSInteger)count{
    imgesName = name;imagesCount = count;
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@0",name]];
    if ([self.imageView isAnimating]){
        return;
    }

    [imageArr removeAllObjects];
    
    for (int i = 0; i < count; i ++){
        [imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%@%d",name,i]]];
    }
    
    [self.imageView setAnimationImages:imageArr];
    [self.imageView setAnimationDuration:imageArr.count *0.35];
    [self.imageView setAnimationRepeatCount:1];
    [self.imageView startAnimating];

    [self.imageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:self.imageView.animationDuration];
}

- (void)startImageAnimation{
    [self imageViewAnimationWithName:imgesName count:imagesCount];
}

@end
