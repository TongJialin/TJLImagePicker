//
//  TJLPreviewViewController.m
//  PhotoManagement
//
//  Created by Oma-002 on 17/1/17.
//  Copyright © 2017年 com.oma.matec. All rights reserved.
//

#import "TJLPreviewViewController.h"

#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface TJLPreviewViewController ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation TJLPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.imageView];
    [[PHCachingImageManager defaultManager] requestImageForAsset:self.asset targetSize:CGSizeMake(WIDTH, HEIGHT) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.imageView.image = result;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end
