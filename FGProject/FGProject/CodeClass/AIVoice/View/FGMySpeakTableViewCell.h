//
//  FGMySpeakTableViewCell.h
//  FGProject
//
//  Created by Bert on 2016/12/6.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGChatBaseTableViewCell.h"

@protocol FGMySpeakTableViewCellDelegate  <NSObject>

- (void)changeIcon:(UIButton*)sender;

@end

@interface FGMySpeakTableViewCell : FGChatBaseTableViewCell
@property (nonatomic,weak) id <FGMySpeakTableViewCellDelegate> mySpeakDelegate;

@end
