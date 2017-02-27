//
//  TJLGridCollectionCell.h
//  PhotoManagement
//
//  Created by Oma-002 on 17/1/13.
//  Copyright © 2017年 com.oma.matec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJLGridCollectionCell;

@protocol TJLGridCollectionCellDelegate <NSObject>

- (void)didPreviewAssetsViewCell:(TJLGridCollectionCell *)assetsCell;

- (void)didSelectItemAssetsViewCell:(TJLGridCollectionCell *)assetsCell;

- (void)didDeselectItemAssetsViewCell:(TJLGridCollectionCell *)assetsCell;

@end

@interface TJLGridCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *gridImageView;

@property (weak, nonatomic) IBOutlet UIView *checkView;

@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@property (assign, nonatomic) id<TJLGridCollectionCellDelegate> delegate;

+ (UINib *)cellNib;

+ (NSString *)cellIdentifier;

- (void)reduceCheckImage;

@end
