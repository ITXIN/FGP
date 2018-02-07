//
//  CommonFuction.m
//  FGProject
//
//  Created by Bert on 16/2/2.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "CommonFuction.h"

@implementation CommonFuction
+ (CGRect)stringRect:(NSString *)string fontSize:(CGFloat)fontSize constraintWidth:(CGFloat)width constraintHeight:(CGFloat)height
{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize constraint = CGSizeMake(width, height);
    NSDictionary *attributes = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:constraint
                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                             attributes:attributes
                                context:nil];
}

+(void)runOnMainThread:(dispatch_block_t)block
{
    if ([NSThread isMainThread]) {
        block();
    }else{
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

@end
