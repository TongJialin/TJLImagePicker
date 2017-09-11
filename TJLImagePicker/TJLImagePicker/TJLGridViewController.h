//
//  TJLGridViewController.h
//  PhotoManagement
//
//  Created by Oma-002 on 17/1/12.
//  Copyright © 2017年 com.oma.matec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJLBaseViewController.h"
#import <Photos/Photos.h>

@interface TJLGridViewController : TJLBaseViewController

@property (strong, nonatomic) NSString *navTitle;

@property (strong, nonatomic) PHFetchResult *assetsFetchResults;

@property (assign, nonatomic) NSInteger total;

@end
