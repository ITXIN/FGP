//
//  FGBaseView.m
//  FGProject
//
//  Created by avazuholding on 2018/3/20.
//  Copyright © 2018年 bert. All rights reserved.
//

#import "FGBaseView.h"

@implementation FGBaseView
//不要在实现init了，initWithFrame会调用super init
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self initSubviews];
        [self setupSubviewsLayout];
    }
    return self;
}

- (void)initSubviews{
    
}

- (void)setupSubviewsLayout{

}

@end
