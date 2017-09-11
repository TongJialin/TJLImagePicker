//
//  TJLActionSheet.m
//  PhotoManagement
//
//  Created by Oma-002 on 17/2/13.
//  Copyright © 2017年 com.oma.matec. All rights reserved.
//

#import "TJLActionSheet.h"

// 按钮高度
#define BUTTON_H 49.0f
// 屏幕尺寸
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

#define OMA_ACTION_SHEET_TITLE_FONT  [UIFont systemFontOfSize:18.0f]

#define OMA_DEFAULT_ANIMATION_DURATION 0.2f

#define OMA_DEFAULT_BACKGROUND_OPACITY 0.4f

@interface TJLActionSheet ()

/** 所有按钮 */
@property (nonatomic, strong) NSMutableArray *buttonTitles;

/** 暗黑色的view */
@property (nonatomic, strong) UIView *darkView;

/** 所有按钮的底部view */
@property (nonatomic, strong) UIView *bottomView;

/** 代理 */
@property (nonatomic, weak) id<TJLActionSheetDelegate> delegate;


@property (nonatomic, strong) UIWindow *backWindow;



@end

@implementation TJLActionSheet

#pragma mark - getter

- (NSString *)cancelText
{
    if (!_cancelText) {
        _cancelText = @"取消";
    }
    
    return _cancelText;
}

- (UIFont *)textFont
{
    if (!_textFont) {
        _textFont = OMA_ACTION_SHEET_TITLE_FONT;
    }
    
    return _textFont;
}

- (UIColor *)textColor
{
    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    
    return _textColor;
}

- (CGFloat)animationDuration {
    if (!_animationDuration) {
        _animationDuration = OMA_DEFAULT_ANIMATION_DURATION;
    }
    
    return _animationDuration;
}

- (CGFloat)backgroundOpacity {
    if (!_backgroundOpacity) {
        _backgroundOpacity = OMA_DEFAULT_BACKGROUND_OPACITY;
    }
    
    return _backgroundOpacity;
}

#pragma mark - methods
+ (instancetype)sheetWithTitle:(NSString *)title buttonTitles:(NSArray *)buttonTitles redButtonIndex:(NSInteger)redButtonIndex delegate:(id<TJLActionSheetDelegate>)delegate {
    
    return [[self alloc] initWithTitle:title buttonTitles:buttonTitles redButtonIndex:redButtonIndex delegate:delegate];
}

+ (instancetype)sheetWithTitle:(NSString *)title buttonTitles:(NSArray *)buttonTitles redButtonIndex:(NSInteger)redButtonIndex clicked:(TJLActionSheetBlock)clicked {
    
    return [[self alloc] initWithTitle:title buttonTitles:buttonTitles redButtonIndex:redButtonIndex clicked:clicked];
}

- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
               redButtonIndex:(NSInteger)redButtonIndex
                     delegate:(id<TJLActionSheetDelegate>)delegate {
    
    if (self = [super init]) {
        
        self.title = title;
        self.buttonTitles = [[NSMutableArray alloc] initWithArray:buttonTitles];
        self.redButtonIndex = redButtonIndex;
        self.delegate = delegate;
    }
    
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
               redButtonIndex:(NSInteger)redButtonIndex
                      clicked:(TJLActionSheetBlock)clicked {
    
    if (self = [super init]) {
        
        self.title = title;
        self.buttonTitles = [[NSMutableArray alloc] initWithArray:buttonTitles];
        self.redButtonIndex = redButtonIndex;
        self.clickedBlock = clicked;
    }
    
    return self;
}

- (void)setupMainView {
    
    // 暗黑色的view
    UIView *darkView = [[UIView alloc] init];
    [darkView setAlpha:0];
    [darkView setUserInteractionEnabled:NO];
    [darkView setFrame:(CGRect){0, 0, SCREEN_SIZE}];
    [darkView setBackgroundColor:[UIColor colorWithRed:0.16 green:0.16 blue:0.16 alpha:1]];
    [self addSubview:darkView];
    _darkView = darkView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [darkView addGestureRecognizer:tap];
    
    // 所有按钮的底部view
    UIView *bottomView = [[UIView alloc] init];
    [bottomView setBackgroundColor:[UIColor colorWithRed:0.96 green:0.96 blue:0.97 alpha:1]];
    _bottomView = bottomView;
    
    if (self.title) {
        
        CGFloat vSpace = 0;
        CGSize titleSize = [self.title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0f]}];
        if (titleSize.width > SCREEN_SIZE.width - 30.0f) {
            vSpace = 15.0f;
        }
        
        UIView *titleBgView = [[UIView alloc] init];
        titleBgView.backgroundColor = [UIColor whiteColor];
        titleBgView.frame = CGRectMake(0, -vSpace, SCREEN_SIZE.width, BUTTON_H + vSpace);
        [bottomView addSubview:titleBgView];
        
        // 标题
        UILabel *label = [[UILabel alloc] init];
        [label setText:self.title];
        
        [label setNumberOfLines:2.0f];
        [label setTextColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:[UIFont systemFontOfSize:13.0f]];
        [label setBackgroundColor:[UIColor whiteColor]];
        [label setFrame:CGRectMake(15.0f, 0, SCREEN_SIZE.width - 30.0f, titleBgView.frame.size.height)];
        [titleBgView addSubview:label];
    }
    
    if (self.buttonTitles.count) {
        
        for (int i = 0; i < self.buttonTitles.count; i++) {
            
            // 所有按钮
            UIButton *btn = [[UIButton alloc] init];
            [btn setTag:i];
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn setTitle:self.buttonTitles[i] forState:UIControlStateNormal];
            [[btn titleLabel] setFont:self.textFont];
            UIColor *titleColor = nil;
            if (i == self.redButtonIndex) {
                
                titleColor = [UIColor colorWithRed:0.86 green:0.11 blue:0.11 alpha:1];
                
            } else {
                
                titleColor = self.textColor ;
            }
            [btn setTitleColor:titleColor forState:UIControlStateNormal];
            
            UIImage *bgImage = [UIImage imageNamed:@"bgImage_HL@2x.png"];
            
            
            [btn setBackgroundImage:bgImage forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat btnY = BUTTON_H * (i + (self.title ? 1 : 0));
            [btn setFrame:CGRectMake(0, btnY, SCREEN_SIZE.width, BUTTON_H)];
            [bottomView addSubview:btn];
        }
        
        for (int i = 0; i < self.buttonTitles.count; i++) {
            
            UIImage *lineImage = [UIImage imageNamed:@"cellLine@2x.png"];
            
            // 所有线条
            UIImageView *line = [[UIImageView alloc] init];
            [line setImage:lineImage];
            [line setContentMode:UIViewContentModeTop];
            CGFloat lineY = (i + (self.title ? 1 : 0)) * BUTTON_H;
            [line setFrame:CGRectMake(0, lineY, SCREEN_SIZE.width, 1.0f)];
            [bottomView addSubview:line];
        }
    }
    
    UIImage *bgImage = [UIImage imageNamed:@"bgImage_HL@2x.png"];
    
    // 取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTag:self.buttonTitles.count];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn setTitle:self.cancelText forState:UIControlStateNormal];
    [[cancelBtn titleLabel] setFont:self.textFont];
    [cancelBtn setTitleColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:bgImage forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(didClickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat btnY = BUTTON_H * (self.buttonTitles.count + (self.title ? 1 : 0)) + 10.0f;
    [cancelBtn setFrame:CGRectMake(0, btnY, SCREEN_SIZE.width, BUTTON_H)];
    [bottomView addSubview:cancelBtn];
    
    CGFloat bottomH = (self.title ? BUTTON_H : 0) + BUTTON_H * self.buttonTitles.count + BUTTON_H + 5.0f;
    [bottomView setFrame:CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, bottomH)];
    
    [self setFrame:(CGRect){0, 0, SCREEN_SIZE}];
}

- (UIWindow *)backWindow {
    
    if (_backWindow == nil) {
        
        _backWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backWindow.windowLevel       = UIWindowLevelStatusBar;
        _backWindow.backgroundColor   = [UIColor clearColor];
        _backWindow.hidden = NO;
    }
    
    return _backWindow;
}


- (void)didClickBtn:(UIButton *)btn {
    
    [self dismiss:nil];
    
    if ([_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
        
        [_delegate actionSheet:self didClickedButtonAtIndex:btn.tag];
    }
    
    if (self.clickedBlock) {
        
        self.clickedBlock(btn.tag);
    }
}

- (void)dismiss:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [_darkView setAlpha:0];
        [_darkView setUserInteractionEnabled:NO];
        
        CGRect frame = _bottomView.frame;
        frame.origin.y += frame.size.height;
        [_bottomView setFrame:frame];
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
        self.backWindow.hidden = YES;
    }];
}

- (void)didClickCancelBtn {
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [_darkView setAlpha:0];
        [_darkView setUserInteractionEnabled:NO];
        
        CGRect frame = _bottomView.frame;
        frame.origin.y += frame.size.height;
        [_bottomView setFrame:frame];
        
    } completion:^(BOOL finished) {
        
        if ([_delegate respondsToSelector:@selector(actionSheet:didClickedButtonAtIndex:)]) {
            
            [_delegate actionSheet:self didClickedButtonAtIndex:self.buttonTitles.count];
        }
        
        if (self.clickedBlock) {
            
            __weak typeof(self) weakSelf = self;
            self.clickedBlock(weakSelf.buttonTitles.count);
        }
        
        [self removeFromSuperview];
        
        self.backWindow.hidden = YES;
    }];
}

- (void)show {
    [self setupMainView];
    self.backWindow.hidden = NO;
    
    [self addSubview:self.bottomView];
    [self.backWindow addSubview:self];
    
    [UIView animateWithDuration:self.animationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        [_darkView setAlpha:self.backgroundOpacity];
        [_darkView setUserInteractionEnabled:YES];
        
        CGRect frame = _bottomView.frame;
        frame.origin.y -= frame.size.height;
        [_bottomView setFrame:frame];
        
    } completion:nil];
}

- (void)addButtonTitle:(NSString *)button
{
    if (!_buttonTitles) {
        _buttonTitles = [[NSMutableArray alloc] init];
    }
    
    [_buttonTitles addObject:button];
}

- (void)setTextColor:(UIColor *)textColor forButtonIndex:(NSInteger)index {
    NSArray *array = [self.bottomView subviews];
    for (UIButton *btn in array) {
        if (btn.tag == index) {
            [btn setTitleColor:textColor forState:UIControlStateNormal];
        }
    }
}

@end

