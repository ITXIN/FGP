//
//  AppDelegate.m
//  FGProject
//
//  Created by avazuholding on 2017/11/6.
//  Copyright © 2017年 bert. All rights reserved.
//

#import "AppDelegate.h"

#import "iflyMSC/IFlyMSC.h"
#import "FGRootViewController.h"
#import "FGNavigationController.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];//隐藏状态栏
    
    
    //显示SDK的版本号
    NSLog(@"verson=%@",[IFlySetting getVersion]);
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    //打开输出在console的log开关
    [IFlySetting showLogcat:NO];
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];

    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    
    FGRootViewController *rootVC = [[FGRootViewController alloc]init];
    FGNavigationController *nagC = [[FGNavigationController alloc]initWithRootViewController:rootVC];
    self.window.rootViewController = nagC;
    [[UINavigationBar appearance] setHidden:YES];
    
    //监听网络
    [[FGNetworkingReachable sharedInstance]startMonitoringNetworkReachable];
    
   
    
    [self setupSVProgressHUD];
    
    return YES;
}
- (void)setupSVProgressHUD{
    //    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
    [SVProgressHUD setBackgroundColor:RGB(0, 0, 0)];   // 弹出框颜色
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]]; //弹出框内容颜色
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];//圈圈
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];//大的背景
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
