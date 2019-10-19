//
//  FGWebViewGameViewController.m
//  FGProject
//
//  Created by Bert on 2017/2/7.
//  Copyright © 2017年 XL. All rights reserved.
//

#import "FGWebViewGameViewController.h"
#import <WebKit/WebKit.h>
@interface FGWebViewGameViewController ()<WKUIDelegate,WKScriptMessageHandler,WKNavigationDelegate,UIWebViewDelegate>
@property(nonatomic,strong) WKWebView *webView;

@end

@implementation FGWebViewGameViewController
//-(BOOL)shouldAutorotate
//{
//    return YES;
//}
//
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    //return UIInterfaceOrientationMaskLandscapeRight;
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return YES;
//    return (interfaceOrientation == UIInterfaceOrientationMaskPortrait  );
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc]init];
    configuration.userContentController = [[WKUserContentController alloc]init];
    //        [configuration.userContentController addScriptMessageHandler:self name:@"ScanAction"];
    //调用JS方法
    [configuration.userContentController addScriptMessageHandler:self name:@"DemoInterface"];
    
    WKPreferences *preferences = [[WKPreferences alloc]init];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.minimumFontSize = 40.0;
    configuration.preferences = preferences;
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:configuration];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.gameUrl]];
    [self.webView loadRequest:request];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    [self.view addSubview:self.webView];
    self.webView.scrollView.bounces = NO;
    [self.webView sizeToFit];
    
    FGNavigationView *navigationView = [[FGNavigationView alloc]initWithDelegate:self];
    [self.view addSubview:navigationView];
    
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
}
#pragma mark -
#pragma mark --- WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    FGLOG(@"-----mess %@",message);
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark -
#pragma mark --- WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    FGLOG(@"-----message of body %@",message.body);
    if ([message.name isEqualToString:@"DemoInterface"])
    {
        FGLOG(@"-----接收到了");
    }
    
    //    if ((![[NSUserDefaults standardUserDefaults]boolForKey:USER_SIGNIN_FLAG]))
    //    {
    //        FLThirdPartySignInController  *thirdPartySignInVC = [FLThirdPartySignInController new];
    //        thirdPartySignInVC.enterType = ThirdPartySignEnterTypeMyCenter;
    //        [self.view.window.rootViewController presentViewController:thirdPartySignInVC animated:true completion:nil];
    //        FLLOG(@"person certer no login");
    //    }else
    //    {
    //#warning --- 传活动的 id 值
    //        FLPCDiamondViewController *diamonVC = [[FLPCDiamondViewController alloc]init];
    //        [self.navigationController pushViewController:diamonVC animated:YES];
    //    }
    
    
}






#pragma mark -
#pragma mark --- WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    FGLOG(@"-----页面开始加载时调用 ");
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    FGLOG(@"-----当内容开始返回时调用 ");
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    FGLOG(@"----/ 页面加载完成之后调用");
    
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    FGLOG(@"----页面加载失败时调用");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
