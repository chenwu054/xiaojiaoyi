//
//  CenterTabBuddyDealController.m
//  xiaojiaoyi
//
//  Created by chen on 10/4/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "CenterTabBuddyDealController.h"

@interface CenterTabBuddyDealController ()

@end

@implementation CenterTabBuddyDealController

-(void)setup
{
    self.view.backgroundColor = [UIColor greenColor];
    self.view.frame = CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height);
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
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
