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
@end

@implementation TestCoreDataViewController
-(NSManagedObjectContext*)context
{
    if(!_context){
        _context=[self.utils getMyDealsContextWithFilename:@"user123"];
    }
    return _context;
}
-(DataModalUtils*)utils
{
    if(!_utils){
        _utils=[[DataModalUtils alloc] init];
    }
    return _utils;
}
- (IBAction)leftButtonClicked:(id)sender
{
    //NSString* filename=@"user123";
//    UIManagedDocument* doc = [self.utils getMyDealsDocumentWithFileName:filename];
    //NSManagedObjectContext* context = [self.utils getMyDealsContextWithFilename:filename];
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
    NSString* filename=@"user123";
    //UIManagedDocument* doc = [self.utils getMyDealsDocumentWithFileName:filename];
    //NSManagedObjectContext* context = [self.utils getMyDealsContextWithFilename:filename];
    //NSLog(@"context is %@",context);
    //NSSortDescriptor* sortDescriptor=[NSSortDescriptor sortDescriptorWithKey:@"create_date" ascending:NO];
    //NSPredicate* predicate = [NSPredicate predicateWithFormat:@"title = %@",@"newDeal"];
    NSEntityDescription* entityDescribe = [NSEntityDescription entityForName:@"Deal" inManagedObjectContext:self.context];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];//[NSFetchRequest fetchRequestWithEntityName:@"Deal"];
    //NSFetchRequest* request=[NSFetchRequest fetchRequestWithEntityName:@"Deal"];
    [request setEntity:entityDescribe];
    
//    request.fetchBatchSize=5;
    request.fetchLimit=20;
    request.predicate=nil;
    //request.sortDescriptors=@[sortDescriptor];
    NSError* error;
    NSLog(@"request is %@",request);
    NSArray* deals = [self.context executeFetchRequest:request error:&error];
    if(error){
        NSLog(@"there is an error");
    }
    NSLog(@"deals is %@",deals);
    for(Deal *deal in deals){
        NSLog(@"deal is %@",deal.describe);
    }
    //NSLog(@"coordinator is %@",context.persistentStoreCoordinator.managedObjectModel);
    //NSLog(@"parent context is %@",context.parentContext);
}



- (void)viewDidLoad
{
    [super viewDidLoad];
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
