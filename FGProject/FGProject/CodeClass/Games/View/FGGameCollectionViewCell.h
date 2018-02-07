//
//  FGGameCollectionViewCell.h
//  FGProject
//
//  Created by Bert on 2017/2/7.
//  Copyright © 2017年 XL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FGGameModel;
@interface FGGameCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView *gameImage;
@property (nonatomic,strong) UILabel *gameNameLab;
- (void)setGameModel:(FGGameModel*)model;
@end
