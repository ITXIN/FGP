//
//  FGProjectHelper.m
//  FGProject
//
//  Created by Bert on 16/8/8.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGProjectHelper.h"
#import <Accelerate/Accelerate.h>
#import <AdSupport/AdSupport.h>
#import "FGClickRandomAnswerCountModel.h"
@implementation FGProjectHelper

+ (void)saveDataWithKey:(NSString *)keyStr data:(id)data{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:keyStr];
    [defaults synchronize];
}

//获取数据
+ (id)getDataWithKey:(NSString *)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:key]];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (CGRect)stringRect:(NSString *)string fontSize:(CGFloat)fontSize constraintWidth:(CGFloat)width constraintHeight:(CGFloat)height {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize constraint = CGSizeMake(width, height);
    NSDictionary *attributes = @{NSFontAttributeName:font};
    return [string boundingRectWithSize:constraint
                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                             attributes:attributes
                                context:nil];
}

//毛玻璃
+(UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    if(pixelBuffer == NULL)
    NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}

+ (NSString *)logTimeStringFromDate:(NSDate *)date{
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd-HH:mm:ss";
    });
    
    return [formatter stringFromDate:date];
}

+(NSString*)adidWith{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier]UUIDString];
}

#pragma mark -
#pragma mark --- 对上传的简单的运算 Math 赋值
/*
+ (NSDictionary*)postDataWithClickRandomModel:(FGClickRandomAnswerCountModel*)clickModel
{
    NSString *firstOperStr = @"";
    NSString *secondOperStr = @"";
    NSString *operStr = @"";
    NSString *anserStr = @"";
    NSDictionary *wrongDic = nil;
    if (clickModel.questionModel)
    {
//        firstOperStr = [clickModel.questionModel.operatorStr isEqualToString:@"Add"] ? @"+":@"-";
        firstOperStr = (clickModel.questionModel.mathOperationActionType == MathOperationActionTypeAdd)? @"+":@"-";
        operStr = [NSString stringWithFormat:@"%ld %@ %ld = ?",clickModel.questionModel.firstNum,firstOperStr,clickModel.questionModel.secondNum];
        anserStr = [NSString stringWithFormat:@"%ld",clickModel.questionModel.answerNum];
        wrongDic = @{
                     @"first": @{
                             @"wrongAnswer":[NSString stringWithFormat:@"%ld",clickModel.randomAnswerModel.firstNum],
                             @"clickCount":[NSString stringWithFormat:@"%ld",clickModel.firstNum]
                             },
                     @"second": @{
                             @"wrongAnswer":[NSString stringWithFormat:@"%ld",clickModel.randomAnswerModel.secondNum],
                             @"clickCount":[NSString stringWithFormat:@"%ld",clickModel.secondNum]
                             },
                     @"third": @{
                             @"wrongAnswer":[NSString stringWithFormat:@"%ld",clickModel.randomAnswerModel.thirdNum],
                             @"clickCount":[NSString stringWithFormat:@"%ld",clickModel.thirdNum]
                             },
                     };
    }
    
    if(clickModel.questionMediumModel)
    {
//        firstOperStr = [clickModel.questionMediumModel.firstOperStr isEqualToString:@"Add"] ? @"+":@"-";
//        secondOperStr = [clickModel.questionMediumModel.secondOperStr isEqualToString:@"Add"] ? @"+":@"-";
        firstOperStr = (clickModel.questionMediumModel.firstOperationType == MathOperationActionTypeAdd) ? @"+":@"-";
              secondOperStr = (clickModel.questionMediumModel.secondOperationType == MathOperationActionTypeAdd) ? @"+":@"-";
        operStr = [NSString stringWithFormat:@"%ld %@ %ld %@ %ld = ?",clickModel.questionMediumModel.firstNum,firstOperStr,clickModel.questionMediumModel.secondNum,secondOperStr,clickModel.questionMediumModel.thirdNum];
        anserStr = [NSString stringWithFormat:@"%ld",clickModel.questionMediumModel.answerNum];
        
        wrongDic = @{
                     @"first": @{
                             @"wrongAnswer":[NSString stringWithFormat:@"%ld",clickModel.randomMediumModel.firstNum],
                             @"clickCount":[NSString stringWithFormat:@"%ld",clickModel.firstNum]
                             },
                     @"second": @{
                             @"wrongAnswer":[NSString stringWithFormat:@"%ld",clickModel.randomMediumModel.secondNum],
                             @"clickCount":[NSString stringWithFormat:@"%ld",clickModel.secondNum]
                             },
                     @"third": @{
                             @"wrongAnswer":[NSString stringWithFormat:@"%ld",clickModel.randomMediumModel.thirdNum],
                             @"clickCount":[NSString stringWithFormat:@"%ld",clickModel.thirdNum]
                             },
                     };

    }
  
    
    NSDictionary *dic = @{
                          @"answer":anserStr,
                          @"operationStr":operStr,
                          @"wrongAnswerClick":wrongDic
                          };
    
    return dic;
}
*/
//如果想要判断设备是ipad，要用如下方法
+ (BOOL)getIsiPad{
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPhone"]) {
        //iPhone
        return NO;
    }
    else if([deviceType isEqualToString:@"iPod touch"]) {
        //iPod Touch
        return NO;
    }
    else if([deviceType isEqualToString:@"iPad"]) {
        //iPad
        return YES;
    }
    return NO;
}

//晃动动画
+ (CABasicAnimation*)animationRotationZ{
    CABasicAnimation *basicAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnim.toValue = [NSNumber numberWithFloat:M_PI_2/7];
    basicAnim.duration = 2.0;
    basicAnim.autoreverses = YES;
    basicAnim.repeatCount = HUGE_VAL;
    basicAnim.removedOnCompletion = NO;
    return basicAnim;
}

@end
