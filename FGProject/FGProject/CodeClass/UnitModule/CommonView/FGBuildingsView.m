//
//  FGBuildingsView.m
//  FGProject
//
//  Created by Bert on 2016/12/29.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGBuildingsView.h"
typedef NS_ENUM(NSUInteger,Direct)
{
    XDir,
    YDir
};



@implementation FGBuildingsView
{
    NSInteger xSegment ;
    NSInteger ySegment ;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.bgView = ({
            UIView *view = [[UIView alloc]init];
            [self addSubview:view];
//            view.backgroundColor = [UIColor yellowColor];
            view;
        });
        self.bgView.frame = self.bounds;
        xSegment = 3;
        ySegment = 5;
        
        [self drawBuildings];
    }
    return self;
}

- (void)drawBuildings
{
    CGFloat leftMar = 20;
    CGFloat topMar = 50;
    CGFloat bottomMar = topMar;
    CGFloat builFirstW = 50;
    CGFloat builFirstH = 100;
    
    CGFloat hypotenuse = sqrt(pow(builFirstW/2,2)/2);//正直角对应的边
    CGPoint downStart = CGPointMake(leftMar, CGRectGetHeight(self.bgView.frame)-bottomMar);
    CGPoint downMid = CGPointMake(downStart.x+builFirstW, downStart.y);
    
    CGPoint downEnd = CGPointMake(downMid.x+hypotenuse, downStart.y-hypotenuse);
    
    
    CGPoint topStart = CGPointMake(leftMar, downStart.y-builFirstH);
//    CGPoint topMidFro = CGPointMake(downMid.x, topStart.y);
    CGPoint topMidBackgr = CGPointMake(topStart.x+hypotenuse, topStart.y-hypotenuse);
//    CGPoint topEnd = CGPointMake(downEnd.x, topStart.y);
    

    CGFloat ySpace = builFirstH/ySegment;
    CGFloat xSpace = builFirstW/xSegment;
    
    //y方向
    NSMutableArray *yStartArr = [NSMutableArray array];
    NSMutableArray *yMidArr = [NSMutableArray array];
    NSMutableArray *yEndArr = [NSMutableArray array];
    NSMutableArray *yUpArr = [NSMutableArray array];
    for (NSInteger i = 0; i < ySegment+1; i ++)
    {
        CGPoint yStart = CGPointMake(downStart.x, downStart.y-i*ySpace);
        CGPoint yMid = CGPointMake(downMid.x, downMid.y - i*ySpace);
        CGPoint yEnd = CGPointMake(downEnd.x, downEnd.y- i*ySpace);
        
        
        [yStartArr addObject:NSStringFromCGPoint(yStart)];
        [yMidArr addObject:NSStringFromCGPoint(yMid)];
        [yEndArr addObject:NSStringFromCGPoint(yEnd)];
        if (i != ySegment)
        {
            CGPoint yUp = CGPointMake(downEnd.x, downEnd.y - (i+1)*ySpace);
            [yUpArr addObject:NSStringFromCGPoint(yUp)];
        }
    }
    [self drawBuildingWithDirection:YDir startArr:yStartArr midArr:yMidArr endArr:yEndArr extroArr:yUpArr];
    
    
    //x 方向 多绘制了一个 topEnd
    NSMutableArray *xStartArr = [NSMutableArray array];
    NSMutableArray *xMidArr = [NSMutableArray array];
    NSMutableArray *xEndArr = [NSMutableArray array];
    NSMutableArray *xRightArr = [NSMutableArray array];
    for (NSInteger i = 0; i < xSegment+1; i ++)
    {
        CGPoint xStart = CGPointMake(downStart.x + i*xSpace, downStart.y);
        CGPoint xMid = CGPointMake(topStart.x + i*xSpace, topStart.y );
        CGPoint xEnd = CGPointMake(topMidBackgr.x + i*xSpace, topMidBackgr.y);
        
        [xStartArr addObject:NSStringFromCGPoint(xStart)];
        [xMidArr addObject:NSStringFromCGPoint(xMid)];
        [xEndArr addObject:NSStringFromCGPoint(xEnd)];
        
        if (i != xSegment)
        {
            CGPoint xRight = CGPointMake(topMidBackgr.x + (i+1)*xSpace,topMidBackgr.y);
            [xRightArr addObject:NSStringFromCGPoint(xRight)];
        }
    }
    [self drawBuildingWithDirection:XDir startArr:xStartArr midArr:xMidArr endArr:xEndArr extroArr:xRightArr];
    
   
}



- (void)drawBuildingWithDirection:(Direct)dir startArr:(NSMutableArray*)starArr midArr:(NSMutableArray *)midArr endArr:(NSMutableArray*)endArr  extroArr:(NSMutableArray*)extroArr
{
    NSInteger segment = ySegment;
    if (dir == XDir)
    {
        segment = xSegment;
    }
    
    CGPoint start ;
    CGPoint mid ;
    CGPoint end ;
    CGPoint extro;
    for (int i = 0; i < segment+1; i ++)
    {
        
        UIBezierPath *circlePath = [UIBezierPath bezierPath];
        circlePath.lineWidth = 2.0;
        circlePath.lineCapStyle = kCGLineCapRound;
        circlePath.lineJoinStyle = kCGLineJoinRound;
        
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        circleLayer.lineCap = kCALineCapRound;
        circleLayer.lineJoin =  kCALineJoinRound;
        // 设置填充颜色
        circleLayer.fillColor = [UIColor clearColor].CGColor;
        // 设置线宽
        circleLayer.lineWidth = 2.0;
        // 设置线的颜色
        circleLayer.strokeColor = [UIColor whiteColor].CGColor;
        circleLayer.strokeEnd = 1;
        circleLayer.strokeStart = 0.0;
        
        start = CGPointFromString(starArr[i]);
        mid = CGPointFromString(midArr[i]);
        end = CGPointFromString(endArr[i]);
        
        //左边横线
        [circlePath moveToPoint:start];
        [circlePath addLineToPoint:mid];
        [circlePath addLineToPoint:end];
        if (i != segment)
        {
            extro = CGPointFromString(extroArr[i]);
            [circlePath addLineToPoint:extro];
        }
        
        circleLayer.path = circlePath.CGPath;
        
        CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnima.duration = 0.5f;
        pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnima.fillMode = kCAFillModeForwards;
        pathAnima.removedOnCompletion = YES;
        pathAnima.repeatCount = 30;
        [circleLayer addAnimation:pathAnima forKey:@"strokeEndAnimation1"];
        
        [self.bgView.layer addSublayer:circleLayer];
    }
}




@end
