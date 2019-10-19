//
//  ISRConfigViewController.m
//  MSCDemo_UI
//
//  Created by wangdan on 15-4-25.
//  Copyright (c) 2015年 iflytek. All rights reserved.
//

#import "TTSConfigViewController.h"
#import "TTSConfig.h"

#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

@interface TTSConfigViewController ()

@end

@implementation TTSConfigViewController

#pragma mark - 视图生命周期
- (void)viewDidLoad {
    
    FGLOG(@"%s[IN]",__func__);
    
    [super viewDidLoad];
    [self initView];
    
    FGLOG(@"%s[OUT]",__func__);
}

- (void)viewWillAppear:(BOOL)animated{
    FGLOG(@"%s[IN]",__func__);
    
    [super viewWillAppear:animated];

    [self needUpdateSettings];
    
    FGLOG(@"%s[OUT]",__func__);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    _backScrollView.contentSize = CGSizeMake(size.width ,size.height+300);
}

- (void)didReceiveMemoryWarning{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


#pragma mark - 界面初始化

-(void)initView{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ( IOS7_OR_LATER )
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.navigationController.navigationBar.translucent = NO;
    }
#endif
    
    self.view.backgroundColor = [UIColor colorWithRed:26.0/255.0 green:26.0/255.0 blue:26.0/255.0 alpha:1.0];
    
    
    self.roundSlider = [[SAMultisectorControl alloc]init];
    [self.view addSubview:self.roundSlider];
    [self.roundSlider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(375-100, 375-90));
        make.centerY.mas_equalTo(self.view).offset(-70);
        make.centerX.mas_equalTo(self.view);
    }];
    
    self.volumeLabel = ({
        UILabel *label = [[UILabel alloc]init];
        [self.view addSubview:label];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    self.speedLabel = ({
        UILabel *label = [[UILabel alloc]init];
        [self.view addSubview:label];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    self.pitchLabel = ({
        UILabel *label = [[UILabel alloc]init];
        [self.view addSubview:label];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentCenter;
        label;
    });
    
    CGSize labSize = CGSizeMake(100, 20);
    [self.speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.roundSlider.mas_bottom).offset(10);
        make.size.mas_equalTo(labSize);
    }];
    [self.volumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.speedLabel.mas_left).offset(-5);
        make.top.mas_equalTo(self.speedLabel);
        make.size.mas_equalTo(labSize);
    }];
    
    
    [self.pitchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.speedLabel.mas_right).offset(5);
        make.top.mas_equalTo(self.speedLabel);
        make.size.mas_equalTo(labSize);
    }];
    
//    self.volumeLabel.backgroundColor = [UIColor redColor];
//    self.speedLabel.backgroundColor = [UIColor purpleColor];
//    self.pitchLabel.backgroundColor = [UIColor cyanColor];
//    
    
    
    
    
    TTSConfig *instance = [TTSConfig sharedInstance];
    
    
    // 初始化发音人选择界面
    self.vcnPicker = [[AKPickerView alloc]init];
    [self.view addSubview:self.vcnPicker];
    
    
    __unused UILabel *vcnLab = ({
        UILabel *label = [[UILabel alloc]init];
        [self.view addSubview:label];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        label.textAlignment = NSTextAlignmentRight;
        label.text = @"发音人:";
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.volumeLabel);
            make.top.mas_equalTo(self.volumeLabel.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(100, 30));
        }];
        
        label;
    });
    [self.vcnPicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(vcnLab);
        make.left.mas_equalTo(vcnLab.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    
    _vcnPicker.delegate = self;
    _vcnPicker.dataSource = self;
    _vcnPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _vcnPicker.textColor = [UIColor whiteColor];
    _vcnPicker.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    _vcnPicker.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:17];
    _vcnPicker.highlightedTextColor = [UIColor colorWithRed:0.0 green:168.0/255.0 blue:255.0/255.0 alpha:1.0];
    _vcnPicker.interitemSpacing = 20.0;
    _vcnPicker.fisheyeFactor = 0.001;
    _vcnPicker.pickerViewStyle = AKPickerViewStyle3D;
    _vcnPicker.maskDisabled = false;
    
    _backScrollView.canCancelContentTouches = YES;
    _backScrollView.delaysContentTouches = NO;//优先使用子页面的触摸事件
    
    
    // 初始化音量、语速、语调界面
    
    [_roundSlider addTarget:self action:@selector(onMultiSectorValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    UIColor *blueColor = [UIColor colorWithRed:0.0 green:168.0/255.0 blue:255.0/255.0 alpha:1.0];
    UIColor *redColor = [UIColor colorWithRed:245.0/255.0 green:76.0/255.0 blue:76.0/255.0 alpha:1.0];
    UIColor *greenColor = [UIColor colorWithRed:29.0/255.0 green:207.0/255.0 blue:0.0 alpha:1.0];
    
    _pitchSec = [SAMultisectorSector sectorWithColor:redColor maxValue:100];//前端点
    _speedSec = [SAMultisectorSector sectorWithColor:blueColor maxValue:100];//后端点
    _volumeSec = [SAMultisectorSector sectorWithColor:greenColor maxValue:100];//录音超时
    
    _pitchSec.endValue = instance.pitch.integerValue;
    _speedSec.endValue = instance.speed.integerValue;
    _volumeSec.endValue = instance.volume.integerValue;
    
    [_roundSlider addSector:_pitchSec];
    [_roundSlider addSector:_speedSec];
    [_roundSlider addSector:_volumeSec];//半径依次增大
    
    
    self.closeBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.vcnPicker.mas_bottom).offset(20);
            make.centerX.mas_equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(250, 30));
            
        }];
        [btn setBackgroundColor:RGBA(255, 255, 255, 0.3)];
        btn.layer.cornerRadius = 10;
        btn.layer.masksToBounds = YES;
        [btn setTitle:@"关闭" forState:UIControlStateNormal];
        btn;
    });
    
    
    
}
#pragma mark  界面更新

-(void)needUpdateRound{
    
    TTSConfig *instance = [TTSConfig sharedInstance];
    
    //更新语速、音量、语调
//    _speedLabel.text = instance.speed;//超时等时间设置
//    _volumeLabel.text = instance.volume;
//    _pitchLabel.text = instance.pitch;
    _speedLabel.text = [NSString stringWithFormat:@"语速: %@",instance.speed];
    _volumeLabel.text = [NSString stringWithFormat:@"声音: %@",instance.volume];
    _pitchLabel.text = [NSString stringWithFormat:@"语调: %@",instance.pitch];
    
    _speedSec.endValue = instance.speed.integerValue;
    _volumeSec.endValue = instance.volume.integerValue;
    _pitchSec.endValue = instance.pitch.integerValue;
}

-(void)needUpdateEngineType{
    
    TTSConfig *instance = [TTSConfig sharedInstance];
    
    //更新引擎类型
    NSString *type = instance.engineType;
    if ([type isEqualToString:[IFlySpeechConstant TYPE_AUTO]]) {
        _engineTypeSeg.selectedSegmentIndex = 0;
        _sampleRateSeg.hidden = NO;
    }
    else if ([type isEqualToString:[IFlySpeechConstant TYPE_CLOUD]]) {
        _engineTypeSeg.selectedSegmentIndex = 1;
        _sampleRateSeg.hidden = NO;
        
    }else if ([type isEqualToString:[IFlySpeechConstant TYPE_LOCAL]]) {
        _engineTypeSeg.selectedSegmentIndex = 2;
        _sampleRateSeg.hidden = YES;
    }
    
}

-(void)needUpdateSampleRate{
    
    TTSConfig *instance = [TTSConfig sharedInstance];
    
    //更新采样率
    NSString *sampleRate = instance.sampleRate;//采样率
    if ([sampleRate isEqualToString:[IFlySpeechConstant SAMPLE_RATE_16K]]) {
        _sampleRateSeg.selectedSegmentIndex = 0;
        
    }else if ([sampleRate isEqualToString:[IFlySpeechConstant SAMPLE_RATE_8K]]) {
        _sampleRateSeg.selectedSegmentIndex = 1;
        
    }
}

-(void)needUpdateVcn{
    
    TTSConfig *instance = [TTSConfig sharedInstance];
    
    //更新发音人
    
    [self.vcnPicker reloadData];
    int vcnIndex= 0;
    if([instance.engineType isEqualToString: [IFlySpeechConstant TYPE_LOCAL]]){
        for (int i = 0;i < self.spVcnList.count; i++) {
            if([[[self.spVcnList objectAtIndex:i] objectForKey:@"name"] isEqualToString:instance.vcnName]){
                vcnIndex=i;
                break;
            }
        }
        [_vcnPicker selectItem:vcnIndex animated:NO];
    }
    else{
        for (int i = 0;i < instance.vcnIdentiferArray.count; i++) {
            if ([[instance.vcnIdentiferArray objectAtIndex:i] isEqualToString:instance.vcnName]) {
                vcnIndex=i;
                break;
            }
        }
        [_vcnPicker selectItem:vcnIndex animated:NO];
    }
}

-(void)needUpdateSettings{
    [self needUpdateRound];
    [self needUpdateEngineType];
    [self needUpdateSampleRate];
    [self needUpdateVcn];
}


#pragma mark - 界面操作响应
- (void)onMultiSectorValueChanged:(id)sender{
    
    TTSConfig *instance = [TTSConfig sharedInstance];
    instance.speed = [NSString stringWithFormat:@"%d", (int)_speedSec.endValue];
    instance.volume = [NSString stringWithFormat:@"%d", (int)_volumeSec.endValue];
    instance.pitch = [NSString stringWithFormat:@"%d", (int)_pitchSec.endValue];
    
    
    _speedLabel.text = [NSString stringWithFormat:@"语速: %@",instance.speed];
    _volumeLabel.text = [NSString stringWithFormat:@"声音: %@",instance.volume];
    _pitchLabel.text = [NSString stringWithFormat:@"语调: %@",instance.pitch];
    
    _speedSec.endValue = [instance.speed integerValue];
    _volumeSec.endValue = [instance.volume integerValue];
    _pitchSec.endValue = [instance.pitch integerValue];
}


- (IBAction)onSampleRateSegValueChanged:(id)sender {
    
    TTSConfig *instance = [TTSConfig sharedInstance];
    UISegmentedControl *seg = (UISegmentedControl*) sender;
    
    if (seg.selectedSegmentIndex == 0) {
        instance.sampleRate = [IFlySpeechConstant SAMPLE_RATE_16K];
    }else if (seg.selectedSegmentIndex == 1) {
        instance.sampleRate = [IFlySpeechConstant SAMPLE_RATE_8K];
    }
}


/*
 引擎模式选择处理
 支持云端和离线两种工作模式。
 */
- (IBAction)onEngineTypeSegValueChanged:(id)sender {
    
    FGLOG(@"%s[IN]",__func__);
    
    TTSConfig *instance = [TTSConfig sharedInstance];
    UISegmentedControl *seg = (UISegmentedControl*) sender;
    
    if (seg.selectedSegmentIndex == 0) {
        instance.engineType = [IFlySpeechConstant TYPE_AUTO];
    }else if (seg.selectedSegmentIndex == 1) {
        instance.engineType = [IFlySpeechConstant TYPE_CLOUD];
    }else if (seg.selectedSegmentIndex == 2) {
        seg.selectedSegmentIndex = 0;
        instance.engineType = [IFlySpeechConstant TYPE_AUTO];
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                         message:@"本Demo未集成本地合成功能，如需使用请前往http://www.xfyun.cn下载，谢谢!"
                                                        delegate:self cancelButtonTitle:@"好哒^_^"
                                               otherButtonTitles:nil];
        [alert show];
    }
    
    FGLOG(@"%s[OUT]",__func__);
}

#pragma mark - 发音人设置相关
#pragma mark  AKPickerViewDataSource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView{
    
    //    FGLOG(@"%s[IN]",__func__);
    
    NSUInteger count = 1;
    
    TTSConfig* instance = [TTSConfig sharedInstance];
    
    //离线模式
    if(instance.engineType == [IFlySpeechConstant TYPE_LOCAL]){
        if(self.spVcnList == nil){
            count = 1;
        }
        else{
            count = self.spVcnList.count;
        }
    }
    else{
        count = instance.vcnIdentiferArray.count;
    }
    
    //    FGLOG(@"%s,count=%d[OUT]",__func__,count);
    
    return count;
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item{
    
    //    FGLOG(@"%s[IN],item=%d",__func__,item);
    
    TTSConfig* instance = [TTSConfig sharedInstance];
    
    NSString *title = nil;
    
    //离线模式
    if(instance.engineType == [IFlySpeechConstant TYPE_LOCAL]){
        if(self.spVcnList.count > 0 && self.spVcnList.count > item){
            title = [[self.spVcnList objectAtIndex:item] objectForKey:@"nickname"];
        }
    }
    else{
        
        if(instance.vcnNickNameArray.count > item){
            title = [instance.vcnNickNameArray objectAtIndex:item];
        }
    }
    
    //    FGLOG(@"%s[OUT],title=%@",__func__,title);
    
    return title;
}

#pragma mark   AKPickerViewDelegate
- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item{
    
    TTSConfig *instance = [TTSConfig sharedInstance];
    
    //    FGLOG(@"%s[IN],item=%d",__func__,item);
    
    //离线模式
    if(instance.engineType == [IFlySpeechConstant TYPE_LOCAL])
    {
        if(self.spVcnList.count > 0 && self.spVcnList.count > item)
        {
            instance.vcnName = [[self.spVcnList objectAtIndex:item] objectForKey:@"name"];
            
            //显示从语记下载的发音人信息
            NSDictionary *info = [self.spVcnList objectAtIndex:item];
            NSString *vcnInfo= @"";
            
            //发音人名称
            NSString *name = [info objectForKey:@"name"];
            if(name){
                vcnInfo = [vcnInfo stringByAppendingFormat:@"\n姓名：%@",name];
            }
            
            //别名
            NSString *nickname = [info objectForKey:@"nickname"];
            if(nickname){
                vcnInfo = [vcnInfo stringByAppendingFormat:@"\n别名：%@",nickname];
            }
            
            //年龄
            NSString *age = [info objectForKey:@"age"];
            if(age){
                vcnInfo = [vcnInfo stringByAppendingFormat:@"\n年龄：%@",age];
            }
            
            //性别
            NSString *sex = [info objectForKey:@"sex"];
            if(sex){
                vcnInfo = [vcnInfo stringByAppendingFormat:@"\n性别：%@",sex];
            }
            
            FGLOG(@"vcnInfo:%@",vcnInfo);
        }
    }
    else
    {
        instance.vcnName = [instance.vcnIdentiferArray objectAtIndex:item];
    }
    
    //    FGLOG(@"%s[OUT]",__func__);
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 2 && buttonIndex == 1) {
        NSString *url = [IFlySpeechUtility  componentUrl];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

@end
