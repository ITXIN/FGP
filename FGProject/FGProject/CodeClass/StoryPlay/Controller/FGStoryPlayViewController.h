//
//  FGStoryPlayViewController.h
//  FGProject
//
//  Created by Bert on 16/8/8.
//  Copyright © 2016年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGBaseViewController.h"
@class FGStoryModel;
@interface FGStoryPlayViewController : FGBaseViewController
@property (nonatomic,strong) NSMutableArray *playInfoArr;
@property (nonatomic,strong) FGStoryModel *playModel;

@end
