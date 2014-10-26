//
//  TestCoreDataViewController.m
//  xiaojiaoyi
//
//  Created by chen on 10/23/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "TestCoreDataViewController.h"

@interface TestCoreDataViewController ()
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic) DataModalUtils* utils;
@property (nonatomic) NSManagedObjectContext* context;
@property (nonatomic) NSFetchedResultsController* fetchedResultsController;

@end

@implementation TestCoreDataViewController
-(NSManagedObjectContext*)context
{
    if(!_context){
        _context=[self.utils getMyDealsContextWithUserId:@"user123"];
    }
    return _context;
}
-(DataModalUtils*)utils
{
    if(!_utils){
        _utils=[DataModalUtils sharedInstance];
    }
    return _utils;
}

- (IBAction)leftButtonClicked:(id)sender
{
    
    Deal* deal = [NSEntityDescription insertNewObjectForEntityForName:@"Deal" inManagedObjectContext:self.context];
    deal.title=@"newDeal";
    deal.price=@254;
    deal.exchange=@YES;
    deal.shipping=@NO;
    deal.dealId=@125;
    NSDate *today = [NSDate date];
    deal.create_date=today;
    deal.expire_date=[today dateByAddingTimeInterval:86400];
    deal.insured=@YES;
    
    deal.describe=@"this is a description for the deal";
    if(![self.context save:NULL]){
        NSLog(@"save error");
    }
    
    NSLog(@"context is %@",self.context);
}

- (IBAction)rightButtonClicked:(id)sender
{
    NSEntityDescription* entityDescribe = [NSEntityDescription entityForName:@"Deal" inManagedObjectContext:self.context];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];//[NSFetchRequest fetchRequestWithEntityName:@"Deal"];
    [request setEntity:entityDescribe];
    NSSortDescriptor* sortDescriptor=[[NSSortDescriptor alloc] initWithKey:@"create_date" ascending:NO];
//    request.fetchBatchSize=5;
    request.fetchLimit=20;
    request.predicate=nil;
    request.sortDescriptors=@[sortDescriptor];
    NSError* error;
    NSLog(@"request is %@",request);
    NSArray* deals = [self.context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"there is an error");
    }
    for(Deal *deal in deals){
        NSLog(@"deal is %@",deal.create_date);
    }
//    NSLog(@"count is %ld",deals.count);
//    if(deals.count>0){
//        //nil;
//        Deal* deal = deals[0];
//        deal.create_date=[NSDate date];
//        NSLog(@"date is %@",[NSDate date]);
//        //[self.utils deleteMyDeal:[deals firstObject] FromUserId:@"user123"];
//    }
}


-(void)setup
{
    [self context];
    //[self.utils addNotificationForUserId:@"user123"];
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
