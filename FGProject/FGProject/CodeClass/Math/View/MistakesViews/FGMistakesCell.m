//
//  FGMistakesCell.m
//  FGProject
//
//  Created by 鑫龙魂 on 2018/7/21.
//  Copyright © 2018年 bert. All rights reserved.
//

#import "FGMistakesCell.h"
#import "FGSimpleOperationContentView.h"
#import "FGMistakesOperationView.h"
@implementation FGMistakesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.operationView = [[FGMistakesOperationView alloc] init];
        [self.contentView addSubview:self.operationView];
        self.contentView.backgroundColor = UIColor.clearColor;
        self.backgroundColor = UIColor.clearColor;
        self.userInteractionEnabled = NO;
        UIView *answerBgView  = ({
            UIView *view = [[UIView alloc]init];
            [self.contentView addSubview:view];
            view.backgroundColor = UIColor.clearColor;
            view.tag = 1000;
            view;
        });
        [self.operationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(answerBgView.mas_left).offset(-0);
            make.left.mas_equalTo(0);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(self.contentView).multipliedBy(0.5);
            make.top.bottom.equalTo(self.contentView);
        }];
        [answerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.operationView.mas_right).offset(0);
            make.height.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView);
            make.right.mas_equalTo(-0);
        }];
        NSMutableArray *btnArr = [NSMutableArray array];
        for (NSInteger i = 0; i < 4; i ++) {
            UIButton *tempBtn = ({
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [answerBgView addSubview:btn];
                btn.tag = 2000+i;
                [btn setTitle:[NSString stringWithFormat:@"%d",arc4random()%100] forState:UIControlStateNormal];
                btn;
            });
            tempBtn.titleLabel.font = [UIFont boldSystemFontOfSize:35.0];
//            tempBtn.backgroundColor = UIColor.redColor;
            [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(answerBgView);
                make.centerY.equalTo(answerBgView);
            }];
            
            [btnArr addObject:tempBtn];
            
        }
//        answerBgView.backgroundColor = UIColor.yellowColor;
        
//        self.operationView.backgroundColor = UIColor.purpleColor;
//        self.contentView.backgroundColor = UIColor.cyanColor;
        [btnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:2.5 leadSpacing:0 tailSpacing:0];
        
    }
    return self;
}

- (void)setupQuestMode:(FGMathOperationModel*)questModel{
    [self.operationView setQuestionModel:questModel];
}

@end
