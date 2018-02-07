//
//  FGChatBaseTableViewCell.m
//  FGProject
//
//  Created by Bert on 2016/12/6.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGChatBaseTableViewCell.h"

@implementation FGChatBaseTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        self.backgroundColor = [UIColor clearColor];
        self.chatBgViewMaxWidth = CHART_WORDS_WIDTH;
        self.bgView = ({
            UIView *view = [UIView new];
            [self.contentView addSubview:view];
            view.backgroundColor = [UIColor clearColor];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
            view;
        });
        
//        self.iconView =  ({
//            UIImageView *imgView = [[UIImageView alloc]init];//
//            [_bgView addSubview:imgView];
//            imgView.contentMode = UIViewContentModeScaleAspectFill;
//            imgView.backgroundColor = RGBA(0, 0, 0, 0.3);
//            imgView.layer.cornerRadius = 45/2;
//            imgView.layer.masksToBounds = YES;
//            imgView;
//            
//        });
        
        
        self.iconBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_bgView addSubview:btn];
            btn.backgroundColor = RGBA(0, 0, 0, 0.3);
            btn.layer.cornerRadius = 45/2;
            btn.layer.masksToBounds = YES;
            btn;
        });
        
        self.nameLab = ({
            UILabel *label = [[UILabel alloc]init];
            [_bgView addSubview:label];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:13];
            label;
        });
        
        
        self.chatBGView =  ({
            UIImageView *imgView = [[UIImageView alloc]init];//
            [_bgView addSubview:imgView];

            imgView;
            
        });
        
       
        
        
        self.chatLab = ({
            UILabel *label = [[UILabel alloc]init];
            [_bgView addSubview:label];
            label.textAlignment = NSTextAlignmentLeft;
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.font = [UIFont systemFontOfSize:15];
            label.textColor = RGB(236, 0, 61);
            
            label;
        });
        

//        self.chatBGView.backgroundColor = [UIColor blueColor];
//        self.iconView.backgroundColor = [UIColor yellowColor];
//        self.nameLab.backgroundColor = [UIColor purpleColor];
//        self.bgView.backgroundColor = [UIColor greenColor];
        
    }
    return self;
}

- (void)updateViewWithContens:(NSString *)str
{
    
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
