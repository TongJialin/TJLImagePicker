//
//  TJLGridCollectionCell.m
//  PhotoManagement
//
//  Created by Oma-002 on 17/1/13.
//  Copyright © 2017年 com.oma.matec. All rights reserved.
//

#import "TJLGridCollectionCell.h"

@interface TJLGridCollectionCell ()

@property (assign, nonatomic) BOOL imageSelected;

@end

@implementation TJLGridCollectionCell

+ (UINib *)cellNib {
    return [UINib nibWithNibName:[self cellIdentifier] bundle:[NSBundle mainBundle]];
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.gridImageView setUserInteractionEnabled:YES];
    [self.checkView setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selected:)];
    [self.gridImageView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkSelected:)];
    [self.checkView addGestureRecognizer:tap2];
}

- (void)selected:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(didPreviewAssetsViewCell:)]) {
        [self.delegate didPreviewAssetsViewCell:self];
    }
}

- (void)checkSelected:(UITapGestureRecognizer *)tap {
    if (self.imageSelected) {
        self.imageSelected = NO;
        self.checkImageView.image = [UIImage imageNamed:@"grey"];
        
        if ([self.delegate respondsToSelector:@selector(didDeselectItemAssetsViewCell:)]) {
            [self.delegate didDeselectItemAssetsViewCell:self];
        }
        
    } else {
        self.imageSelected = YES;
        self.checkImageView.image = [UIImage imageNamed:@"green"];
        
        self.checkImageView.transform = CGAffineTransformMakeScale(0.6, 0.6);
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveLinear animations:^{
            self.checkImageView.transform = CGAffineTransformIdentity;
        } completion:nil];
        
        if ([self.delegate respondsToSelector:@selector(didSelectItemAssetsViewCell:)]) {
            [self.delegate didSelectItemAssetsViewCell:self];
        }
        
    }
}

- (void)reduceCheckImage {
    self.imageSelected = NO;
    self.checkImageView.image = [UIImage imageNamed:@"grey"];
    
    if ([self.delegate respondsToSelector:@selector(didDeselectItemAssetsViewCell:)]) {
        [self.delegate didDeselectItemAssetsViewCell:self];
    }
}

@end
