//
//  TJLCameraViewController.m
//  PhotoManagement
//
//  Created by Oma-002 on 17/2/10.
//  Copyright © 2017年 com.oma.matec. All rights reserved.
//

#import "TJLCameraViewController.h"
#import <AVFoundation/AVFoundation.h>

#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface TJLCameraViewController ()

@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) AVCaptureDevice *device;

@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;

@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) UIButton *exitButton;

@property (nonatomic, strong) UIButton *takePhotoButton;

@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIButton *chooseButton;

@property (nonatomic, strong) UIButton *switchCameraButton;

@property (nonatomic, assign) BOOL isUsingFrontFacingCamera;

@end

@implementation TJLCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isUsingFrontFacingCamera = NO;
    [self initAVCaptureSession];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if (self.session) {
        [self.session stopRunning];
    }
}

- (void)initAVCaptureSession {
    
    [self.device lockForConfiguration:nil];
    [self.device setFlashMode:AVCaptureFlashModeAuto];
    [self.device unlockForConfiguration];
    
    [self.stillImageOutput setOutputSettings:@{AVVideoCodecKey:AVVideoCodecJPEG}];
    
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    if ([self.session canAddOutput:self.stillImageOutput]) {
        [self.session addOutput:self.stillImageOutput];
    }
    
    [self addPreviewView];
    
    [self.exitButton addTarget:self action:@selector(exitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.takePhotoButton addTarget:self action:@selector(takePhotoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.switchCameraButton addTarget:self action:@selector(switchCameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addPreviewView {
    [self.view.layer addSublayer:self.previewLayer];
    [self.view addSubview:self.exitButton];
    [self.view addSubview:self.takePhotoButton];
    [self.view addSubview:self.switchCameraButton];
}

- (void)exitButtonClicked:(UIButton *)sender {
    [self dismiss];
}

- (void)takePhotoButtonClicked:(UIButton *)sender {
    [self.exitButton removeFromSuperview];
    [self.takePhotoButton removeFromSuperview];
    AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (!connection) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (!error) {
            NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            weakSelf.selectedImage = [UIImage imageWithData:jpegData];
            [weakSelf selectedPhotoAction:weakSelf.selectedImage];
        } else {
            NSLog(@"%@",[error localizedDescription]);
        }
    }];
}

- (void)selectedPhotoAction:(UIImage *)image {
    [self.previewLayer removeFromSuperlayer];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.imageView setImage:image];
    [self.view addSubview:self.imageView];
    
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH / 2 - 37, HEIGHT - 80 - 37, 74, 74)];
    [self.cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self.view addSubview:self.cancelButton];
    
    self.chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH / 2 - 37, HEIGHT - 80 - 37, 74, 74)];
    [self.chooseButton setImage:[UIImage imageNamed:@"white_circle"] forState:UIControlStateNormal];
    [self.view addSubview:self.chooseButton];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.cancelButton.frame = CGRectMake(WIDTH / 4 - 37, HEIGHT - 80 - 37, 74, 74);
        self.chooseButton.frame = CGRectMake(WIDTH / 4 * 3 - 37, HEIGHT - 80 - 37, 74, 74);
    } completion:^(BOOL finished) {
        [self.cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseButton addTarget:self action:@selector(chooseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)cancelButtonClicked:(UIButton *)sender {
    [self removeChooseView];
    [self addPreviewView];
}

- (void)chooseButtonClicked:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cameraImage" object:nil userInfo:@{@"image" : self.selectedImage}];
    [self dismiss];
}

- (void)removeChooseView {
    [self.imageView removeFromSuperview];
    [self.cancelButton removeFromSuperview];
    [self.chooseButton removeFromSuperview];
}

- (void)switchCameraButtonClicked:(UIButton *)sender {
    AVCaptureDevicePosition desiredPosition;
    if (self.isUsingFrontFacingCamera) {
        desiredPosition = AVCaptureDevicePositionBack;
    } else {
        desiredPosition = AVCaptureDevicePositionFront;
    }
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [self.previewLayer.session beginConfiguration];
            for (AVCaptureInput *oldInput in self.previewLayer.session.inputs) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            [self.previewLayer.session addInput:input];
            [self.previewLayer.session commitConfiguration];
            break;
        }
    }
    
    self.isUsingFrontFacingCamera = !self.isUsingFrontFacingCamera;
}

#pragma mark --- dismiss

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (AVCaptureDevice *)device {
    if (!_device) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

- (AVCaptureDeviceInput *)videoInput {
    if (!_videoInput) {
        NSError *error = nil;
        _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:&error];
    }
    return _videoInput;
}

- (AVCaptureStillImageOutput *)stillImageOutput {
    if (!_stillImageOutput) {
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    }
    return _stillImageOutput;
}

- (AVCaptureVideoPreviewLayer *)previewLayer {
    if (!_previewLayer) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
        [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        _previewLayer.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    }
    return _previewLayer;
}

- (UIButton *)exitButton {
    if (!_exitButton) {
        _exitButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH / 4 - 12, HEIGHT - 80, 25, 14)];
        [_exitButton setBackgroundImage:[UIImage imageNamed:@"pull_down"] forState:UIControlStateNormal];
    }
    return _exitButton;
}

- (UIButton *)takePhotoButton {
    if (!_takePhotoButton) {
        _takePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH / 2 - 37, HEIGHT - 80 - 37, 74, 74)];
        [_takePhotoButton setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    }
    return _takePhotoButton;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    }
    return _imageView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH / 2 - 37, HEIGHT - 80 - 37, 74, 74)];
        [_cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    }
    return _cancelButton;
}

- (UIButton *)chooseButton {
    if (!_chooseButton) {
        _chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH / 2 - 37, HEIGHT - 80 - 37, 74, 74)];
        [_chooseButton setImage:[UIImage imageNamed:@"white_circle"] forState:UIControlStateNormal];
    }
    return _chooseButton;
}

- (UIButton *)switchCameraButton {
    if (!_switchCameraButton) {
        _switchCameraButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 20 - 27, 40, 27, 22)];
        [_switchCameraButton setImage:[UIImage imageNamed:@"change_direction"] forState:UIControlStateNormal];
    }
    return _switchCameraButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
