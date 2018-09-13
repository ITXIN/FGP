//
//  FGCategoryMenuView.m
//  FGProject
//
//  Created by Bert on 2016/12/22.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "FGCategoryMenuView.h"
#import "CARadarView.h"
@implementation FGCategoryMenuView
{
    CGFloat categoryBtnW;
    CGFloat actionBtnW;
    CGFloat actionBtnRadius;
    CGFloat smallRadius;
    CGFloat bigRadius;
    CGPoint center;
    CGFloat bigCenterH;
    
    UIImageView *imagView;
    NSTimer *timer;
}
-(void)dealloc{
    [timer invalidate];
    timer = nil;
}

- (void)initSubviews{
    [super initSubviews];
    
    categoryBtnW = 100*kScreenHeightRatio;
    actionBtnW = 150*kScreenHeightRatio;
    self.btnsArr = [NSMutableArray array];
    
    //晃动动画
    CABasicAnimation *basicAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basicAnim.toValue = [NSNumber numberWithFloat:M_PI_2/7];
    basicAnim.duration = 2.0;
    basicAnim.autoreverses = YES;
    basicAnim.repeatCount = HUGE_VAL;
    basicAnim.removedOnCompletion = NO;
    for (int i = 0; i < 4; i ++){
        UIButton *categoryBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self );
                make.size.mas_equalTo(CGSizeMake(categoryBtnW, categoryBtnW));
            }];
            btn.backgroundColor = UIColor.whiteColor;
            btn.layer.cornerRadius = categoryBtnW/2;
            btn.layer.masksToBounds = YES;
            btn;
        });
        
        [categoryBtn.layer addAnimation:basicAnim forKey:@"categoryKeyTarnsform.rotaiton.z"];
        
        
        if (i == 0){
            self.gameBtn = categoryBtn;
            categoryBtn.tag = CategoryGame;
            imagView = [[UIImageView alloc]init];
            [self.gameBtn addSubview:imagView];
            imagView.image = [UIImage imageNamed:@"home_game"];
            [imagView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.gameBtn);
            }];
            imagView.layer.cornerRadius = 5;
            imagView.layer.masksToBounds = YES;
            
        }else if (i == 1){
            self.aiBtn = categoryBtn;
            categoryBtn.tag = CategoryAI;
            [self.aiBtn setImage:[UIImage imageNamed:@"home_chat"] forState:UIControlStateNormal];
        }else if (i == 2) {
            self.storysBtn = categoryBtn;
            categoryBtn.tag = CategoryStory;
            [self.storysBtn setImage:[UIImage imageNamed:@"home_listen_story"] forState:UIControlStateNormal];
//            [self.storysBtn setBackgroundImage:[UIImage imageNamed:@"home_story_bg"] forState:UIControlStateNormal];
        }else{
            self.mathBtn = categoryBtn;
            categoryBtn.tag = CategoryMath;
            
            [self.mathBtn setImage:[UIImage imageNamed:@"home_calculate"] forState:UIControlStateNormal];
        }
        
        [self.btnsArr addObject:categoryBtn];
    }
    
    self.actionBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self  addSubview:btn];
        btn.frame = CGRectMake(0, 0, actionBtnW, actionBtnW);
        btn.center = self.center;
        btn.layer.cornerRadius = actionBtnW/2;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 104;
        btn;
        
    });
    
    [self.actionBtn setImage:[UIImage imageNamed:@"home_start_bg01"] forState:UIControlStateNormal];
    
    actionBtnRadius = sqrt(pow(CGRectGetWidth(self.actionBtn.frame)/2,2)*2)/2 ;
    smallRadius = categoryBtnW/5 + 20;
    bigRadius = smallRadius + actionBtnRadius;
    center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);//actionBtn 注意相对位置
    bigCenterH = sqrt(pow(bigRadius,2)/2);//直角三角形的直角边
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(categoryTap:)];
    self.userInteractionEnabled = YES;
    [self  addGestureRecognizer:tap];
    //    [self setupTimer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self actionBtnClick:self.actionBtn];
    });
    
}

#pragma mark -
#pragma mark ---init Timer
- (void)setupTimer{
    [timer invalidate];
    timer = nil;
    timer = [NSTimer timerWithTimeInterval:5.0 target:self selector:@selector(autoAction) userInfo:nil repeats:YES];
    [[NSRunLoop  currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

#pragma mark -
#pragma mark --- timeAction
- (void)autoAction{
    [UIView animateWithDuration:0.5 animations:^{
        [AnimationProcess springAnimationProcessWithView:self.actionBtn upHeight:arc4random()%(40-20+1)+20];
    }];
    
    [self startGameImageNewAnimation];
}

#pragma mark -
#pragma mark --- Tom
- (void)startGameImageNewAnimation{
    [self setupTag:arc4random()%11];
}

- (void)setupTag:(NSInteger )tag{
    switch (tag) {
        case cymbal:
            [self tomAnimation:@"cymbal" count:13];//拨
            break;
        case fart:
            [self tomAnimation:@"fart" count:28];
            break;
        case pie:
            [self tomAnimation:@"pie" count:24];
            break;
        case scratch:
            [self tomAnimation:@"scratch" count:56];//爪
            break;
        case eat:
            [self tomAnimation:@"eat" count:40];
            break;
        case drink:
            [self tomAnimation:@"drink" count:81];
            break;
            
        case footRight:
            [self tomAnimation:@"footRight" count:30];
            break;
        case footLeft:
            [self tomAnimation:@"footLeft" count:30];
            break;
        case knockout:
            [self tomAnimation:@"knockout" count:81];
            break;
        case stomach:
            [self tomAnimation:@"stomach" count:34];
            break;
        case angry:
            [self tomAnimation:@"angry" count:26];
            break;
    }
}

#pragma mark -
#pragma mark --- Tom Animation
- (void)tomAnimation:(NSString *)imageName count:(int )count{
    if ([imagView isAnimating]){
        return;
    }
    
    NSMutableArray *imageArr = [NSMutableArray array];
    for (int i = 0; i < count; i ++){
        NSString *str = [NSString stringWithFormat:@"%@_%02d.jpg",imageName,i];
        NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:nil];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [imageArr addObject:image];
    }
    
    [imagView setAnimationImages:imageArr];
    [imagView setAnimationDuration:imageArr.count *0.075];
    [imagView setAnimationRepeatCount:1];
    [imagView startAnimating];
    
    [imagView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:imagView.animationDuration];
}

//点击没有响应,不管你怎么移动，CoreAnimation的一个核心就是虽然看起来btn的frame在持续改变（在动画中），但是其frame的设置是立即改变的，比如你把一个button从0，0移动到200，200，在这种情况下：
//1.如果你使用的是显式动画（就像你现在用的CAKeyframeAnimation），是通过指定path来进行动画的，它的frame并没有改变，点击范围还是0，0这里
//2.如果你使用的是隐式动画，是通过设置frame来进行动画的，那么它的点击范围就是200，200这里
#pragma mark -
#pragma mark --- 手势
- (void)categoryTap:(UITapGestureRecognizer*)sender
{
    CGPoint touchPoint = [sender locationInView:self];
    for (UIButton *btn in self.btnsArr){
        if ([btn.layer.presentationLayer hitTest:touchPoint]){
            [[SoundsProcess shareInstance] playSoundOfTock];
            if (self.categoryDelegate && [self.categoryDelegate respondsToSelector:@selector(categoryAction:)]){
                [self.categoryDelegate categoryAction:btn];
            }
        }
    }
}

- (void)celarLayers{
    [self.gameLayer removeFromSuperlayer];
    [self.aiLayer removeFromSuperlayer];
    [self.storyLayer removeFromSuperlayer];
    [self.mathLayer removeFromSuperlayer];
    
    self.gameLayer = nil;
    self.aiLayer = nil;
    self.storyLayer = nil;
    self.mathLayer = nil;
}

#pragma mark -
#pragma mark --- ActionBtnClick
- (void)actionBtnClick:(UIButton*)sender{
    FGLOG(@"tap");
    [self celarLayers];
    //解决删除崩溃
    //    [sender.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [[SoundsProcess shareInstance] playSoundOfTock];
    if (!self.actionBtn.selected){
        [self addAnimationWithOutFlag:YES];
    }else{
        [self addAnimationWithOutFlag:NO];
    }
    self.actionBtn.selected = !self.actionBtn.selected;
}

- (void)addAnimationWithOutFlag:(BOOL)isOut{
    for (int i = 0; i < 4; i ++){
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
        circleLayer.strokeColor = RGBA(255, 255, 255, 0.0).CGColor;//曲线颜色及透明度
        circleLayer.strokeEnd = 1;
        circleLayer.strokeStart = 0.0;
        
        //in
        if (i == 0){
            //从左上半部开始顺时针绘制
            [circlePath addArcWithCenter:(CGPoint){center.x- bigCenterH,center.y-bigCenterH} radius:bigRadius startAngle:isOut? M_PI/4:M_PI/4*5 endAngle:isOut? M_PI/4*5:M_PI/4*9 clockwise:YES];
            self.gameLayer = circleLayer;
            self.gamePath = circlePath;
        }else if (i == 1){
            //从右上半部开始顺时针绘制
            [circlePath addArcWithCenter:(CGPoint){center.x+ bigCenterH,center.y-bigCenterH} radius:bigRadius startAngle:isOut? M_PI/4*3:M_PI/4*7 endAngle:isOut? M_PI/4*7:M_PI/4*11 clockwise:YES];
            self.aiLayer = circleLayer;
            self.aiPath = circlePath;
            
        }else if (i == 2){
            //从右下半部开始顺时针绘制
            [circlePath addArcWithCenter:(CGPoint){center.x+ bigCenterH,center.y+bigCenterH} radius:bigRadius startAngle:isOut? M_PI/4*5:M_PI/4 endAngle:isOut? M_PI*2+M_PI/4:M_PI/4*5 clockwise:YES];
            self.storyLayer = circleLayer;
            self.storyPath = circlePath;
        }else{
            //从左下半部开始顺时针绘制
            [circlePath addArcWithCenter:(CGPoint){center.x- bigCenterH,center.y+bigCenterH} radius:bigRadius startAngle:isOut? M_PI/4*7:M_PI/4*3 endAngle:isOut? M_PI/4*3:M_PI/4*7 clockwise:YES];
            self.mathLayer = circleLayer;
            self.mathPath = circlePath;
        }
        
        circleLayer.path = circlePath.CGPath;
        
        CABasicAnimation *pathAnima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        pathAnima.duration = 1.0f;
        pathAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnima.fromValue = [NSNumber numberWithFloat:0.0f];
        pathAnima.toValue = [NSNumber numberWithFloat:1.0f];
        pathAnima.fillMode = kCAFillModeForwards;
        pathAnima.removedOnCompletion = YES;
        [circleLayer addAnimation:pathAnima forKey:@"strokeEndAnimation1"];
        
        CAKeyframeAnimation *orbit = [CAKeyframeAnimation animation];
        orbit.keyPath = @"position";
        orbit.path = circlePath.CGPath;
        orbit.duration = 1.0;
        orbit.repeatCount = 1;
        orbit.calculationMode = kCAAnimationPaced;//移动时的样式
        
        orbit.removedOnCompletion = NO;//到了那个移动位置后,是否返回
        orbit.fillMode = kCAFillModeForwards;//动画的阶段模式,在动画还没开始前  和上面的(removedOnCompletion)一起搭配使用,固定用法
        
        UIButton *btn = (UIButton*)self.btnsArr[i];
        [btn.layer addAnimation:orbit forKey:@"orbit"];
        
        if (isOut) {
            btn.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.actionBtn.alpha = 0.5;
            
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:50 options:UIViewAnimationOptionCurveLinear animations:^{
                btn.transform = CGAffineTransformMakeScale(0.9, 0.9);
            } completion:^(BOOL finished) {
                btn.transform = CGAffineTransformIdentity;
            }];
            
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:50 options:UIViewAnimationOptionCurveLinear animations:^{
                self.actionBtn.transform = CGAffineTransformMakeScale(0.5, 0.5);
                self.actionBtn.alpha = 1.0;
                btn.alpha = 1.0;
            } completion:^(BOOL finished) {
                self.actionBtn.transform = CGAffineTransformIdentity;
            }];
            
        }else{
            btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
            self.actionBtn.alpha = 0.5;
            [UIView animateWithDuration:1 animations:^{
                btn.transform = CGAffineTransformMakeScale(0.1, 0.1);
                self.actionBtn.alpha = 1.0;
                self.actionBtn.transform = CGAffineTransformMakeScale(0.5, 0.5);
                btn.alpha = 0.0;
            } completion:^(BOOL finished) {
                btn.transform = CGAffineTransformIdentity;
                self.actionBtn.transform = CGAffineTransformIdentity;
            }];
        }
        [self.layer addSublayer:circleLayer];
    }
}

@end
