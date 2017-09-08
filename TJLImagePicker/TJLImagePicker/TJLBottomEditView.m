//
//  TJLBottomEditView.m
//  PhotoManagement
//
//  Created by Oma-002 on 17/1/18.
//  Copyright © 2017年 com.oma.matec. All rights reserved.
//

#import "TJLBottomEditView.h"
#import "UIColor+Hex.h"

#define WIDTH [[UIScreen mainScreen] bounds].size.width
#define HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface TJLBottomEditView ()

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UILabel *editLabel;

@property (strong, nonatomic) UILabel *previewLabel;

@property (strong, nonatomic) UILabel *selectedCountLabel;

@end

@implementation TJLBottomEditView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lineView];
        [self addSubview:self.chooseButton];
        [self addSubview:self.selectedCountLabel];
    }
    return self;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 0.5)];
        _lineView.backgroundColor = [UIColor hexString:@"bfbfbf"];
    }
    return _lineView;
}

- (UIButton *)chooseButton {
    if (!_chooseButton) {
        _chooseButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 55, 14, 45, 16)];
        [_chooseButton setTitleColor:[UIColor hexString:@"b4e2b9"] forState:UIControlStateNormal];
        _chooseButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_chooseButton setTitle:@"选择" forState:UIControlStateNormal];
    }
    return _chooseButton;
}

- (void)setButtonTitleColorNormal:(NSInteger)count {
    if (count == 0) {
        self.selectedCountLabel.hidden = YES;
        [self.chooseButton setTitleColor:[UIColor hexString:@"b4e2b9"] forState:UIControlStateNormal];
    } else {
        self.selectedCountLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
        self.selectedCountLabel.transform = CGAffineTransformMakeScale(0.5, 0.5);
        [self selectLabelAnimation];
    }
}

- (void)setButtonTitleColorHighlighted:(NSInteger)count {
    [self.chooseButton setTitleColor:[UIColor hexString:@"09bb07"] forState:UIControlStateNormal];
    
    self.selectedCountLabel.hidden = NO;
    self.selectedCountLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
    [self selectLabelAnimation];
}

- (void)selectLabelAnimation {
    self.selectedCountLabel.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:8 options:UIViewAnimationOptionCurveLinear animations:^{
        self.selectedCountLabel.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (UILabel *)selectedCountLabel {
    if (!_selectedCountLabel) {
        _selectedCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 73, 11, 20, 20)];
        _selectedCountLabel.textColor = [UIColor whiteColor];
        _selectedCountLabel.backgroundColor = [UIColor hexString:@"09bb07"];
        _selectedCountLabel.textAlignment = NSTextAlignmentCenter;
        _selectedCountLabel.layer.masksToBounds = YES;
        _selectedCountLabel.layer.cornerRadius = 10;
        _selectedCountLabel.font = [UIFont systemFontOfSize:16];
        _selectedCountLabel.hidden = YES;
    }
    return _selectedCountLabel;
}

@end
