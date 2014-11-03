//
//  SettingsViewController.m
//  xiaojiaoyi
//
//  Created by chen on 11/2/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)back:(UIButton*)sender
{
    NSLog(@"calling back");
    [self.mainVC customPopViewController];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton setTitle:@"back" forState:UIControlStateNormal];
    backButton.backgroundColor=[UIColor lightGrayColor];
    [self.navigationController setNavigationBarHidden:NO];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
