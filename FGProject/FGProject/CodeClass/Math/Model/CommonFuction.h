//
//  CommonFuction.h
//  FGProject
//
//  Created by Bert on 16/2/2.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonFuction : NSObject
+(void)runOnMainThread:(dispatch_block_t)block;
@end
