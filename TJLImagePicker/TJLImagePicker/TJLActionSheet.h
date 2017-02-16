//
//  TJLActionSheet.h
//  PhotoManagement
//
//  Created by Oma-002 on 17/2/13.
//  Copyright © 2017年 com.oma.matec. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TJLActionSheet;

typedef void(^TJLActionSheetBlock)(NSInteger buttonIndex);


#pragma mark - Delegate

@protocol TJLActionSheetDelegate <NSObject>

@optional

/**
 *  点击了 buttonIndex 处的按钮
 */
- (void)actionSheet:(TJLActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex;

@end


#pragma mark - LCActionSheet

@interface TJLActionSheet : UIView

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger redButtonIndex;

@property (nonatomic, copy) TJLActionSheetBlock clickedBlock;

/**
 *  Localized cancel text. Default is "取消"
 */
@property (nonatomic, strong) NSString *cancelText;

/**
 *  Default is [UIFont systemFontOfSize:18]
 */
@property (nonatomic, strong) UIFont *textFont;

/**
 *  Default is Black
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 *  Default is 0.3 seconds
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 *  Opacity of background, default is 0.3f
 */
@property (nonatomic, assign) CGFloat backgroundOpacity;



#pragma mark - Delegate Way

/**
 *  返回一个 ActionSheet 对象, 类方法
 *
 *  @param title          提示标题
 *  @param buttonTitles   所有按钮的标题
 *  @param redButtonIndex 红色按钮的 index
 *  @param delegate       代理
 *
 *  Tip: 如果没有红色按钮, redButtonIndex 给 `-1` 即可
 */
+ (instancetype)sheetWithTitle:(NSString *)title
                  buttonTitles:(NSArray *)buttonTitles
                redButtonIndex:(NSInteger)redButtonIndex
                      delegate:(id<TJLActionSheetDelegate>)delegate;

/**
 *  返回一个 ActionSheet 对象, 实例方法
 *
 *  @param title          提示标题
 *  @param buttonTitles   所有按钮的标题
 *  @param redButtonIndex 红色按钮的 index
 *  @param delegate       代理
 *
 *  Tip: 如果没有红色按钮, redButtonIndex 给 `-1` 即可
 */
- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
               redButtonIndex:(NSInteger)redButtonIndex
                     delegate:(id<TJLActionSheetDelegate>)delegate;




#pragma mark - Block Way

/**
 *  返回一个 ActionSheet 对象, 类方法
 *
 *  @param title          提示标题
 *  @param buttonTitles   所有按钮的标题
 *  @param redButtonIndex 红色按钮的 index
 *  @param clicked        点击按钮的 block 回调
 *
 *  Tip: 如果没有红色按钮, redButtonIndex 给 `-1` 即可
 */
+ (instancetype)sheetWithTitle:(NSString *)title
                  buttonTitles:(NSArray *)buttonTitles
                redButtonIndex:(NSInteger)redButtonIndex
                       clicked:(TJLActionSheetBlock)clicked;

/**
 *  返回一个 ActionSheet 对象, 实例方法
 *
 *  @param title          提示标题
 *  @param buttonTitles   所有按钮的标题
 *  @param redButtonIndex 红色按钮的 index
 *  @param clicked        点击按钮的 block 回调
 *
 *  Tip: 如果没有红色按钮, redButtonIndex 给 `-1` 即可
 */
- (instancetype)initWithTitle:(NSString *)title
                 buttonTitles:(NSArray *)buttonTitles
               redButtonIndex:(NSInteger)redButtonIndex
                      clicked:(TJLActionSheetBlock)clicked;



#pragma mark - Custom Way

/**
 Add a button with callback block

 @param button buttonTitle
 */
- (void)addButtonTitle:(NSString *)button;


- (void)setTextColor:(UIColor *)textColor forButtonIndex:(NSInteger)index;


#pragma mark - Show

/**
 *  显示 ActionSheet
 */
- (void)show;

@end
