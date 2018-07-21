//
//  FGTomViewController.m
//  FGProject
//
//  Created by Bert on 16/8/9.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGTomViewController.h"

@interface FGTomViewController ()

@end

@implementation FGTomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _imageView.image = [UIImage imageNamed:@"drink_00.jpg"];
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];
    
    _headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_headButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    _headButton.tag = 8;
    [self.view addSubview:_headButton];
    
    _stomachButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_stomachButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    _stomachButton.tag = 9;
    [self.view addSubview:_stomachButton];
    
    _angryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_angryButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    _angryButton.tag = 10;
    [self.view addSubview:_angryButton];
    
    _footRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_footRightButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    _footRightButton.tag = 6;
    [self.view addSubview:_footRightButton];
    
    _footLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _footLeftButton.tag = 7;
    [_footLeftButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_footLeftButton];
    NSLog(@"-----width %f height %f",kScreenWidth,kScreenHeight);
    [UIView animateWithDuration:0.25 animations:^{
//        self.view.transform = CGAffineTransformMakeRotation(-M_PI*0.5);
//        self.view.frame = CGRectMake(0, 0,kScreenWidth,kScreenHeight );
        
        
//        self.view.transform = CGAffineTransformMakeRotation(-M_PI*1.5);
        self.view.transform = CGAffineTransformMakeRotation(-M_PI*0.5);
        self.view.frame = CGRectMake(0, 0,kScreenWidth,kScreenHeight );
        
        _imageView.frame = self.view.bounds;
        
//        if (kScreenWidth > 800)
//        {
            [self.headButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.view);
                make.bottom.mas_equalTo(-kScreenWidth/2);
                make.size.mas_equalTo(CGSizeMake(kScreenHeight/2+15*2, kScreenHeight/2));
            }];
            
            [self.angryButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.view);
                make.top.mas_equalTo(self.headButton.mas_bottom).offset(10);
                make.size.mas_equalTo(CGSizeMake(kScreenHeight/3, kScreenWidth/10));
                
            }];
            
            
            [self.stomachButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self.view);
                make.top.mas_equalTo(self.angryButton.mas_bottom).offset(5);
                make.size.mas_equalTo(CGSizeMake(kScreenHeight/3, kScreenWidth/10*3-15));
                
            }];
            
            [self.footLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.stomachButton.mas_bottom).offset(5);
                make.size.mas_equalTo(CGSizeMake(kScreenHeight/6, kScreenWidth/10-15));
                make.left.mas_equalTo(self.stomachButton.mas_left);
                
            }];
            
            
            [self.footRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.stomachButton.mas_bottom).offset(5);
                make.size.mas_equalTo(CGSizeMake(kScreenHeight/6, kScreenWidth/10-15));
                make.right.mas_equalTo(self.stomachButton.mas_right);
                
            }];
            
//        }else
//        {
//            _headButton.frame = CGRectMake(78, 100, 220,240);
//            _stomachButton.frame = CGRectMake(130, 410, 110,170);
//            _angryButton.frame = CGRectMake(130, 350, 110,55);
//            _footRightButton.frame = CGRectMake(130, 600, 50,50);
//            _footLeftButton.frame = CGRectMake(190, 600, 50,50);
//        }
        
    
        
//        _headButton.backgroundColor = [UIColor redColor];
//        _stomachButton.backgroundColor = [UIColor purpleColor];
//        _angryButton.backgroundColor = [UIColor yellowColor];
//        _footLeftButton.backgroundColor = [UIColor cyanColor];
//        _footRightButton.backgroundColor = [UIColor greenColor];
        
        int x  = 0;
        int y = 0;
        NSArray *arr = [NSArray arrayWithObjects:@"cymbal",@"fart",@"pie",@"scratch",@"eat",@"drink", nil];
        for (UIButton *btn in _imageView.subviews) {
            [btn removeFromSuperview];
        }
        CGSize btnSize = CGSizeMake(80, 80);
        CGFloat space = (kScreenWidth/2 - btnSize.height*3)/4;
        CGFloat leftM = kScreenHeight/6-btnSize.width;
        if (leftM < 20)
        {
            leftM = 15;
        }
        for (int i = 0; i < 6; i ++)
        {
          UIButton*  _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_actionButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",arr[i]]] forState:UIControlStateNormal];
//            _actionButton.frame = CGRectMake( y  + 20, x + 350  , 80, 80);
//            x += 110;
//            if (x >= 320) {
//                x = 0;
//                y += 260;
//            }
            [_imageView addSubview:_actionButton];
            if (i < 3)
            {
                [_actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(btnSize);
                    make.left.mas_equalTo(leftM);
                    make.top.mas_equalTo(kScreenWidth/2+i*(space+btnSize.height)+space);
                }];
            }else
            {
                [_actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(btnSize);
                    make.right.mas_equalTo(-leftM);
                    make.top.mas_equalTo(kScreenWidth/2+(i-3)*(space+btnSize.height)+space);
                }];
            }
            _actionButton.tag =  i;
            [_actionButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        FGNavigationView *navigationView = [[FGNavigationView alloc]initWithDelegate:self];
        [self.view addSubview:navigationView];
        [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.leading.mas_equalTo(self.view);
            make.height.mas_equalTo(44);
        }];
    }];
    
    
    
    
}

- (void)tomAnimation:(NSString *)imageName count:(int )count
{
    if ([self.imageView isAnimating])
    {
        return;
    }
    NSMutableArray *imageArr = [NSMutableArray array];
    
    for (int i = 0; i < count; i ++)
    {
        NSString *str = [NSString stringWithFormat:@"%@_%02d.jpg",imageName,i];
        NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:nil];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [imageArr addObject:image];
    }
    
    [_imageView setAnimationImages:imageArr];
    [_imageView setAnimationDuration:imageArr.count *0.075];
    [_imageView setAnimationRepeatCount:1];
    [_imageView startAnimating];
    
    [self.imageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:self.imageView.animationDuration];
}

- (void)clickAction:(UIButton *)btn
{
    NSLog(@"%ld",btn.tag);
    switch (btn.tag) {
        case cymbal:
            [self tomAnimation:@"cymbal" count:13];//拨
            break;
        case fart:
            [self tomAnimation:@"fart" count:28];
            break;
        case pie:
            [self tomAnimation:@"pie" count:24];
            break;
        case scratch:
            [self tomAnimation:@"scratch" count:56];//爪
            break;
        case eat:
            [self tomAnimation:@"eat" count:40];
            break;
        case drink:
            [self tomAnimation:@"drink" count:81];
            break;
            
        case footRight:
            [self tomAnimation:@"footRight" count:30];
            break;
        case footLeft:
            [self tomAnimation:@"footLeft" count:30];
            break;
        case knockout:
            [self tomAnimation:@"knockout" count:81];
            break;
        case stomach:
            [self tomAnimation:@"stomach" count:34];
            break;
        case angry:
            [self tomAnimation:@"angry" count:26];
            break;
    }
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
