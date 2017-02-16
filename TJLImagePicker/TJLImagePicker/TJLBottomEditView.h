//
//  TJLBottomEditView.h
//  PhotoManagement
//
//  Created by Oma-002 on 17/1/18.
//  Copyright © 2017年 com.oma.matec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJLBottomEditView : UIView

@property (strong, nonatomic) UIButton *chooseButton;

- (void)setButtonTitleColorNormal:(NSInteger)count;

- (void)setButtonTitleColorHighlighted:(NSInteger)count;

@end
