//
//  ViewController.m
//  PhotoManagement
//
//  Created by Oma-002 on 17/1/10.
//  Copyright © 2017年 com.oma.matec. All rights reserved.
//

#import "ViewController.h"
#import "TJLActionSheet.h"
#import "TJLImagePickerController.h"
#import "TJLGridCollectionCell.h"
#import "TJLCameraViewController.h"

static NSInteger kGridItemNumberOfColumns = 4;
static CGFloat kGridSpace = 4;
static CGFloat kCollectionItemHeight;
static CGSize kCollectionItemSize;
static CGSize kCollectionPhotoItemSize;

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *imageArray;

@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        kCollectionItemHeight = (WIDTH - (kGridItemNumberOfColumns + 1) * kGridSpace) / kGridItemNumberOfColumns;
        kCollectionItemSize = CGSizeMake(kCollectionItemHeight, kCollectionItemHeight);
        kCollectionPhotoItemSize = CGSizeMake(kCollectionItemHeight * 1.2, kCollectionItemHeight * 1.2);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitle:@"主页"];
    [self addPhotoButton];
    [self setCollectionViewDetail];
}

- (void)addPhotoButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30, HEIGHT - 120, WIDTH - 60, 45)];
    [button setTitle:@"选择照片" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor ] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClicked:(UIButton *)sender {
    self.imageArray = nil;
    
    __weak typeof(self) weakSelf = self;
    
    TJLActionSheet *sheet = [[TJLActionSheet alloc] initWithTitle:nil buttonTitles:@[@"拍照", @"从相册选择"] redButtonIndex:2 clicked:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            [[TJLImagePickerController sharedInstance] showCameraInController:self successBlock:^(UIImage *image) {
                weakSelf.imageArray = @[image];
                [weakSelf.collectionView reloadData];
            }];
        } else if (buttonIndex == 1) {
            [[TJLImagePickerController sharedInstance] showPickerInController:self successBlock:^(NSArray *imageArray) {
                weakSelf.imageArray = imageArray;
                [weakSelf.collectionView reloadData];
            }];
        }
    }];
    [sheet show];
    
}

- (void)setCollectionViewDetail {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[TJLGridCollectionCell cellNib] forCellWithReuseIdentifier:[TJLGridCollectionCell cellIdentifier]];
    [self.view addSubview:self.collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --- Collection

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TJLGridCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:[TJLGridCollectionCell cellIdentifier] forIndexPath:indexPath];
    cell.checkImageView.hidden = YES;
    cell.gridImageView.image = self.imageArray[indexPath.item];
    
    return cell;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = kCollectionItemSize;
        layout.minimumLineSpacing = kGridSpace;
        layout.minimumInteritemSpacing = kGridSpace;
        layout.sectionInset = UIEdgeInsetsMake(kGridSpace, kGridSpace, kGridSpace, kGridSpace);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT / 2.0) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView setContentOffset:CGPointMake(0, (kCollectionItemHeight + kGridSpace) * (self.imageArray.count / 4)) animated:YES];
    }
    return _collectionView;
}

- (NSArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [[NSArray alloc] init];
    }
    return _imageArray;
}

@end
