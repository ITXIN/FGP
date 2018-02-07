//
//  FGAIChatTableViewCell.m
//  FGProject
//
//  Created by Bert on 2016/12/5.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGAIChatTableViewCell.h"
#import "FGFadeStringView.h"
@implementation FGAIChatTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.nameLab.text = @"AI";
        UIImage * backImage;
        backImage = [UIImage imageNamed:@"BubbleOther"];
        backImage = [backImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 16, 7, 5) resizingMode:UIImageResizingModeStretch];
        self.chatBGView.image = backImage;
        self.chatLab.textAlignment = NSTextAlignmentLeft;
//        self.iconView.image = [UIImage imageNamed:@"AI"];
        [self.iconBtn setImage:[UIImage imageNamed:@"AI"] forState:UIControlStateNormal];
        [self setupViews];
          [self.iconBtn addTarget:self action:@selector(iconBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
#pragma mark -
#pragma mark --- Action
- (void)iconBtnClick:(UIButton*)sender
{
    if (self.aiChatCellDelegate && [self.aiChatCellDelegate respondsToSelector:@selector(setupSpeekConfig:)]) {
        [self.aiChatCellDelegate setupSpeekConfig:sender];
    }
}
- (void)setupViews
{
    
    [self.iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.left.top.mas_equalTo(5);
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(145, 20));
        make.top.mas_equalTo(self.iconBtn.mas_top);
        make.left.mas_equalTo(self.iconBtn.mas_right).offset(10);
    }];
    
    [self.chatBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.chatBgViewMaxWidth);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.nameLab.mas_bottom);
        make.left.mas_equalTo(self.iconBtn.mas_right).offset(5);
    }];

    [self.chatLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.chatBGView.mas_left).offset(16);
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
        make.left.mas_equalTo(self.chatBGView.mas_left).offset(16);
        make.centerY.mas_equalTo(self.chatBGView.mas_centerY);
    }];

    
    //会导致以前的 chatBGView 失去控制
//    WriteAnimationLayer *writeAnimationLayer = [[WriteAnimationLayer alloc]init];
//    
//    [writeAnimationLayer.pathLayer removeAllAnimations];
//    for (id layer in self.chatLab.layer.sublayers)
//    {
//        [layer removeAllAnimations];
//    }
//    CGRect writeRect = CGRectMake(17, 13,CGRectGetWidth(rect)+32-17, CGRectGetHeight(rect)+20-13);
//    [writeAnimationLayer writeWordsWithWordsStr:str layerFrame:writeRect layeView:self.chatLab];//绘制文字

   
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
