//
//  AIVoiceMathematicsViewController.m
//  FGProject
//
//  Created by Bert on 16/8/10.
//  Copyright © 2016年 XL. All rights reserved.
//

#import "AIVoiceMathematicsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <iflyMSC/iflyMSC.h>
#import <iflyMSC/IFlyRecognizerViewDelegate.h>
#import <iflyMSC/IFlyRecognizerView.h>
#import <iflyMSC/IFlySpeechConstant.h>
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlySpeechSynthesizer.h"
#import "iflyMSC/IFlySpeechSynthesizerDelegate.h"
#import "IATConfig.h"
#import "iflyMSC/IFlySpeechRecognizer.h"
#import "WriteFunction.h"
#import "WriteAnimationLayer.h"
#import "FGAIActionView.h"
#import "FGAIChatTableViewCell.h"
#import "FGMySpeakTableViewCell.h"
#import "Waver.h"
#import "FGStartAIChatView.h"
#import "TTSConfigViewController.h"
#import "TTSConfig.h"
#import <AdSupport/AdSupport.h>
#import "FGImagePickerController.h"
#import "FGAlertView.h"
#import "JCAlertView.h"
@interface AIVoiceMathematicsViewController ()<IFlySpeechSynthesizerDelegate,IFlySpeechRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,FGStartAIChatViewDelegate,FGMySpeakTableViewCellDelegate,
UIImagePickerControllerDelegate,UINavigationControllerDelegate
,FGAIChatTableViewCellDelegate,FGAlertViewDelegate
>
{
    IFlySpeechSynthesizer * _iFlySpeechSynthesizer;//语音合成,将文字转换语音
    IFlySpeechUnderstander *_iFlySpeechUnderstander;//语义理解,理解用户意图,返回结果
    //不带界面的识别对象
    IFlySpeechRecognizer *iFlySpeechRecognizer;//语音听写将语音转换为文字
    FGMySpeakTableViewCell *mySelfCell;
    TTSConfigViewController *iatConfig;
    FGAlertView *alerView;
    
    UITapGestureRecognizer *stopAISpeekGR;//取消语音阅读
}
@property (nonatomic, strong) IFlyRecognizerView *iflyerReconizerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *mySpeakDataArr;
@property (nonatomic, strong) NSMutableArray *aiSpeaktDataArr;

@property (nonatomic, strong) NSMutableString *aiSpeakWordsStr;
@property (nonatomic, strong) NSMutableString *mySpeakWordsStr;

@property (nonatomic, strong) FGStartAIChatView *startAIChatView;

@property (nonatomic, strong) NSMutableArray *noAnswerArr;//不知道如何回复的处理.

//@property (nonatomic,strong ) FIRDatabaseReference *dataBaseRef;//存字符串
//@property (nonatomic,strong ) FIRStorageReference  *storageRef;//存文件图片等(文件存储系统，保存文件后会生成一个url)
@property (nonatomic,strong ) NSString *firebaseRootKeyStr;//标识符
@end

@implementation AIVoiceMathematicsViewController
static NSString *wordsStr = @"";
static CGRect   strOfRect;


- (NSMutableArray *)mySpeakDataArr
{
    if (!_mySpeakDataArr)
    {
        _mySpeakDataArr = [NSMutableArray array];
    }
    return _mySpeakDataArr;
}
-(NSMutableString *)mySpeakWordsStr
{
    if (!_mySpeakWordsStr) {
        _mySpeakWordsStr = [NSMutableString string];
    }
    return _mySpeakWordsStr;
}

- (NSMutableArray *)aiSpeaktDataArr
{
    if (!_aiSpeaktDataArr)
    {
        _aiSpeaktDataArr = [NSMutableArray array];
        
    }
    return _aiSpeaktDataArr;
}

- (NSMutableString *)aiSpeakWordsStr
{
    if (!_aiSpeakWordsStr)
    {
        _aiSpeakWordsStr = [NSMutableString string];
    }
    return _aiSpeakWordsStr;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
//        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 44+10, kScreenHeight-2*10, kScreenWidth-20-100-44) style:UITableViewStylePlain];
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 44+10, kScreenWidth-2*10, kScreenHeight -20-100-44) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.layer.borderWidth = 1;
        _tableView.layer.borderColor = [RGBA(227, 227, 227,0.3) CGColor];//设置列表边框
        
    }
    return _tableView;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}
- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    iFlySpeechRecognizer.delegate = nil;
    [iFlySpeechRecognizer cancel];
    [iFlySpeechRecognizer stopListening];
    iFlySpeechRecognizer = nil;
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.transform = CGAffineTransformMakeRotation(-M_PI*0.5);
//    self.view.frame = CGRectMake(0, 0,kScreenWidth,kScreenHeight);
    
    self.noAnswerArr = [NSMutableArray arrayWithArray: @[@"我好像不明白.",@"对不起,我不知道.",@"我懂得太少,不清楚."]];
    FGBlurEffectView *blurView = [[FGBlurEffectView alloc]init];
    [self.view addSubview:blurView];
    dispatch_async(dispatch_get_main_queue(), ^{
        blurView.bgImageView.image = [UIImage imageNamed:@"Indexbg-03"];
    });
    
    [blurView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view addSubview:self.tableView];
//    
//    self.startAIChatView = [[FGStartAIChatView alloc]initWithFrame:CGRectMake(10, kScreenWidth-80, kScreenHeight-20, 50)];
    
    
    self.startAIChatView = [[FGStartAIChatView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.tableView.frame) + 10, kScreenWidth-20, 50)];
    [self.view addSubview:self.startAIChatView];
    self.startAIChatView.startAIChatDelegate = self;

    
    stopAISpeekGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelSpeechClick:)];
    
    
    
    [self setupSpeechSynthesizer];

    //暂时隐藏
//    self.aiActionView = [[FGAIActionView alloc]init];
//    self.aiActionView.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:self.aiActionView];
//    self.aiActionView.hidden = YES;
//    [self.aiActionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(-10);
//        make.bottom.mas_equalTo(-10);
//        make.width.mas_equalTo(kScreenWidth/2-20);
//    }];
//    [self.aiActionView.voiceToWordsBtn addTarget:self action:@selector(setupVoiceToWords) forControlEvents:UIControlEventTouchUpInside];
//    [self.aiActionView.cancelSpeechBtn addTarget:self action:@selector(cancelSpeechBtnSpeechClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.aiActionView.aiChatBtn addTarget:self action:@selector(setupUnderstander) forControlEvents:UIControlEventTouchUpInside];
    
//    [self setupPostDataToFireBase];
    FGNavigationView *navigationView = [[FGNavigationView alloc]initWithDelegate:self];
    [self.view addSubview:navigationView];
    [navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.mas_equalTo(self.view);
        make.height.mas_equalTo(44);
    }];

}

#pragma mark -
#pragma mark --- 数据上传 Firebase
//- (void)setupPostDataToFireBase
//{
//    NSString *adidStr = [FLDeviceUID uid];
//
//    self.firebaseRootKeyStr = [NSString stringWithFormat:@"%@-%@",adidStr,[FGProjectHelper logTimeStringFromDate:[NSDate date]]] ;
//    NSLog(@"-----addid %@",  self.firebaseRootKeyStr);
//    self.dataBaseRef = [[FIRDatabase database]referenceFromURL:FIREBASE_DATABASE_URL];
//    self.dataBaseRef = [[self.dataBaseRef child:adidStr]child:FIREBASE_DATABASE_CATEGORY_AI];
//
//    self.dataBaseRef = [self.dataBaseRef child:self.firebaseRootKeyStr];
////    [self.dataBaseRef removeValue];
//
//    self.storageRef = [[FIRStorage storage]referenceForURL:FIREBASE_STORAGE_URL];
//    self.storageRef = [[self.storageRef child:adidStr]child:FIREBASE_DATABASE_CATEGORY_AI];
//    self.storageRef = [self.storageRef child:self.firebaseRootKeyStr];
//}

#pragma mark -
#pragma mark --- FGAIChatCellDelegate 设置语音
- (void)setupSpeekConfig:(UIButton *)sender
{
    iatConfig = [[TTSConfigViewController alloc]init];
    [self addChildViewController:iatConfig];
    iatConfig.view.layer.cornerRadius = 10;
    [self.view addSubview:iatConfig.view];
    [iatConfig.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenHeight*0.8, kScreenHeight*0.8+180));
    }];
    self.tableView.userInteractionEnabled = NO;
    
    [iatConfig.closeBtn addTarget:self action:@selector(closeSpeekSetting) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -
#pragma mark --- 关闭设置
- (void)closeSpeekSetting
{
    self.tableView.userInteractionEnabled = YES;
    for (UIViewController *vc in self.childViewControllers) {
        if ([vc isKindOfClass:[TTSConfigViewController class]])
        {
            [vc removeFromParentViewController];
            [vc.view removeFromSuperview];
        }
    }
    
    [iatConfig removeFromParentViewController];
    [iatConfig.view removeFromSuperview];
    iatConfig = nil;
}

- (void)updateiFlySpeechConfig
{
    TTSConfig *instance = [TTSConfig sharedInstance];
    
    [_iFlySpeechSynthesizer setParameter:instance.volume forKey: [IFlySpeechConstant VOLUME]];
    [_iFlySpeechSynthesizer setParameter:instance.speed forKey: [IFlySpeechConstant SPEED]];
    [_iFlySpeechSynthesizer setParameter:instance.pitch forKey: [IFlySpeechConstant PITCH]];
    
    //设置采样率
    [_iFlySpeechSynthesizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    //发音人,默认为”xiaoyan”,可以设置的参数列表可参考“合成发音人列表”
    [_iFlySpeechSynthesizer setParameter:instance.vcnName forKey: [IFlySpeechConstant VOICE_NAME]];
}

#pragma mark -
#pragma mark --- 改变头像 FGMySpeakTableViewCellDelegate
- (void)changeIcon:(UIButton *)sender
{
//    UIAlertController *alertContro = [UIAlertController alertControllerWithTitle:@"修改头像" message:@"" preferredStyle: UIAlertControllerStyleActionSheet];
//     __block NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//    [alertContro addAction:[UIAlertAction actionWithTitle:@"使用手机相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//      
//        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        [self changeIconWithSourceType:sourceType];
//        
//    }]];
//    [alertContro addAction:[UIAlertAction actionWithTitle:@"使用相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        sourceType = UIImagePickerControllerSourceTypeCamera;
//        [self changeIconWithSourceType:sourceType];
//    }]];
//    [alertContro addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        
//    }]];
//
//    
//    [self presentViewController:alertContro animated:YES completion:nil];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"修改头像" message:@"" delegate: self cancelButtonTitle:@"取消" otherButtonTitles:@"使用相册",@"使用相机", nil];
//        alerView.transform = CGAffineTransformMakeRotation(-M_PI*1);
//        //    self.view.frame = CGRectMake(0, 0,kScreenWidth,kScreenHeight);
//        
//        [alerView show];
//    });
    
    alerView = [[FGAlertView alloc]initWithTitle:@"修改头像" message:nil  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"使用相册",@"使用相机",nil];
    [self.view addSubview:alerView];
    [alerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
}

#pragma mark -
#pragma mark --- FGAlertViewDelegate
- (void)itemBtnAction:(UIButton *)sender
{
     __block NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (sender.tag == 0)
    {

    }else if (sender.tag == 1)
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self changeIconWithSourceType:sourceType];
    }else if (sender.tag == 2)
    {
        sourceType = UIImagePickerControllerSourceTypeCamera;
        [self changeIconWithSourceType:sourceType];
    }else
    {

    }
    
}



- (void)changeIconWithSourceType:(NSUInteger)sourceType
{
//    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    FGImagePickerController *imagePicker = [[FGImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = sourceType;

    [self presentViewController:imagePicker animated:YES completion:^{

    }];
    
}

#pragma mark -
#pragma mark --- UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image)
    {
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setObject:UIImageJPEGRepresentation(image, 100) forKey:MY_ICON_KEY];
        [userDef synchronize];
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        FGMySpeakTableViewCell *cell = mySelfCell;
        [cell.iconBtn setImage:image forState:UIControlStateNormal];
        [self.tableView reloadData];
        
//        [self postStoregeDataWithImage:image];
        
    }];
    
}

#pragma mark -
#pragma mark --- FGStartAIChatViewDelegate
- (void)startBtnAction
{
    if (![FGNetworkingReachable sharedInstance].isReachable)
    {
        [self.view makeToast:@"网络状态不好"];
        return;
    }
    [self updateiFlySpeechConfig];
    
    [self setupUnderstander];
}

#pragma mark -
#pragma mark --- 取消语音合成阅读 speech
- (void)cancelSpeechClick:(UITapGestureRecognizer*)sender
{
    if (_iFlySpeechSynthesizer)
    {
        [_iFlySpeechSynthesizer stopSpeaking];
        
        [self.startAIChatView endWave];
    }
}


#pragma mark -
#pragma mark --- 初始化语音合成,将一段文字转换为语音 speech
- (void)setupSpeechSynthesizer
{
    if (![FGNetworkingReachable sharedInstance].isReachable)
    {
        //离线不能合成
        //生成合成引擎的资源文件路径,以发音人小燕为例,请确保资源文件的存在
        NSString *resPath = [[NSBundle mainBundle] resourcePath];
        NSString *newResPath = [[NSString alloc] initWithFormat:@"%@/tts64res/common.jet;%@/tts64res/xiaoyan.jet",resPath,resPath]; //设置TTS的启动参数
        [[IFlySpeechUtility getUtility] setParameter:@"tts" forKey:[IFlyResourceUtil ENGINE_START]];
        //生成TTS的实例
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance]; _iFlySpeechSynthesizer.delegate = self;
        //设置本地引擎类型
        [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_LOCAL] forKey:[IFlySpeechConstant ENGINE_TYPE]];
        //设置发音人为小燕
        [_iFlySpeechSynthesizer setParameter:@"xiaoyan" forKey:[IFlySpeechConstant VOICE_NAME]]; //设置TTS合成的引擎资源文件路径
        [_iFlySpeechSynthesizer setParameter:newResPath forKey:@"tts_res_path"];
                NSLog(@"-----newpath %@",newResPath);
        //音量,取值范围 0~100
        [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
        [_iFlySpeechSynthesizer setParameter:@"tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];

    }else
    {
        NSLog(@"-----网络合成 ");
        //1.创建合成对象
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance]; _iFlySpeechSynthesizer.delegate =
        self;
        //2.设置合成参数
        //设置在线工作方式
        [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD] forKey:[IFlySpeechConstant ENGINE_TYPE]];
        //音量,取值范围 0~100
        [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
        //发音人,默认为”xiaoyan”,可以设置的参数列表可参考“合成发音人列表”
        [_iFlySpeechSynthesizer setParameter:@" xiaoyan " forKey: [IFlySpeechConstant VOICE_NAME]];
        //保存合成文件名,如不再需要,设置设置为nil或者为空表示取消,默认目录位于 library/cache下
        [_iFlySpeechSynthesizer setParameter:@"tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    }
    
    //第一次启动
    [self speechWithWords:@"你好,有什么需要我帮助的吗?"];
    [self.startAIChatView startWaveWithVolume:5];
}
#pragma mark -
#pragma mark --- 合成
- (void)speechWithWords:(NSString *)words
{
    
    NSLog(@"-----words %@",words);
    //3.启动合成会话
    [_iFlySpeechSynthesizer startSpeaking:words];

    [self.startAIChatView addGestureRecognizer:stopAISpeekGR];
}

#pragma mark -
#pragma mark --- IFlySpeechSynthesizer Delegate
- (void)onCompleted:(IFlySpeechError*) error
{
    NSLog(@"--- 合成 onCompleted %@  errorType %d errorCode %d ",error.errorDesc,error.errorType,error.errorCode);
    [self.startAIChatView endWave];
    [self.startAIChatView removeGestureRecognizer:stopAISpeekGR];
}
/**
 *  开始合成回调
 */
- (void)onSpeakBegin
{
    NSLog(@"-----合成 onSpeakBegin ");
    [self.startAIChatView startWaveWithVolume:-1];
}


#pragma mark -
#pragma mark --- -----------------------------------------

#pragma mark -
#pragma mark --- 语义理解
- (void)setupUnderstander
{
    self.aiSpeakWordsStr = nil;
    self.mySpeakWordsStr = nil;
    
    iFlySpeechRecognizer.delegate = nil;
    [iFlySpeechRecognizer cancel];
    [iFlySpeechRecognizer stopListening];
    iFlySpeechRecognizer = nil;
   
    //1.创建语音对象
    //语义理解单例
    if (_iFlySpeechUnderstander == nil) {
        _iFlySpeechUnderstander = [IFlySpeechUnderstander sharedInstance];
    }
    
    _iFlySpeechUnderstander.delegate = self;
    bool ret = [_iFlySpeechUnderstander startListening];
    if (ret) {
        NSLog(@"-----语义理解听成功 ");
    }
    else
    {
    NSLog(@"-----语义理解听失败 ");
    }
}



#pragma mark -
#pragma mark --- 语音听写,语音转文字
-(void)setupVoiceToWords
{
    self.aiSpeakWordsStr = nil;
    self.mySpeakWordsStr = nil;
    
    _iFlySpeechUnderstander.delegate = nil;
    [_iFlySpeechUnderstander stopListening];
    [_iFlySpeechUnderstander cancel];
    _iFlySpeechUnderstander = nil;
   
    //其代理方法和语义理解同样
    //1.创建语音听写对象
    if (!iFlySpeechRecognizer)
    {
        iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance]; //设置听写模式
        
        [iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        //2.设置听写参数
        [iFlySpeechRecognizer setParameter: @"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
        //asr_audio_path是录音文件名,设置value为nil或者为空取消保存,默认保存目录在 Library/cache下。
        [iFlySpeechRecognizer setParameter:@"asrview.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    }
    iFlySpeechRecognizer.delegate = self;
    //3.启动识别服务
    [iFlySpeechRecognizer startListening];
}

#pragma mark -
#pragma mark ---IFlySpeechUnderstander IFlySpeechRecognizerDelegate
/*!
 *  识别结果回调
 *    在进行语音识别过程中的任何时刻都有可能回调此函数，你可以根据errorCode进行相应的处理，
 *  @param errorCode 错误描述
 */
- (void) onError:(IFlySpeechError *) errorCode
{
     NSLog(@"-----语义理解 onError %@",errorCode.errorDesc);

    
}
-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    if (!object)
    {
        return @"null";
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
/*!
 *  识别结果回调
 */
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
    NSDictionary *dic = [results objectAtIndex:0];

    NSMutableString *tempStr = [NSMutableString string];
    for (NSString *key in dic)
    {
        [tempStr appendFormat:@"%@",key];
    }
    NSDictionary *resultsDic = [FGProjectHelper dictionaryWithJsonString:tempStr];
    NSDictionary *answerDic = resultsDic[@"answer"];
    [self.aiSpeakWordsStr appendFormat:@"%@",answerDic[@"text"]];
    if (isLast)
    {
        [_iFlySpeechUnderstander stopListening];
        
        [self.mySpeakWordsStr appendFormat:@"%@",resultsDic[@"text"]];
        NSLog(@"-----你说的是: %@ \n 回答是:%lu",resultsDic[@"text"],(unsigned long)self.mySpeakWordsStr.length);
        
        if ([self.aiSpeakWordsStr isEqualToString:@"(null)"])
        {
            self.aiSpeakWordsStr = nil;
            [self.aiSpeakWordsStr appendFormat:@"%@",self.noAnswerArr[arc4random()%self.noAnswerArr.count]];
        }
        if ([self.mySpeakWordsStr isEqualToString:@"(null)"])
        {
            self.mySpeakWordsStr = nil;
            [self.mySpeakWordsStr appendFormat:@"%@",@".#$$#$#$%."];
        }
        
        [self speechWithWords:self.aiSpeakWordsStr];//speech
        
        NSString *tempAiSpeakStr = [NSString stringWithFormat:@"%@",self.aiSpeakWordsStr];
        NSLog(@"----- mySpeakWordsStr %@",self.mySpeakWordsStr);
        NSLog(@"----- tempMySpeakStr %@",tempAiSpeakStr);
        NSLog(@"----- aiSpeakStr %@",self.aiSpeakWordsStr);
        
//        [self postDataToFireBase];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mySpeakDataArr addObject:[NSString stringWithFormat:@"%@",self.mySpeakWordsStr]];
            if (answerDic)
            {
                [self.aiSpeaktDataArr addObject:[NSString stringWithFormat:@"%@",self.aiSpeakWordsStr]];
            }else
            {
                [self.aiSpeaktDataArr addObject:[NSString stringWithFormat:@"%@😓",self.aiSpeakWordsStr]];
            }
         
            [self.tableView reloadData];
            
            //滚动
            if (self.tableView.contentSize.height > self.tableView.bounds.size.height)
            {
                [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height -self.tableView.bounds.size.height) animated:YES];
            }
            
        });
    }
    
 
}


/**
 音量变化回调
 volume 录音的音量，音量范围0~30
 ****/
- (void)onVolumeChanged:(int)volume
{
//    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
//    NSLog(@"-----语音识别onVolumeChanged %@",vol);

    [self.startAIChatView startWaveWithVolume:volume+5];;
    
    
}

/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech
{
    NSLog(@"-----语音识别 onBeginOfSpeech ");
}

#pragma mark -
#pragma mark --- postDataToFireBase
//- (void)postDataToFireBase
//{
//    NSString *dateStr = [FGProjectHelper logTimeStringFromDate:[NSDate date]];
//    [self.dataBaseRef.childByAutoId updateChildValues:@{
//                                                @"MySpeak":[NSString stringWithFormat:@"%@: %@",dateStr,self.mySpeakWordsStr],
//                                                @"AISpeak":[NSString stringWithFormat:@"%@: %@",dateStr,self.aiSpeakWordsStr]
//                                                }withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
//                                                    if (error) {
//                                                        NSLog(@"-----error %@ %@ %@",error,ref.key,ref.URL);
//                                                        return ;
//                                                    }
//                                                }];
//
//}

#pragma mark -
#pragma mark --- postStoregeData
//- (void)postStoregeDataWithImage:(UIImage*)image
//{
//
//    NSData *imageData = UIImageJPEGRepresentation(image, 1);
//
//    FIRStorageUploadTask *dataTask = [self.storageRef putData:imageData];
//    [dataTask observeStatus:FIRStorageTaskStatusProgress handler:^(FIRStorageTaskSnapshot * _Nonnull snapshot) {
//
////        [self.view makeToast:[NSString stringWithFormat:@"上传进度:%.2f%%", (float)snapshot.progress.completedUnitCount / (float)snapshot.progress.totalUnitCount*100
////                              ]];
//    }];
//    [dataTask observeStatus:FIRStorageTaskStatusSuccess handler:^(FIRStorageTaskSnapshot * _Nonnull snapshot) {
//        [self.view makeToast:@"上传成功"];
//    }];
//    [dataTask observeStatus:FIRStorageTaskStatusFailure handler:^(FIRStorageTaskSnapshot * _Nonnull snapshot) {
//        [self.view makeToast:@"上传失败"];
//    }];
//
//}

#pragma mark -
#pragma mark --- UIScrollviewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

#pragma mark -
#pragma mark --- UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mySpeakDataArr.count + self.aiSpeaktDataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row%2 ? FGChatCellUserTypeOther:FGChatCellUserTypeMyself) == FGChatCellUserTypeMyself)
    {
        if (self.mySpeakDataArr.count > 0)
        {
            wordsStr = self.mySpeakDataArr[indexPath.row/2];
        }
    }else
    {
        if (self.aiSpeaktDataArr.count>0)
        {
           wordsStr = self.aiSpeaktDataArr[(indexPath.row-1)/2];
        }
    }
    strOfRect = [FGProjectHelper stringRect:wordsStr fontSize:15 constraintWidth:CHART_WORDS_WIDTH-16 constraintHeight:1000];
    return CGRectGetHeight(strOfRect) > 18? CGRectGetHeight(strOfRect)+40+20:30+45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row%2 ? FGChatCellUserTypeOther:FGChatCellUserTypeMyself) == FGChatCellUserTypeMyself)
    {
        static NSString *myChatReuseId = @"MyChatCell";
        FGMySpeakTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myChatReuseId];
        if (!cell)
        {
            cell = [[FGMySpeakTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myChatReuseId];
            cell.mySpeakDelegate = self;
            mySelfCell = cell;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.mySpeakDataArr.count > 0)
        {
            [cell updateViewWithContens:self.mySpeakDataArr[indexPath.row/2]];
        }
        return cell;
    }else
    {
        static NSString *reuseId = @"AIChatCell";
        FGAIChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (!cell)
        {
            cell = [[FGAIChatTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            cell.aiChatCellDelegate = self;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.aiSpeaktDataArr.count>0)
        {
            [cell updateViewWithContens:self.aiSpeaktDataArr[(indexPath.row-1)/2]];
        }
        return cell;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
