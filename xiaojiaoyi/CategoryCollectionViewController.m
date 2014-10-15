//
//  CategoryCollectionViewController.m
//  xiaojiaoyi
//
//  Created by chen on 10/14/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "CategoryCollectionViewController.h"

@interface CategoryCollectionViewController ()

@end

@implementation CategoryCollectionViewController


-(CategoryCollectionViewController*)initWithBackgroundColor:(UIColor*)color
{
    self=[super init];
    if(self){
        self.view.backgroundColor = color;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.view.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.5];
    //self.view.frame = CGRectMake(0, 0, 320, 568);
    //self.view.bounds = CGRectMake(0, 0, 320, 568);
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
