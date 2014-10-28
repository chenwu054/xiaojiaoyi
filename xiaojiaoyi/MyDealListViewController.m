//
//  MyDealListViewController.m
//  xiaojiaoyi
//
//  Created by chen on 10/25/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "MyDealListViewController.h"

#define TAB_BAR_HEIGHT 50
#define TAB_BAR_OFFSET 10
#define CELL_IMAGE_WIDTH 100
#define CELL_HEIGHT 90
#define CELL_HEIGHT_MARGIN 10
#define CELL_WIDTH_MARGIN 10
#define EDIT_BUTTON_WIDTH 80

#define CELL_IMAGE_HEIGHT 50
#define CELL_IMAGE_CORNER_RADIUS 5

@interface MyDealListViewController ()
@property (nonatomic) UITableView *tableView;

@property (nonatomic) DataModalUtils* utils;
@property (nonatomic) NSMutableArray* dealList;
@property (nonatomic) NSManagedObjectContext* context;
@property (nonatomic) NSFetchRequest* request;
@property (nonatomic) NSPredicate* predicate;
@property (nonatomic) NSSortDescriptor* dateSortDescriptor;
@property (nonatomic) BOOL userHasChanged;

@property (nonatomic) NSFetchedResultsController* fetchedResultsController;

@end

@implementation MyDealListViewController
@synthesize userId = _userId;
#pragma mark - fetched results controller methods
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    //[self.tableView beginUpdates];
    NSLog(@"fetched controller will change content");
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    NSLog(@"did change object");
//    UITableView *tableView = self.tableView;
//    
//    switch(type) {
//            
//        case NSFetchedResultsChangeInsert:
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeUpdate:
//            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
//            break;
//            
//        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:[NSArray
//                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [tableView insertRowsAtIndexPaths:[NSArray
//                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    NSLog(@"controller did change section ");
//    switch(type) {
//            
//        case NSFetchedResultsChangeInsert:
//            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    NSLog(@"controller did change content");
    //[self.tableView endUpdates];
}

#pragma mark - table view methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"calling cell");
    UITableViewCell* cell =[tableView dequeueReusableCellWithIdentifier:@"MyDealListCell"];
    if(!cell){
        cell=[[UITableViewCell alloc] init];
        Deal* deal = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        UIView* containerView=[[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, CELL_HEIGHT-20)];
        
        containerView.layer.borderColor=[[UIColor orangeColor] CGColor];
        containerView.layer.borderWidth=2;
        containerView.layer.cornerRadius=10.0;
        containerView.layer.shadowOffset=CGSizeMake(-1, 1);
        containerView.layer.shadowOpacity=0.7;
        containerView.backgroundColor=[UIColor whiteColor];
        containerView.layer.backgroundColor=[[UIColor whiteColor] CGColor];
        containerView.layer.masksToBounds=YES;//make UIImage contrained in the bounds of UIImageView.frame (rounded corner)
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELL_IMAGE_WIDTH,containerView.frame.size.height)];
        imageView.layer.cornerRadius=CELL_IMAGE_CORNER_RADIUS*2;
        //imageView.layer.borderColor=[[UIColor darkGrayColor] CGColor];
        //imageView.layer.borderWidth=1;
        imageView.image=[UIImage imageNamed:@"linkedin.jpg"];
        //imageView.layer.masksToBounds=YES;//make UIImage contrained in the bounds of UIImageView.frame (rounded corner)
        [containerView addSubview:imageView];
        
        //title subview
        UIView* titleView=[[UIView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + CELL_IMAGE_WIDTH, 0, containerView.frame.size.width- (imageView.frame.origin.x + CELL_IMAGE_WIDTH), containerView.frame.size.height/3)];
        UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, titleView.frame.size.width - 5, titleView.frame.size.height)];
        NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"title: %@",deal.title] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:14.0],NSForegroundColorAttributeName:[UIColor grayColor]}];
        title.attributedText=attributedString;
        [titleView addSubview:title];
        [containerView addSubview:titleView];
        
        //condition subview
        UIView*conditionView = [[UIView alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + CELL_IMAGE_WIDTH, containerView.frame.size.height/3, containerView.frame.size.width- (imageView.frame.origin.x + CELL_IMAGE_WIDTH), containerView.frame.size.height/3)];
        UILabel* priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, conditionView.frame.size.height)];
        priceLabel.attributedText=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"$%@",deal.price] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:13.0],NSForegroundColorAttributeName:[UIColor grayColor]}];

        UIImageView* shippingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(priceLabel.frame.size.width, 0, 30, conditionView.frame.size.height)];
        shippingImageView.layer.cornerRadius=CELL_IMAGE_CORNER_RADIUS*2;
        shippingImageView.image=[UIImage imageNamed:@"delivery.png"];
        shippingImageView.backgroundColor=deal.shipping?[UIColor orangeColor]:[UIColor lightGrayColor];
        
        UIImageView* exchangeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(shippingImageView.frame.origin.x+shippingImageView.frame.size.width + 5, 0, 30, conditionView.frame.size.height)];
        exchangeImageView.layer.cornerRadius=CELL_IMAGE_CORNER_RADIUS*2;
        exchangeImageView.image=[UIImage imageNamed:@"exchange.png"];
        exchangeImageView.backgroundColor=deal.exchange?[UIColor orangeColor]:[UIColor lightGrayColor];
        
        UILabel* conditionLabel = [[UILabel alloc] initWithFrame:CGRectMake(exchangeImageView.frame.origin.x+exchangeImageView.frame.size.width + 3, 0, conditionView.frame.size.width-(exchangeImageView.frame.origin.x+exchangeImageView.frame.size.width), conditionView.frame.size.height)];
        conditionLabel.attributedText=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"condition:%@",deal.condition?deal.condition:@"<80%"] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:13.0],NSForegroundColorAttributeName:[UIColor grayColor]}];
        
        [conditionView addSubview:priceLabel];
        [conditionView addSubview:shippingImageView];
        [conditionView addSubview:exchangeImageView];
        [conditionView addSubview:conditionLabel];
        [containerView addSubview:conditionView];
        
        //description subview
        UILabel* descriptionLabel=[[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + CELL_IMAGE_WIDTH, conditionView.frame.origin.y+conditionView.frame.size.height, conditionView.frame.size.width, containerView.frame.size.height/3)];
        descriptionLabel.attributedText=[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",deal.describe] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:12.0],NSForegroundColorAttributeName:[UIColor grayColor]}];
        [containerView addSubview:descriptionLabel];
        
        
        //[cell addSubview:containerView];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UIView* editView = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.size.width-2*EDIT_BUTTON_WIDTH, CELL_HEIGHT_MARGIN, 2*EDIT_BUTTON_WIDTH, CELL_HEIGHT-2*CELL_HEIGHT_MARGIN)];
        editView.layer.cornerRadius=10.0;
        UIButton* repostButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, EDIT_BUTTON_WIDTH, CELL_HEIGHT-2*CELL_HEIGHT_MARGIN)];
        [repostButton setBackgroundColor:[UIColor greenColor]];
        [repostButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"repost" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:20],NSForegroundColorAttributeName:[UIColor grayColor]}] forState:UIControlStateNormal];
        [editView addSubview:repostButton];
        UIButton* deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(EDIT_BUTTON_WIDTH, 0, EDIT_BUTTON_WIDTH, CELL_HEIGHT-2*CELL_HEIGHT_MARGIN)];
        [deleteButton setBackgroundColor:[UIColor redColor]];
        [deleteButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"delete" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:20],NSForegroundColorAttributeName:[UIColor grayColor]}] forState:UIControlStateNormal];
        [editView addSubview:deleteButton];
        [cell addSubview:editView];
        
        EditTableCellView* hideEditView = [[EditTableCellView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, CELL_HEIGHT)];
        hideEditView.indexPath=indexPath;
        hideEditView.initialCenter=CGPointMake(cell.frame.size.width/2, CELL_HEIGHT/2);
        hideEditView.backgroundColor=[UIColor whiteColor];
        [cell addSubview:hideEditView];
//        UIPanGestureRecognizer* panCell=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cellPanned:)];
//        [hideEditView addGestureRecognizer:panCell];
//        UISwipeGestureRecognizer* swipeCell = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwiped:)];
//        swipeCell.direction=UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
        
        //[hideEditView addGestureRecognizer:swipeCell];
        
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedCell:)];
        //[hideEditView addGestureRecognizer:longPress];
        [hideEditView addSubview:containerView];
        //[cell addSubview:containerView];
        
    }
    return cell;
}
-(void)longPressedCell:(UILongPressGestureRecognizer*)gesture
{
    if([gesture.view isKindOfClass:[EditTableCellView class]]){
        
        EditTableCellView* view = (EditTableCellView*)gesture.view;
        
        //CGPoint translation = [gesture translationInView:view];
        if(gesture.state==UIGestureRecognizerStateBegan){
            //view.center = CGPointMake(self.view.frame.size.width/2+translation.x<0?translation.x:0, view.center.y);
            //view.backgroundColor=[UIColor clearColor];
            NSLog(@"long press began");
        }
        else if(gesture.state==UIGestureRecognizerStateChanged){
            NSLog(@"long press began");
//            if(view.initialCenter.x>100){
//                view.center = CGPointMake(self.view.frame.size.width/2+(translation.x<0?translation.x:0), view.center.y);
//            }
//            else{
//                view.center=CGPointMake(view.initialCenter.x+translation.x<self.view.frame.size.width/2?translation.x:self.view.frame.size.width/2, view.center.y);
//            }
//            view.backgroundColor=[UIColor colorWithWhite:1.0 alpha:view.center.x/(self.view.frame.size.width/2) ];
//            //NSLog(@"x=%f,y=%f,self.view.frame.size.width/2=%f",view.center.x,view.center.y,self.view.frame.size.width/2);
            
        }
        else if(gesture.state==UIGestureRecognizerStateEnded){
            if(view.center.x<self.view.frame.size.width/2-EDIT_BUTTON_WIDTH-CELL_WIDTH_MARGIN){
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    view.center=CGPointMake(self.view.frame.size.width/2-(2*EDIT_BUTTON_WIDTH) + CELL_WIDTH_MARGIN, view.center.y);
                    
                } completion:nil];
                view.initialCenter=CGPointMake(self.view.frame.size.width/2-(2*EDIT_BUTTON_WIDTH) + CELL_WIDTH_MARGIN, view.center.y);
            }
            else{
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    
                    view.center=CGPointMake(self.view.frame.size.width/2, view.center.y);
                } completion:nil];
                view.initialCenter=CGPointMake(self.view.frame.size.width/2, view.center.y);
                view.backgroundColor=[UIColor whiteColor];
            }
            
        }
    }
}
-(void)cellSwiped:(UISwipeGestureRecognizer*)gesture
{
    NSLog(@"calling swipe recognizer");
    if([gesture.view isKindOfClass:[EditTableCellView class]]){
        
        EditTableCellView* view = (EditTableCellView*)gesture.view;
        
        if(gesture.direction==UISwipeGestureRecognizerDirectionLeft){
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                view.center=CGPointMake(self.view.frame.size.width/2-(2*EDIT_BUTTON_WIDTH) + CELL_WIDTH_MARGIN, view.center.y);
                
            } completion:nil];
        }
        else if(gesture.direction==UISwipeGestureRecognizerDirectionRight){
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                
                view.center=CGPointMake(self.view.frame.size.width/2, view.center.y);
            } completion:nil];
        }
        
    }
    
}
-(void)cellPanned:(UIPanGestureRecognizer*)gesture
{
    if([gesture.view isKindOfClass:[EditTableCellView class]]){
        
        EditTableCellView* view = (EditTableCellView*)gesture.view;
        
        CGPoint translation = [gesture translationInView:view];
        if(gesture.state==UIGestureRecognizerStateBegan){
            //view.center = CGPointMake(self.view.frame.size.width/2+translation.x<0?translation.x:0, view.center.y);
            //view.backgroundColor=[UIColor clearColor];
        
        }
        else if(gesture.state==UIGestureRecognizerStateChanged){
            if(view.initialCenter.x>100){
                view.center = CGPointMake(self.view.frame.size.width/2+(translation.x<0?translation.x:0), view.center.y);
            }
            else{
                view.center=CGPointMake(view.initialCenter.x+translation.x<self.view.frame.size.width/2?translation.x:self.view.frame.size.width/2, view.center.y);
            }
            view.backgroundColor=[UIColor colorWithWhite:1.0 alpha:view.center.x/(self.view.frame.size.width/2) ];
            //NSLog(@"x=%f,y=%f,self.view.frame.size.width/2=%f",view.center.x,view.center.y,self.view.frame.size.width/2);
            
        }
        else if(gesture.state==UIGestureRecognizerStateEnded){
            if(view.center.x<self.view.frame.size.width/2-EDIT_BUTTON_WIDTH-CELL_WIDTH_MARGIN){
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    view.center=CGPointMake(self.view.frame.size.width/2-(2*EDIT_BUTTON_WIDTH) + CELL_WIDTH_MARGIN, view.center.y);
                    
                } completion:nil];
                view.initialCenter=CGPointMake(self.view.frame.size.width/2-(2*EDIT_BUTTON_WIDTH) + CELL_WIDTH_MARGIN, view.center.y);
            }
            else{
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    
                    view.center=CGPointMake(self.view.frame.size.width/2, view.center.y);
                } completion:nil];
                view.initialCenter=CGPointMake(self.view.frame.size.width/2, view.center.y);
                view.backgroundColor=[UIColor whiteColor];
            }

        }
    }
    
    //NSLog(@"gesture view is %@",view);
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"calling height for cell");
    return CELL_HEIGHT;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSLog(@"selected cell");
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id what = [self.fetchedResultsController.sections objectAtIndex:section];
    NSLog(@"wha is %@",what);
    NSInteger rows = [what numberOfObjects];
    NSLog(@"calling number of rows method %ld",rows);
    return rows;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

#pragma mark - setup
- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        _fetchedResultsController=[[NSFetchedResultsController alloc] initWithFetchRequest:self.request managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}

-(NSFetchRequest*)request
{
    if(!_request){
        _request = [[NSFetchRequest alloc]init];
        NSEntityDescription* entity = [NSEntityDescription entityForName:@"Deal" inManagedObjectContext:self.context];
        [_request setEntity:entity];
        _request.fetchBatchSize=20;
        _request.sortDescriptors=@[self.dateSortDescriptor];
    }
    return _request;
}
-(NSSortDescriptor*)dateSortDescriptor
{
    if(!_dateSortDescriptor){
        _dateSortDescriptor=[[NSSortDescriptor alloc] initWithKey:@"create_date" ascending:NO];
    }
    return _dateSortDescriptor;
}
                    
-(NSPredicate*)predicate
{
    if(!_predicate){
        _predicate=[[NSPredicate alloc] init];
    }
    return _predicate;
}

-(NSManagedObjectContext*)context
{
    if(!_context){
        _context=[self.utils getMyDealsContextWithUserId:self.userId];
        
    }
    return _context;
}
-(void)fetchDealsFromCoreData
{
    
}
-(NSString*)userId
{
    if(!_userId){
        _userId=@"user123"; //this is for development;
    }
    return _userId;
}
-(void)setUserId:(NSString *)userId
{
    _userId=userId;
    //update context;
    self.context=[self.utils getMyDealsContextWithUserId:_userId];
}
-(UITableView*)tableView
{
    if(!_tableView){
        _tableView=[[UITableView alloc] init];
        _tableView.frame=CGRectMake(0, TAB_BAR_HEIGHT + TAB_BAR_OFFSET ,self.view.frame.size.width,300);
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        //[_tableView setEditing:YES animated:YES];
        
        UIImageView* backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, _tableView.frame.size.height)];
        backgroundView.image=[UIImage imageNamed:@"linkedin.jpg"];
        //_tableView.backgroundView = backgroundView;
        
    }
    return _tableView;
}
-(DataModalUtils*) utils
{
    if(!_utils){
        _utils = [DataModalUtils sharedInstance];
    }
    return _utils;
}

-(void)setup
{
    [self.view addSubview:self.tableView];
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 400, 100, 50)];
    [button setBackgroundColor:[UIColor purpleColor]];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(void)buttonClicked:(UIButton*)sender
{
    NSLog(@"button clicked");
    [self.tableView reloadData];
    [self.fetchedResultsController performFetch:NULL];
}
#pragma  mark - life cycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    _userHasChanged=NO;
    self.view.backgroundColor=[UIColor redColor];


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
