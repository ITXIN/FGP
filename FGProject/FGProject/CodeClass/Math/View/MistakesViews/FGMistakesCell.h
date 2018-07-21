//
//  FGMistakesCell.h
//  FGProject
//
//  Created by 鑫龙魂 on 2018/7/21.
//  Copyright © 2018年 bert. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FGMistakesOperationView;
@interface FGMistakesCell : UITableViewCell
@property (nonatomic, strong) FGMistakesOperationView *operationView;
- (void)setupQuestMode:(FGMathOperationModel*)questModel;
@end
