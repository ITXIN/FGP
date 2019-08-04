//
//  FGVideoViewController.m
//  FGProject
//
//  Created by avazuholding on 2017/11/20.
//  Copyright © 2017年 bert. All rights reserved.
//

#import "FGVideoViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface FGVideoViewController ()
@property (nonatomic,strong)  MPMoviePlayerViewController *moviePlayerVC;
@end

@implementation FGVideoViewController
- (MPMoviePlayerViewController *)moviePlayerVC
{
    if (!_moviePlayerVC){
        _moviePlayerVC = [[MPMoviePlayerViewController alloc]init];
        _moviePlayerVC.moviePlayer.controlStyle =  MPMovieControlStyleEmbedded ;
        _moviePlayerVC.moviePlayer.scalingMode = MPMovieControlStyleDefault;
    }
    return _moviePlayerVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)initSubviews{
    [super initSubviews];
    NSString *urlStr = @"http://cdnapi.bbwansha.com/bb_video30/Home/video/mp4urlc/app_id/31/app_sub_id/3/vid/349131218/version/3/ts/1511064392/video.mp4?sign=bf24971dadd657663a1de1f8598642c6&t=5A110FD0";
    urlStr = @"http://vod-pro-ww-live.akamaized.net/av_pv3_pa2/modav/bUnknown-72c75248-f4dd-449d-a753-77320b38dc46_p05nkl4v_1511133406793.mp4?__gda__=1511170307_512e06efdb379640406fecff12fc5991";
    [self.moviePlayerVC.moviePlayer setContentURL:[NSURL URLWithString:urlStr]];
    self.moviePlayerVC.moviePlayer.shouldAutoplay = YES;
    [self.view insertSubview:self.moviePlayerVC.view belowSubview:self.navigationView];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //播放完成
    [notificationCenter  addObserver:self selector:@selector(playMoviesFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayerVC];
    //播放状态改变
    [notificationCenter  addObserver:self selector:@selector(stateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    //加载状态改变
    [notificationCenter  addObserver:self selector:@selector(loadStateChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    
}
//- (void)setupLayoutSubviews{
//    [super setupLayoutSubviews];
//    [self.moviePlayerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(100);
//        make.centerY.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, kScreenHeight-2*64));
//    }];
//}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.moviePlayerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.centerY.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/2, kScreenHeight-2*64));
    }];
}
#pragma mark -
- (void)playMoviesFinished:(NSNotification *)notify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayerVC];
    
    [self dismissMoviePlayerViewControllerAnimated];
    [self.moviePlayerVC.view removeFromSuperview];
}
- (void)stateChange:(NSNotification *)notification
{
    MPMoviePlayerController *moviePlayer = notification.object;
    MPMoviePlaybackState playState = moviePlayer.playbackState;
    if (playState == MPMoviePlaybackStateStopped)
    {
        //        NSLog(@"停止");
        
    } else if(playState == MPMoviePlaybackStatePlaying)
    {
        //        NSLog(@"播放");
        //设置 url
    } else if(playState == MPMoviePlaybackStatePaused)
    {
        //        NSLog(@"暂停");
    }
}
- (void)loadStateChange:(NSNotification *)notification
{
    //    MPMoviePlayerController *moviePlayer = notification.object;
    //    MPMovieLoadState playState = moviePlayer.loadState;
}

- (void)movieEventFullscreenHandler:(NSNotification*)notification {
    [self.moviePlayerVC.moviePlayer setFullscreen:NO animated:NO];
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
