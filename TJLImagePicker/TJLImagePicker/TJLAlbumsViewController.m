//
//  TJLAlbumsViewController.m
//  PhotoManagement
//
//  Created by Oma-002 on 17/1/12.
//  Copyright © 2017年 com.oma.matec. All rights reserved.
//

#import "TJLAlbumsViewController.h"
#import <Photos/Photos.h>
#import "TJLAlbumCell.h"
#import "TJLGridViewController.h"

#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

static int kAlbumRowHeight = 56;

@interface TJLAlbumsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) PHAsset *asset;

@property (assign, nonatomic) NSInteger assetCount;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) PHCachingImageManager *imageManager;

@property (strong, nonatomic) NSMutableArray *smartFetchResultArray;

@property (strong, nonatomic) NSMutableArray *smartFetchResultTitlt;

@property (strong, nonatomic) PHFetchOptions *options;

@end

@implementation TJLAlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTitle:@"照片"];
    [self addRightBarButton];
    [self setTableViewDetail];
    [self getPhotos];
    [self.view setBackgroundColor:[UIColor blackColor]];
}

- (void)addRightBarButton {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClicked:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)rightBarButtonClicked:(UIBarButtonItem *)sender {
    [self dismiss];
}

- (void)setTableViewDetail {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[TJLAlbumCell cellNib] forCellReuseIdentifier:[TJLAlbumCell cellIdentifier]];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)getAlbums {
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHCollection *collection in smartAlbums) {
        
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            
            switch (assetCollection.assetCollectionSubtype) {
                case PHAssetCollectionSubtypeSmartAlbumAllHidden:
                    
                    break;
                    
                case PHAssetCollectionSubtypeSmartAlbumUserLibrary: {
                    
                    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:self.options];
                    
                    [self.smartFetchResultArray insertObject:assetsFetchResult atIndex:0];
                    [self.smartFetchResultTitlt insertObject:collection.localizedTitle atIndex:0];
                    
                }
                    break;
                default: {
                    
                    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:self.options];
                    
                    [self.smartFetchResultArray addObject:assetsFetchResult];
                    [self.smartFetchResultTitlt addObject:collection.localizedTitle];
                    
                }
                    break;
            }
        }
    }
}

- (void)getPhotos {
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHCollection *collection in smartAlbums) {
        
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            
            switch (assetCollection.assetCollectionSubtype) {
                    
                case PHAssetCollectionSubtypeSmartAlbumUserLibrary: {
                    
                    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:self.options];
                    
                    NSMutableArray *assetsArray = [[NSMutableArray alloc] init];
                    for (PHAsset *asset in assetsFetchResult) {
                        if (asset.mediaType == PHAssetMediaTypeImage) {
                            [assetsArray addObject:asset];
                        }
                    }
                    
                    [self.smartFetchResultArray insertObject:assetsArray atIndex:0];
                    [self.smartFetchResultTitlt insertObject:collection.localizedTitle atIndex:0];
                    
                }
                    break;
                    
                case PHAssetCollectionSubtypeSmartAlbumFavorites:
                case PHAssetCollectionSubtypeSmartAlbumRecentlyAdded:
                case PHAssetCollectionSubtypeSmartAlbumSelfPortraits:
                case PHAssetCollectionSubtypeSmartAlbumScreenshots:
                case PHAssetCollectionSubtypeSmartAlbumBursts:
                case PHAssetCollectionSubtypeSmartAlbumPanoramas: {
                    
                    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:self.options];
                    
                    NSMutableArray *assetsArray = [[NSMutableArray alloc] init];
                    for (PHAsset *asset in assetsFetchResult) {
                        if (asset.mediaType == PHAssetMediaTypeImage) {
                            [assetsArray addObject:asset];
                        }
                    }
                    
                    [self.smartFetchResultArray addObject:assetsArray];
                    [self.smartFetchResultTitlt addObject:collection.localizedTitle];
                    
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --- tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.smartFetchResultArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kAlbumRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TJLAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:[TJLAlbumCell cellIdentifier] forIndexPath:indexPath];
    
    PHFetchResult *fetchResult = self.smartFetchResultArray[indexPath.row];
    cell.countLabel.text = [NSString stringWithFormat:@"（%lu）",(unsigned long)fetchResult.count];
    
    if (fetchResult.count > 0) {
        PHAsset *asset = fetchResult[fetchResult.count - 1];
        
        [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(kAlbumRowHeight, kAlbumRowHeight) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            cell.albumImageView.image = result;
        }];
    } else {
        cell.albumImageView.image = [UIImage imageNamed:@"blank"];
    }
    
    cell.nameLabel.text = self.smartFetchResultTitlt[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    TJLGridViewController *gridViewController = [[TJLGridViewController alloc] init];
    gridViewController.navTitle = self.smartFetchResultTitlt[indexPath.row];
    gridViewController.assetsFetchResults = self.smartFetchResultArray[indexPath.row];
    [self.navigationController pushViewController:gridViewController animated:YES];
}

#pragma mark --- dismiss

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- get

- (PHCachingImageManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [[PHCachingImageManager alloc] init];
    }
    return _imageManager;
}

- (NSMutableArray *)smartFetchResultArray {
    if (!_smartFetchResultArray) {
        _smartFetchResultArray = [[NSMutableArray alloc] init];
    }
    return _smartFetchResultArray;
}

- (NSMutableArray *)smartFetchResultTitlt {
    if (!_smartFetchResultTitlt) {
        _smartFetchResultTitlt = [[NSMutableArray alloc] init];
    }
    return _smartFetchResultTitlt;
}

- (PHFetchOptions *)options {
    if (!_options) {
        _options = [[PHFetchOptions alloc] init];
        _options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    }
    return _options;
}

@end
