//
//  FGMyCenterCell.m
//  FGProject
//
//  Created by avazuholding on 2017/11/15.
//  Copyright © 2017年 bert. All rights reserved.
//

#import "FGMyCenterCell.h"

@implementation FGMyCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self initSubviews];
        [self setupLayoutSubviews];
    }
    return self;
}

- (void)initSubviews{
    self.titleLab = ({
        UILabel *label = [[UILabel alloc]init];
        [self.contentView addSubview:label];
//        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:20];
        
        label;
    });
    
    
}

- (void)setupLayoutSubviews{
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerX.equalTo(self.contentView);
    }];
}

@end
