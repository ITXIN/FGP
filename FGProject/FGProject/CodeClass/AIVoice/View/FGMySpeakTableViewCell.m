//
//  FGMySpeakTableViewCell.m
//  FGProject
//
//  Created by Bert on 2016/12/6.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGMySpeakTableViewCell.h"

@implementation FGMySpeakTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.nameLab.text = @"Me";
        UIImage * backImage;
        backImage = [UIImage imageNamed:@"BubbleMyself"];
        backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 5, 7, 16) resizingMode:UIImageResizingModeStretch];
        self.chatBGView.image = backImage;
        self.nameLab.textAlignment = NSTextAlignmentRight;
        self.chatLab.textAlignment = NSTextAlignmentRight;
        
//        self.iconView.image = [UIImage imageNamed:@"sailing"];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
       
        UIImage *image = [UIImage imageWithData:[userDef objectForKey:MY_ICON_KEY]];
        
        [self.iconBtn setImage:(image?image:[UIImage imageNamed:@"sailing"]) forState:UIControlStateNormal];
        [self setupViews];
        
        [self.iconBtn addTarget:self action:@selector(iconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

- (void)setupViews
{
    
    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(5);
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(145, 20));
        make.top.mas_equalTo(self.iconBtn.mas_top);
        make.right.mas_equalTo(self.iconBtn.mas_left).offset(-10);
    }];
    
    [self.chatBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.chatBgViewMaxWidth);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.nameLab.mas_bottom);
        make.right.mas_equalTo(self.iconBtn.mas_left).offset(-5);
    }];
    
    [self.chatLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.chatBGView.mas_right).offset(-16);
        make.centerY.mas_equalTo(self.chatBGView.mas_centerY);
        
    }];
    
    
}
- (void)updateViewWithContens:(NSString *)str
{
    [super updateViewWithContens:str];
    self.chatLab.text = str;
    CGRect rect = [FGProjectHelper stringRect:str fontSize:15 constraintWidth:self.chatBgViewMaxWidth-16 constraintHeight:1000];
    [self.chatBGView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CGRectGetHeight(rect)+20);
        make.width.mas_equalTo(CGRectGetWidth(rect)+32);
    }];
    
    [self.chatLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.chatBGView.mas_height);
        make.width.mas_equalTo(self.chatBgViewMaxWidth-16);
        make.right.mas_equalTo(self.chatBGView.mas_right).offset(-16);
        make.centerY.mas_equalTo(self.chatBGView.mas_centerY);
    }];
    
}

#pragma mark -
#pragma mark --- Action
- (void)iconBtnClick:(UIButton*)sender
{
    if (self.mySpeakDelegate && [self.mySpeakDelegate respondsToSelector:@selector(changeIcon:)]) {
        [self.mySpeakDelegate changeIcon:sender];
    }
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
