//
//  FLNetworkingReachable.h
//  SwiftLive
//
//  Created by Bert on 16/4/28.
//  Copyright © 2016年 DotC_United. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGNetworkingReachable : NSObject
@property (nonatomic,assign) BOOL isReachable;

+ (FGNetworkingReachable *)sharedInstance;
- (void)startMonitoringNetworkReachable;
@end
