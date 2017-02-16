//
//  TJLAlbumCell.m
//  PhotoManagement
//
//  Created by Oma-002 on 17/1/13.
//  Copyright © 2017年 com.oma.matec. All rights reserved.
//

#import "TJLAlbumCell.h"

@implementation TJLAlbumCell

+ (UINib *)cellNib {
    return [UINib nibWithNibName:[self cellIdentifier] bundle:[NSBundle mainBundle]];
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
