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
    
//    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
//    self.navigationItem.backBarButtonItem = backbutton;
}

- (void)setNavigationBarStatus {
    UINavigationBar *ngBar = [UINavigationBar appearance];
    
    ngBar.barTintColor = [UIColor darkTextColor];;
    ngBar.tintColor = [UIColor whiteColor];
    ngBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    ngBar.topItem.title = @"";
//    [ngBar setShadowImage:[OMAUtil imageWithColor:OMACOLOR_THEME_ORANGE]];
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
