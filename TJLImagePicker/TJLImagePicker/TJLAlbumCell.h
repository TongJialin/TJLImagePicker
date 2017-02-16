//
//  TJLAlbumCell.h
//  PhotoManagement
//
//  Created by Oma-002 on 17/1/13.
//  Copyright © 2017年 com.oma.matec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJLAlbumCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

+ (UINib *)cellNib;

+ (NSString *)cellIdentifier;

@end
