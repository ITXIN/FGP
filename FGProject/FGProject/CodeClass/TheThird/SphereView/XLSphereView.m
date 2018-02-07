//
//  XLSphereView.m
//  XLSphereView
//
//  Created by 袁小龙 on 16/4/4.
//  Copyright © 2016年 xiaolong. All rights reserved.
//

#import "XLSphereView.h"
#import "XLMatrix.h"
#import "FGStoryModel.h"
#import "FGPlayStoryModel.h"
@interface XLSphereView()<UIGestureRecognizerDelegate>
{
    NSMutableArray *tags;
    NSMutableArray *coordinate;
    XLPoint normalDirection;
    CGPoint last;
    
    CGFloat velocity;
    
    CADisplayLink *timer;
    CADisplayLink *inertia;
    
}


@end

@implementation XLSphereView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemTitleColor = [UIColor blackColor];
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

#pragma mark - initial set
/**
 *  设置按钮
 *
 *  @param modelArr
 */
- (void)setupViewWithDataArr:(NSArray*)dataArr
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < dataArr.count; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
      
//        btn.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
        [btn setTitleColor:self.itemTitleColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        btn.titleLabel.numberOfLines = 2;
        btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.frame = CGRectMake(0, 0, 100, 100);
        btn.layer.cornerRadius = 50;
        btn.clipsToBounds = YES;
        [btn addTarget:self action:@selector(storyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *titleStr;
        NSString *imageStr;
        if ([dataArr[i] isKindOfClass:[FGStoryModel class]])
        {
            FGStoryModel *model = dataArr[i];
            titleStr = model.title;
            imageStr = model.image_url;
        }else
        {
            FGPlayStoryModel *model = dataArr[i];
            titleStr = model.story_name;
            imageStr = model.img_url;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [btn.imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [btn setBackgroundImage:image forState:UIControlStateNormal];
                
            }];
            [btn setTitle:[NSString stringWithFormat:@"%@", titleStr] forState:UIControlStateNormal];
        });
        [array addObject:btn];
        [self addSubview:btn];
    }
    [self setItems:array];
}

- (void)storyBtnClick:(UIButton*)sender
{
    if (self.sphereDelegate && [self.sphereDelegate respondsToSelector:@selector(storyBtnClick:)])
    {
        [self.sphereDelegate storyBtnClick:sender];
    }
}

- (void)setItems:(NSArray *)items
{
    tags = [NSMutableArray arrayWithArray:items];
    coordinate = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < tags.count; i ++) {
        UIView *view = [tags objectAtIndex:i];
        view.center = CGPointMake(self.frame.size.width / 2., self.frame.size.height / 2.);
    }
    
    CGFloat p1 = M_PI * (3 - sqrt(5));
    CGFloat p2 = 2. / tags.count;
    
    for (NSInteger i = 0; i < tags.count; i ++) {
        
        CGFloat y = i * p2 - 1 + (p2 / 2);
        CGFloat r = sqrt(1 - y * y);
        CGFloat p3 = i * p1;
        CGFloat x = cos(p3) * r;
        CGFloat z = sin(p3) * r;
        
        
        XLPoint point = XLPointMake(x, y, z);
        NSValue *value = [NSValue value:&point withObjCType:@encode(XLPoint)];
        [coordinate addObject:value];
        
        CGFloat time = (arc4random() % 10 + 10.) / 20.;
        [UIView animateWithDuration:time delay:0. options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self setTagOfPoint:point andIndex:i];
        } completion:^(BOOL finished) {
            
        }];
        
    }
    
    NSInteger a =  arc4random() % 10 - 5;
    NSInteger b =  arc4random() % 10 - 5;
    normalDirection = XLPointMake(a, b, 0);
    [self timerStart];
}

#pragma mark - set frame of point

- (void)updateFrameOfPoint:(NSInteger)index direction:(XLPoint)direction andAngle:(CGFloat)angle
{
    
    NSValue *value = [coordinate objectAtIndex:index];
    XLPoint point;
    [value getValue:&point];
    
    XLPoint rPoint = XLPointMakeRotation(point, direction, angle);
    value = [NSValue value:&rPoint withObjCType:@encode(XLPoint)];
    coordinate[index] = value;
    
    [self setTagOfPoint:rPoint andIndex:index];
    
}

- (void)setTagOfPoint: (XLPoint)point andIndex:(NSInteger)index
{
    UIView *view = [tags objectAtIndex:index];
    view.center = CGPointMake((point.x + 1) * (self.frame.size.width / 2.), (point.y + 1) * self.frame.size.width / 2.);
    
    CGFloat transform = (point.z + 2) / 3;
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, transform, transform);
    view.layer.zPosition = transform;
    view.alpha = transform;
    if (point.z < 0) {
        view.userInteractionEnabled = NO;
    }else {
        view.userInteractionEnabled = YES;
    }
}

#pragma mark - autoTurnRotation

- (void)timerStart
{
    timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(autoTurnRotation)];
    [timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)timerStop
{
    [timer invalidate];
    timer = nil;
    
}

- (void)autoTurnRotation
{
    for (NSInteger i = 0; i < tags.count; i ++) {
        [self updateFrameOfPoint:i direction:normalDirection andAngle:0.002];
    }
    
}

#pragma mark - inertia

- (void)inertiaStart
{
    [self timerStop];
    inertia = [CADisplayLink displayLinkWithTarget:self selector:@selector(inertiaStep)];
    [inertia addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)inertiaStop
{
    [inertia invalidate];
    inertia = nil;
    [self timerStart];
}

- (void)inertiaStep
{
    if (velocity <= 0) {
        [self inertiaStop];
    }else {
        velocity -= 70.;
        CGFloat angle = velocity / self.frame.size.width * 2. * inertia.duration;
        for (NSInteger i = 0; i < tags.count; i ++) {
            [self updateFrameOfPoint:i direction:normalDirection andAngle:angle];
        }
    }
    
}

#pragma mark - gesture selector

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        last = [gesture locationInView:self];
        [self timerStop];
        [self inertiaStop];
        
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint current = [gesture locationInView:self];
        XLPoint direction = XLPointMake(last.y - current.y, current.x - last.x, 0);
        
        CGFloat distance = sqrt(direction.x * direction.x + direction.y * direction.y);
        
        CGFloat angle = distance / (self.frame.size.width / 2.);
        
        for (NSInteger i = 0; i < tags.count; i ++) {
            [self updateFrameOfPoint:i direction:direction andAngle:angle];
        }
        normalDirection = direction;
        last = current;
    }else if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint velocityP = [gesture velocityInView:self];
        velocity = sqrt(velocityP.x * velocityP.x + velocityP.y * velocityP.y);
        [self inertiaStart];
        
    }
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
