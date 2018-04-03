//
//  TJLBaseViewController.m
//  Pods
//
//  Created by TongJialin on 16/7/31.
//
//

#import "TJLBaseViewController.h"

@interface TJLBaseViewController ()

@end

@implementation TJLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setNavigationBarStatus];
}

- (void)setNavigationBarStatus {
    self.navigationController.navigationBar.barTintColor = [UIColor darkTextColor];;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    self.navigationController.navigationBar.topItem.title = @"";
}

- (void)setupTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 44.0)];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    
    self.navigationItem.titleView = label;
}




@end
