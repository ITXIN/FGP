//
//  FGAlertView.m
//  FGProject
//
//  Created by Bert on 2017/1/16.
//  Copyright © 2017年 XL. All rights reserved.
//

#import "FGAlertView.h"


@implementation FGAlertView
static NSInteger itemCount = 2;

- (instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message delegate:(nullable id )delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle otherButtonTitles:(nullable NSString *)otherButtonTitles, ...{
    self = [super init];
    if (self){

        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        self.fgAlertDelegate = delegate;
        CGFloat itemWidth = 250;
        CGFloat itemHeight = 40;
        self.bgView = ({
            UIView *view = [[UIView alloc]init];
            [self addSubview:view];
            
            view.backgroundColor = [UIColor whiteColor];
            view.layer.cornerRadius = 10;
            view.layer.masksToBounds = YES;
            view;
        });
        itemCount = 2;
        
        self.titleLab = ({
            UILabel *label = [[UILabel alloc]init];
            [self.bgView addSubview:label];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:14];
            label.textAlignment = NSTextAlignmentCenter;
            [label  mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.width.mas_equalTo(itemWidth);
                make.height.mas_equalTo(itemHeight);
                make.leading.trailing.equalTo(self.bgView);
            }];
            
            label.text = title;
            label;
        });

        self.cancelBtn =({
            UIButton* btn =  [UIButton buttonWithType:UIButtonTypeCustom];
            [self.bgView addSubview:btn];
            [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:cancelButtonTitle forState:UIControlStateNormal];
            [btn setTitleColor:RGB(21, 126, 251) forState:UIControlStateNormal];
            btn.tag = 0;
            btn;
        });

    
        NSMutableArray *tittlsArr = [NSMutableArray array];
        va_list arguments;
        id eachObject = otherButtonTitles;
        if (otherButtonTitles) {
            FGLOG(@"otherButtonTitles %@",otherButtonTitles);
            va_start(arguments, otherButtonTitles);
            itemCount ++;
            [tittlsArr addObject:otherButtonTitles];
            while ((eachObject = va_arg(arguments, id))) {
                FGLOG(@"eachObject %@",eachObject);
                itemCount ++;
                [tittlsArr addObject:eachObject];
            }
            va_end(arguments);
        }
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.center);
            make.size.mas_equalTo(CGSizeMake(itemWidth, (tittlsArr.count+2)*itemHeight));
            
        }];
        
        for (NSInteger i = 0; i < tittlsArr.count; i ++){
            __unused  UIButton *itemBtn = ({
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.bgView addSubview:btn];
                [btn setTitleColor:RGB(21, 126, 251) forState:UIControlStateNormal];
                btn.tag = 1 + i;
                [btn  mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(itemHeight*(i+1));
                    make.width.mas_equalTo(itemWidth);
                    make.leading.trailing.equalTo(self.bgView);
                    make.height.mas_equalTo(itemHeight);
                }];
                [btn setTitle:tittlsArr[i] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
                
                btn;
            });
            
           __unused UIView *lineView = ({
                UIView *view = [[UIView alloc]init];
                [itemBtn addSubview:view];
                view.backgroundColor = [UIColor lightGrayColor];
                [view  mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(0);
                    make.width.mas_equalTo(itemWidth);
                    make.leading.trailing.equalTo(self.bgView);
                    make.height.mas_equalTo(1);
                }];
                view;
            });
            
            
        }
        
        
        [self.cancelBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(itemWidth);
            make.height.mas_equalTo(itemHeight);
            make.leading.trailing.equalTo(self.bgView);
        }];
       __unused UIView *lineView = ({
            UIView *view = [[UIView alloc]init];
            [self.cancelBtn addSubview:view];
            view.backgroundColor = [UIColor lightGrayColor];
            [view  mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.width.mas_equalTo(itemWidth);
                make.leading.trailing.equalTo(self.bgView);
                make.height.mas_equalTo(1);
            }];
            view;
        });
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
        
        
        [UIView animateWithDuration: 0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.bgView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration: 0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.bgView.transform = CGAffineTransformMakeScale(1.1, 1.1);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration: 0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.bgView.transform = CGAffineTransformMakeScale(1, 1);
                } completion:nil];
            }];
        }];
        
    }
    return self;
}

#pragma mark -
#pragma mark --- tapAction
- (void)tapAction:(UITapGestureRecognizer*)sender{
    [UIView animateWithDuration: 0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.bgView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark --- clickAction
- (void)clickAction:(UIButton*)sender
{
    [UIView animateWithDuration: 0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.bgView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.fgAlertDelegate && [self.fgAlertDelegate respondsToSelector:@selector(itemBtnAction:)]) {
            [self.fgAlertDelegate itemBtnAction:sender];
        }
        
    }];
    
}

@end
