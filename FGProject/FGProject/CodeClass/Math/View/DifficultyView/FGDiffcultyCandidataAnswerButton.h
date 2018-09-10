//
//  FGDiffcultyCandidataAnswerButton.h
//  FGProject
//
//  Created by 鑫龙魂 on 2018/9/9.
//  Copyright © 2018年 bert. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WaterRippleView;
@interface FGDiffcultyCandidataAnswerButton : UIButton
@property (nonatomic, strong) WaterRippleView* myWaterView;
@property (nonatomic, assign) BOOL isEnd;

- (void)waterWaveAnimation;
- (void)stopWaterRipper;
@end
