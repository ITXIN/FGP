//
//  FLNetworkingReachable.m
//  SwiftLive
//
//  Created by Bert on 16/4/28.
//  Copyright © 2016年 DotC_United. All rights reserved.
//

#import "FGNetworkingReachable.h"
#import "AFNetworking.h"
@implementation FGNetworkingReachable

+(FGNetworkingReachable *)sharedInstance{
    static FGNetworkingReachable *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[FGNetworkingReachable alloc] init];
    });
    return _sharedInstance;
}

//进行网络判断
- (void)startMonitoringNetworkReachable{
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    [manger startMonitoring];
    _isReachable = YES;
    //2.监听改变
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
            {
                _isReachable = NO;
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
            {
                _isReachable = NO;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G|4G");
            {
                _isReachable = YES;
                
                AFHTTPSessionManager *managerTest = [AFHTTPSessionManager manager];
                managerTest.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
                managerTest.responseSerializer = [AFHTTPResponseSerializer serializer];
                [managerTest GET:@"http://www.apple.com" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {

                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    _isReachable = YES;
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    _isReachable = NO;
                }];
                
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WiFi");
            {
                _isReachable = YES;
            }
                break;
            default:
                
                break;
        }
    }];
}

@end
