//
//  FGHttpsRequestManager.m
//  FGProject
//
//  Created by Bert on 16/8/5.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGHttpsRequestManager.h"
#import "AFNetworking.h"
@implementation FGHttpsRequestManager
// 1
static FGHttpsRequestManager *_sharedInstance = nil;
+(FGHttpsRequestManager*)shareInstance
{
    // 2
    static dispatch_once_t oncePredicate;
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[FGHttpsRequestManager alloc] init];
    });
    return _sharedInstance;
}



- (void)getDataWithUrlStr:(NSString *)urlStr succeedHandler:(succeedHandler)succeedHandler failedHandler:(failedHandler)failedHandler
{
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        NSError *error;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        succeedHandler(responseDic, error);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
         failedHandler(error);
    }];
}
@end
