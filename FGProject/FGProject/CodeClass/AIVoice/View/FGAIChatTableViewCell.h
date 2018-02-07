//
//  FGAIChatTableViewCell.h
//  FGProject
//
//  Created by Bert on 2016/12/5.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGChatBaseTableViewCell.h"
typedef NS_ENUM(NSInteger, FGChatCellUserType) {
    FGChatCellUserTypeMyself,
    FGChatCellUserTypeOther,
};


@protocol FGAIChatTableViewCellDelegate  <NSObject>

- (void)setupSpeekConfig:(UIButton*)sender;

@end
@interface FGAIChatTableViewCell : FGChatBaseTableViewCell

@property (nonatomic,assign) id <FGAIChatTableViewCellDelegate> aiChatCellDelegate;
@property (nonatomic,assign) FGChatCellUserType userType;
@end
