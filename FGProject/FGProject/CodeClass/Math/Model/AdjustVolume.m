//
//  AdjustVolume.m
//  FGProject
//
//  Created by Bert on 16/1/27.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "AdjustVolume.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MusicPlayerManager.h"
@implementation AdjustVolume
{
    UIViewController *control;
    MPVolumeView *volumeView;
    MusicPlayerManager *playerManager;
}
//- (void)setDelegate:(id)callDelegate sel:(SEL)callSel
//{
//    if (callDelegate)
//    {
//        playerManager = [MusicPlayerManager shareMusicPlayerManager];
//        self.delegate = callDelegate;
//        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(setupVolume:)];
//        control = (UIViewController *)self.delegate;
//        [control.view addGestureRecognizer:panGR];
//        volumeView = [[MPVolumeView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
//        volumeView.center = control.view.center;
//        [volumeView setShowsVolumeSlider:NO];
//        [volumeView setShowsRouteButton:NO];
//        [volumeView sizeToFit];
//        volumeView.backgroundColor = [UIColor redColor];
//        [control.view insertSubview:volumeView aboveSubview:control.view.superview];
//    }
//}

+ (instancetype)shareAdjustVolumeManager
{
    static AdjustVolume *adjustVolume = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        adjustVolume = [[self alloc]init];
    });
    return adjustVolume;
}

- (void)setCallDelegate:(id)callDelegate
{
    if (callDelegate)
    {
        playerManager = [MusicPlayerManager shareMusicPlayerManager];
        self.delegate = callDelegate;
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(setupVolume:)];
        control = (UIViewController *)self.delegate;
        [control.view addGestureRecognizer:panGR];
        volumeView = [[MPVolumeView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        volumeView.center = control.view.center;
        [volumeView setShowsVolumeSlider:NO];
        [volumeView setShowsRouteButton:NO];
        [volumeView sizeToFit];
        volumeView.backgroundColor = [UIColor redColor];
        [control.view insertSubview:volumeView aboveSubview:control.view.superview];
    }
}
- (void)setupVolume:(UIPanGestureRecognizer *)sender
{
    CGPoint location = [sender locationInView:control.view];
    static CGPoint begin ;
    static CGPoint end ;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        begin = location;
    }else if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateChanged)
    {
        end = location;
        //设置音量大小滑动范围为100
        CGFloat pace = 150.0;
        float distance = fabsl(begin.y - end.y);
//        NSLog(@"-----distace %f",fabs(begin.x - end.x));
        if (fabs(begin.x - end.x) < 10.0 && distance > 10.0)//允许斜着拖拽x范围是10
        {
            
            float volume = 0.0;
//            NSLog(@"-----location begin %f end %f distance %f",begin.y,end.y,distance);
            if (distance < pace)
            {
                volume = distance/pace;
                if (volume <= 0.1)
                {
                    volume = 0.1;
                }
            }else
            {
                volume = 0.8;
            }
//            NSLog(@"-----volue %f",volume);
            [playerManager setVolumeWithVolume:volume];
            
            UISlider* volumeViewSlider = nil;
            for (UIView *view in [volumeView subviews]){
                if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                    volumeViewSlider = (UISlider*)view;
                    break;
                }
            }
            [volumeViewSlider setValue:volume animated:NO];
            // send UI control event to make the change effect right now.
            [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
        }else
        {
//            NSLog(@"-----dont change volume");
            return;
        }
    }
}
@end
