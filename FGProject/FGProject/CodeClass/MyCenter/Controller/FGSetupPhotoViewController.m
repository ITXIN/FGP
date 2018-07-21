//
//  FGSetupPhotoViewController.m
//  FGProject
//
//  Created by avazuholding on 2017/11/18.
//  Copyright © 2017年 bert. All rights reserved.
//

#import "FGSetupPhotoViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+SGHelper.h"
@interface FGSetupPhotoViewController
()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)  UIButton *albumBtn;
@property (nonatomic,strong)  UIButton *takePhotBtn;
@property (nonatomic,strong) NSMutableArray *imagesArr;
@property (nonatomic,strong) NSData *imageData;
//@property (nonatomic,strong) OPAYLoadingImageStateView *loadingStateView;
@end

@implementation FGSetupPhotoViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = HEX_ARGB(@"#f6f6f6");
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.imageData = [NSData data];
    self.imagesArr = [NSMutableArray array];
    
//    [OPAYProjectHelper setupNavigationWithController:self callBack:@selector(leftBarButtonAction:)];
//    [self initUI];
}


- (void)initSubviews{
    [super initSubviews];
    self.view.transform = CGAffineTransformMakeRotation(-M_PI*0.5);
    self.view.frame = CGRectMake(0, 0,kScreenWidth,kScreenHeight );
    
//    _imageView.frame = self.view.bounds;
    self.iconView =  ({
        UIImageView *image = [[UIImageView alloc]init];
        [self.bgView addSubview:image];
        
        [image setContentMode:UIViewContentModeScaleAspectFill];
        image.clipsToBounds = YES;
        image.backgroundColor = [UIColor whiteColor];
        image;
    });
    

    
    self.albumBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view  addSubview:btn];
        btn.tag = 1000;
        [btn addTarget:self action:@selector(setPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"使用相册" forState:UIControlStateNormal];
//        [btn setupEnable:YES];
        
        
        btn;
    });
    
    self.takePhotBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.bgView  addSubview:btn];
        btn.tag = 1001;
        [btn addTarget:self action:@selector(setPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"拍照" forState:UIControlStateNormal];
        [btn setTitleColor:RGB(26, 153, 252) forState:UIControlStateNormal];
//                [btn setBackgroundImage:[OPAYProjectHelper imageFromColor:RGB(255, 255, 255) rect:CGRectMake(0, 0, 1, 1)] forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor whiteColor];
//        [btn setBackgroundImage:[UIImage imageNamed:@"take_photo_noraml"] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"take_photo_click"] forState:UIControlStateHighlighted];
        btn.contentEdgeInsets = UIEdgeInsetsMake(-10,0, 0, 0);
        
        btn;
    });
}


- (void)setPhotoAction:(UIButton*)sender{
    
    __block NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if (sender.tag == 1000) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self changeIconWithSourceType:sourceType];
    }else if (sender.tag == 1001){
        sourceType = UIImagePickerControllerSourceTypeCamera;
        [self changeIconWithSourceType:sourceType];
        
    }
}

- (void)changeIconWithSourceType:(NSUInteger)sourceType
{
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        //相机权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
            authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
        {
            
#warning 相机权限申请有待于统一
            // 无权限 引导去开启
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if ([[UIApplication sharedApplication]canOpenURL:url]) {
                
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GUIDANCE_CAMERA_CONTENT",nil) message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    if ([[UIApplication sharedApplication]canOpenURL:url]) {
                        [[UIApplication sharedApplication]openURL:url];
                    }
                    
                }];
                UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"DO_NOT_ALLOW",nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertC addAction:alertCancel];
                [alertC addAction:alertA];
                
                [self presentViewController:alertC animated:YES completion:nil];
            }
            
            
            
        }else if (authStatus == AVAuthorizationStatusNotDetermined){
            
            [self accessImagePickerController:sourceType];
            
        }else if (authStatus == AVAuthorizationStatusAuthorized){
            [self accessImagePickerController:sourceType];
            
        }
    }else if(sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        //相册权限
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (device) {
            PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
            if (status == PHAuthorizationStatusNotDetermined) {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusAuthorized) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self accessImagePickerController:sourceType];
                        });
                    }else{
                        FGLOG(@"-----拒绝访问 ");
                    }
                }];
            }else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前应用访问相册
                FGLOG(@"-----PHAuthorizationStatusAuthorized ");
                [self accessImagePickerController:sourceType];
                
            } else if (status == PHAuthorizationStatusDenied){
                FGLOG(@"-----PHAuthorizationStatusDenied ");
                // 无权限 引导去开启
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication]canOpenURL:url]) {
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"GUIDANCE_ALBUM_CONTENT",nil) message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
                    UIAlertAction *alertA = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        if ([[UIApplication sharedApplication]canOpenURL:url]) {
                            [[UIApplication sharedApplication]openURL:url];
                        }
                        
                    }];
                    UIAlertAction *alertCancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"DO_NOT_ALLOW",nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alertC addAction:alertCancel];
                    [alertC addAction:alertA];
                    
                    [self presentViewController:alertC animated:YES completion:nil];
                    
                }
                
            }else if (status == PHAuthorizationStatusRestricted) {
                FGLOG(@"-----PHAuthorizationStatusRestricted ");
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"NO_ACCESS_WITH_SYSTEM_REASONS", nil) message:@"" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                    
                }];
                
                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
                
                
            }
            
        }
        
        
    }
    
    
}


- (void)accessImagePickerController:(NSUInteger)sourceType{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
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
    //    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    // 获取标准正方形图片
//    editedImage = [editedImage cropCenterMaxSquareArea];
    // 图片压缩至目标尺寸
//    UIImage *userImage = [editedImage scaleToSize:CGSizeMake(750, 750)];
    UIImage *userImage = editedImage;
    [picker dismissViewControllerAnimated:YES completion:^{
        
        self.iconView.image = userImage;
        [self.imagesArr removeAllObjects];
        [self.imagesArr addObject:userImage];
        self.imageData = UIImageJPEGRepresentation(userImage, 0.5);
       
        
    }];
    
}


- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.navigationView.mas_bottom).offset(30);
//        make.left.mas_equalTo(30);
//        make.right.mas_equalTo(-30);
        make.centerX.equalTo(self.bgView);
        make.size.mas_equalTo(CGSizeMake(200, 200));
    }];
    
    [self.albumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
    }];
    
    [self.takePhotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.albumBtn.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
        //        make.trailing.equalTo(self.view).offset(-40);
        //        make.leading.equalTo(self.view).offset(40);
        //        make.height.mas_equalTo(48);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
