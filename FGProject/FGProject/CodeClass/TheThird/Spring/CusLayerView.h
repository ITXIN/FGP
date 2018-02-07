//
//  CusLayerView.h
//  果冻效果
//
//  Created by Sea on 17/3/16.
//  Copyright © 2017年 Sea. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MyCenterViewActionBlock)(MyCenterViewActionType type);
@interface CusLayerView : UIView
@property (nonatomic,copy) MyCenterViewActionBlock myCenterViewActionBlock;


@end
