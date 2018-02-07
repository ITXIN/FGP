//
//  FGGameCollectionViewCell.m
//  FGProject
//
//  Created by Bert on 2017/2/7.
//  Copyright © 2017年 XL. All rights reserved.
//

#import "FGGameCollectionViewCell.h"
#import "FGGameModel.h"
@implementation FGGameCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.gameImage=  ({
            UIImageView *imageView = [[UIImageView alloc]init];
            [self.contentView addSubview:imageView];
            imageView.layer.cornerRadius = 10;
            imageView.layer.masksToBounds = YES;
            imageView;
        });
        
        self.gameNameLab = ({
            UILabel *label = [[UILabel alloc]init];
            [self.gameImage addSubview:label];
            label.text = @"Game";
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont boldSystemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            
            label;
        });
        
        
    }
    return self;
}

- (void)layoutSubviews
{
    [self.gameImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [self.gameNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
        make.centerX.mas_equalTo(self.contentView);
        make.width.mas_equalTo(100);
    }];
    
    [super layoutSubviews];
}


- (void)setGameModel:(FGGameModel*)model
{
    [self.gameImage sd_setImageWithURL:[NSURL URLWithString:model.game_coverurl] placeholderImage:[UIImage imageNamed:@""]];
    self.gameNameLab.text = model.game_name;
    
}

@end
