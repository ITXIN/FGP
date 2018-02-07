//
//  WriteFunction.h
//  书写文字
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 cheniue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface WriteFunction : NSObject
+(UIBezierPath*)pathForText:(NSString*)text lineSpace:(CGFloat)lineSpace textFont:(UIFont*)textFont drawWidth:(CGFloat)drawWidth forLayerDraw:(BOOL)forLayerDraw;
@end
