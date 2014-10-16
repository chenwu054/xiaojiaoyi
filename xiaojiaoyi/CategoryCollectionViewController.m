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

-(UINavigationBar *)navigationBar
{
    if(!_navigationBar){
        _navigationBar = [[UINavigationBar alloc] init];
    }
    _navigationBar.frame = CGRectMake(0,0,self.view.frame.size.width,60);
    UINavigationItem * item = [[UINavigationItem alloc] init];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self.mainVC action:@selector(backToCenterViewFromCategoryView)];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"main page" style:UIBarButtonItemStylePlain target:self.mainVC action:@selector(backToCenterViewFromCategoryView)];

    item.leftBarButtonItem = leftBarButton;
    item.rightBarButtonItem = rightBarButton;
    item.title = @"Category";
    _navigationBar.items = @[item];
    _navigationBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:255 alpha:1];
    
    return _navigationBar;
}
-(void)setBackgroundColor:(UIColor*)color
{
    UIColor *newColor = [UIColor colorWithRed:(arc4random()%256)/256.0 green:(arc4random()%256)/256.0 blue:(arc4random()%256)/256.0 alpha:1.0];
    //NSLog(@"color: %@",newColor);
    self.view.backgroundColor = newColor;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    //_parentView = [[GestureView alloc] init];
    //_parentView.frame = [UIScreen mainScreen].bounds;
    //[self.view addSubview:_parentView];
    
    [self navigationBar];
    [self.view addSubview:_navigationBar];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

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
