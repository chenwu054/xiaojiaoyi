//
//  UserMenuController.m
//  xiaojiaoyi
//
//  Created by chen on 10/3/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "UserMenuController.h"

#define TABLEVIEW_CELL_HEIGHT 50.0
#define SLIDE_PANEL_WIDTH 40.0

@interface UserMenuController ()



@property (nonatomic) NSArray *userMenuList;

@end

@implementation UserMenuController


-(void)loadUserMenuPropertyList
{
    if(!_userMenuList){
        NSString *userMenuPathString = [[NSBundle mainBundle] pathForResource:@"UserMenuCategory" ofType:@"plist"];
        _userMenuList = [[NSArray alloc] initWithContentsOfFile:userMenuPathString];
    }
   // NSLog(@"the category list is %@",_userMenuList);
    
}
-(void)initUserMenuTable
{
    
    if(!_userMenuTableView){
        CGRect tableViewFrame = CGRectMake(0, self.view.frame.size.height - TABLEVIEW_CELL_HEIGHT * _userMenuList.count, self.containerView.frame.size.width, TABLEVIEW_CELL_HEIGHT * _userMenuList.count);
        _userMenuTableView =[[UITableView alloc] initWithFrame:tableViewFrame];
        _userMenuTableView.dataSource = self;
        _userMenuTableView.backgroundColor=[UIColor clearColor];
        //not scrollable
        _userMenuTableView.scrollEnabled = NO;
        
        [_containerView addSubview:_userMenuTableView];
        
    }
    
}
#pragma mark - table view methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [_userMenuTableView dequeueReusableCellWithIdentifier:@"userMenuTableViewCell"];
    if(!cell){
        cell = [[UITableViewCell alloc] init];
        //set text
        cell.textLabel.text = _userMenuList[indexPath.row];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        //set image
        cell.imageView.image = [UIImage imageNamed:@"home60.png"];
        //cell.imageView.frame = CGRectMake(0, 0, 20,20);
        
        //to set background color to transparent
        //need to set both cell and tableView background to clear color
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLEVIEW_CELL_HEIGHT;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _userMenuList.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //_containerView.frame = CGRectMake(100, 0, _containerView.frame.size.width, _containerView.frame.size.height);
    //[self.view addSubview:_containerView];
    [self loadUserMenuPropertyList];
    
    [self initUserMenuTable];
//    NSLog(@"UserMainView self.view is %@",self.view);
//    NSArray *subviews = [self.view subviews];
//    
//    for(int i=0;i<subviews.count;i++){
//        NSLog(@"UserMainView subview %d is %@",i,subviews[i]);
//    }
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
