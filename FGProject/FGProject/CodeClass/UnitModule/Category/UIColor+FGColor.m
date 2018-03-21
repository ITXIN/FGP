//
//  UIColor+FGColor.m
//  FGProject
//
//  Created by avazuholding on 2018/3/21.
//  Copyright © 2018年 bert. All rights reserved.
//

#import "UIColor+FGColor.h"

@implementation UIColor (FGColor)
//#define PNLightGreen    [UIColor colorWithRed:77.0 / 255.0 green:216.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f]
//#define PNFreshGreen    [UIColor colorWithRed:77.0 / 255.0 green:196.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f]
//#define PNDeepGreen     [UIColor colorWithRed:77.0 / 255.0 green:176.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f]
+(UIColor*)fgPieChartLightGreenColor{
    return RGB(77, 216, 122);
}
+(UIColor*)fgPieChartFreshGreenColor{
    return RGB(77, 196, 122);
}
+(UIColor*)fgPieChartDeepGreenColor{
    return RGB(77, 176, 122);
}
@end
