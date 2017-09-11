//
//  TJLImagePickerController.m
//  PhotoManagement
//
//  Created by Oma-002 on 17/1/12.
//  Copyright © 2017年 com.oma.matec. All rights reserved.
//

#import "TJLImagePickerController.h"
#import "TJLAlbumsViewController.h"
#import "TJLGridViewController.h"
#import "TJLCameraViewController.h"
#import <Photos/Photos.h>

@interface TJLImagePickerController ()

@property (nonatomic, strong) NSMutableArray *imageArray;

/**
 获取相册图片数组成功后的回调
 */
@property (nonatomic, strong) TJLPicPickerSuccessedHanlder successedHandler;

/**
 获取拍照图片成功后的回调
 */
@property (nonatomic, strong) TJLTakePhotoSuccessedHanlder takePhotoSuccessedHandler;

@end

@implementation TJLImagePickerController

static TJLImagePickerController *helper;

+ (instancetype) sharedInstance {
    @synchronized (self) {
        if (!helper){
            helper = [[self alloc] init];
        }
    }
    return helper;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized (self) {
        if (!helper) {
            helper = [super allocWithZone:zone];
            return helper;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotification];
}

#pragma mark --- notification

- (void)registerNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction:) name:@"assetsArray" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takePhotoNotification:) name:@"cameraImage" object:nil];
}

- (void)notificationAction:(NSNotification *)notification {
    [self.imageArray removeAllObjects];
    NSDictionary *dict = notification.userInfo;
    NSMutableArray *assetsArray = [dict objectForKey:@"assetsArray"];
    
    __weak typeof(self) weakSelf = self;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    for (PHAsset *asset in assetsArray) {
        [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [weakSelf.imageArray addObject:result];
        }];
    }
    
    if (self.successedHandler) {
        self.successedHandler(self.imageArray);
    }
}

- (void)takePhotoNotification:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    UIImage *image = [dict objectForKey:@"image"];
    if (self.takePhotoSuccessedHandler) {
        self.takePhotoSuccessedHandler(image);
    }
}

- (void)dealloc {
    [self removeNotification];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"assetsArray" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cameraImage" object:nil];
}

#pragma mark --- 获取相册照片的方法

- (void)showPickerInController:(UIViewController *)vc successBlock:(TJLPicPickerSuccessedHanlder)succeedHandler {
    
    [self showPickerInController:vc total:9 successBlock:succeedHandler];
}

- (void)showPickerInController:(UIViewController *)vc total:(NSInteger)total successBlock:(TJLPicPickerSuccessedHanlder)succeedHandler {
    
    //检查是否有相册访问权限
    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (status == PHAuthorizationStatusAuthorized) {
                        
                        self.successedHandler = succeedHandler;
                        
                        [self setupPickerNavigationController:vc tatal:total];
                        
                    } else {
                        [self photoAlertView];
                    }
                });
            }];
        }
            break;
        case PHAuthorizationStatusAuthorized:
        {
            self.successedHandler = succeedHandler;
            
            [self setupPickerNavigationController:vc tatal:total];
        }
            break;
            
        default:
            [self photoAlertView];
            break;
    }
}

- (void)showCameraInController:(UIViewController *)vc successBlock:(TJLTakePhotoSuccessedHanlder)succeedHandler {
    
    //检查是否有相机访问权限
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusNotDetermined:
        case AVAuthorizationStatusAuthorized:
        {
            self.takePhotoSuccessedHandler = succeedHandler;
            
            [self setupCameraNavigationController:vc];
        }
            break;
            
        default:
            [self cameraAlertView];
            break;
    }
}

- (void)setupPickerNavigationController:(UIViewController *)vc tatal:(NSInteger)total {
    
    [vc.navigationController presentViewController:self animated:YES completion:nil];
    
    TJLAlbumsViewController *albumsViewController = [[TJLAlbumsViewController alloc] init];
    TJLGridViewController *gridViewController = [[TJLGridViewController alloc] init];
    gridViewController.total = total;
    [self setViewControllers:@[albumsViewController, gridViewController]];
}

- (void)setupCameraNavigationController:(UIViewController *)vc {
    
    [vc.navigationController presentViewController:self animated:YES completion:nil];
    
    TJLCameraViewController *cameraViewController = [[TJLCameraViewController alloc] init];
    [self setViewControllers:@[cameraViewController]];
}

- (void)photoAlertView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该应用没有访问相册的权限，您可以在设置中修改该配置" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)cameraAlertView {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该应用没有访问相机的权限，您可以在设置中修改该配置" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --- get

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] init];
    }
    return _imageArray;
}

@end
