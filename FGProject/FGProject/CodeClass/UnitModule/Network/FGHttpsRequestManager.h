//
//  FGHttpsRequestManager.h
//  FGProject
//
//  Created by Bert on 16/8/5.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^succeedHandler)(id responseObject, NSError *error);
typedef void(^failedHandler)(NSError *error);

@interface FGHttpsRequestManager : NSObject
+(FGHttpsRequestManager*)shareInstance;
- (void)getDataWithUrlStr:(NSString *)urlStr succeedHandler:(succeedHandler)succeedHandler failedHandler:(failedHandler)failedHandler;
@end
