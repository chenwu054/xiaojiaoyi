//
//  MyDealListViewController.m
//  xiaojiaoyi
//
//  Created by chen on 10/25/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "MyDealListViewController.h"
#define NAVIGATION_BAR_HEIGHT 60
#define TAB_BAR_HEIGHT 50
#define TAB_BAR_OFFSET 10
#define CELL_IMAGE_WIDTH 100
#define CELL_HEIGHT 90
#define CELL_HEIGHT_MARGIN 10
#define CELL_WIDTH_MARGIN 10
#define EDIT_BUTTON_WIDTH 80
#define CELL_EDIT_BACKGROUND_VIEW_WIDTH 50
#define CELL_IMAGE_HEIGHT 50
#define CELL_IMAGE_CORNER_RADIUS 5
#define FOOTER_VIEW_HEIGHT 50

#define PULLDOWN_VIEW_THRESHOLD 50
#define PULLDOWN_VIEW_HEIGHT 50

@interface MyDealListViewController ()


@property (nonatomic) DataModalUtils* utils;
@property (nonatomic) NSMutableArray* dealList;
@property (nonatomic) NSManagedObjectContext* context;
@property (nonatomic) NSFetchRequest* request;
@property (nonatomic) NSPredicate* predicate;
@property (nonatomic) NSSortDescriptor* dateSortDescriptor;
@property (nonatomic) BOOL userHasChanged;

@property (nonatomic) NSFetchedResultsController* fetchedResultsController;

@property (nonatomic) UIView* pullDownView;
@property (nonatomic) UIImageView* pullDownImageView;
@property (nonatomic) UILabel *pullDownInfoLabel;
@property (nonatomic) UILabel *pullDownTimeLabel;

@property (nonatomic) UIActivityIndicatorView* spinner;

@property (nonatomic) BOOL editingMode;
@property (nonatomic) DealObject* transferDealObject;

//@property (nonatomic) UINavigationController* navigationVC;
//@property (nonatomic) DealSummaryEditViewController* dealSummaryEditVC;

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
    NSLog(@"fetched view controller did change object");
    if(type==NSFetchedResultsChangeDelete){
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if(type==NSFetchedResultsChangeInsert){
        NSLog(@"insert new record!");
        
    }
    
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
    
    NSLog(@"controller did change section is only called when the entire section is changed ?!");
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
        
        NSURL* dealURL = [[[self.utils myDealsDataURL] URLByAppendingPathComponent:deal.deal_id] URLByAppendingPathComponent:@"photo0"];
        if([[NSFileManager defaultManager] fileExistsAtPath:dealURL.path isDirectory:NO]){
            imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:dealURL]];
        }
        else{
            //NSLog(@"deal has NO default image");
            //use default image
            imageView.image=[UIImage imageNamed:@"linkedin.jpg"];
        }
        
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
        [repostButton addTarget:self action:@selector(repostButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [editView addSubview:repostButton];
        UIButton* deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(EDIT_BUTTON_WIDTH, 0, EDIT_BUTTON_WIDTH, CELL_HEIGHT-2*CELL_HEIGHT_MARGIN)];
        [deleteButton setBackgroundColor:[UIColor redColor]];
        [deleteButton setAttributedTitle:[[NSAttributedString alloc] initWithString:@"delete" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial" size:20],NSForegroundColorAttributeName:[UIColor grayColor]}] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [editView addSubview:deleteButton];
        [cell addSubview:editView];
        
        EditTableCellView* hideEditView = [[EditTableCellView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, CELL_HEIGHT)];
        
        hideEditView.indexPath=indexPath;
        hideEditView.initialCenter=CGPointMake(cell.frame.size.width/2, CELL_HEIGHT/2);
        hideEditView.backgroundColor=[UIColor whiteColor];
        [cell addSubview:hideEditView];
        [hideEditView addSubview:containerView];
        
//        UIView* editBackgroundView=[[UIView alloc] initWithFrame:CGRectMake(-CELL_EDIT_BACKGROUND_VIEW_WIDTH, 0, CELL_EDIT_BACKGROUND_VIEW_WIDTH, CELL_HEIGHT)];
//        editBackgroundView.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.5];
//        
//        [hideEditView addSubview:editBackgroundView];
        
//        if(self.tableView.editing){
//            [self.tableView setEditing:YES];
//            NSLog(@"create cell during editing!");
//            [self tableView:self.tableView editingStyleForRowAtIndexPath:indexPath];
//            [self tableView:self.tableView canEditRowAtIndexPath:indexPath];
//            
//        }

//        if(self.editingMode){
//            UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cellPanned:)];
//            [hideEditView addGestureRecognizer:pan];
//        }
        
        //!!adding gesture recognizer does not work, because there are two conflicting pan gestures: the pan on the cell and the pan on the main view
        
//        UIPanGestureRecognizer* panCell=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cellPanned:)];
//        [hideEditView addGestureRecognizer:panCell];
        
        UISwipeGestureRecognizer* swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipedLeft:)];
        swipeLeft.direction=UISwipeGestureRecognizerDirectionLeft; //| UISwipeGestureRecognizerDirectionRight;
        UISwipeGestureRecognizer* swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipedRight:)];
        swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
        
        [hideEditView addGestureRecognizer:swipeLeft];
        [hideEditView addGestureRecognizer:swipeRight];
        //UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressedCell:)];
        //[hideEditView addGestureRecognizer:longPress];
    }
    return cell;
}
-(EditTableCellView*)findEditTableCellViewByCell:(UITableViewCell*)cell
{
    NSArray* subview = cell.subviews;
    UIView* editView = subview[0];
    while(![editView isKindOfClass:[EditTableCellView class]]){
        subview = editView.subviews;
        if(subview.count>1){
            for(UIView* innerView in subview){
                if([innerView isKindOfClass:[EditTableCellView class]]){
                    editView = innerView;
                    break;
                }
            }
            editView=subview[subview.count-1];
        }
        else if(subview.count>0){
            editView=subview[0];
        }
        else
            break;
    }

    if([editView isKindOfClass:[EditTableCellView class]]){
        return (EditTableCellView*)editView;
    }
    
    return nil;
}
-(void)repostButtonClicked:(UIButton*)sender
{
    UIView* superView = sender.superview;
    while(superView && ![superView isKindOfClass:[UITableViewCell class]]){
        superView = superView.superview;
    }
    if([superView isKindOfClass:[UITableViewCell class]]){
        EditTableCellView* editView = [self findEditTableCellViewByCell:(UITableViewCell*)superView];
        if(editView){
            NSLog(@"found edit view at index path:%@",((EditTableCellView*)editView).indexPath);
        }
    }
    NSLog(@"repost button clicked");
}
-(void)deleteButtonClicked:(UIButton*)sender
{
    NSLog(@"delete button clicked");
    UIView* superview = sender.superview;
    while (![superview isKindOfClass:[UITableViewCell class]]) {
        superview = superview.superview;
    }
    if([superview isKindOfClass:[UITableViewCell class]]){
        EditTableCellView* editView = [self findEditTableCellViewByCell:(UITableViewCell*)superview];
        NSIndexPath* indexPath = editView.indexPath;
        
        Deal* deal = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.fetchedResultsController.managedObjectContext deleteObject:deal];
        //delete local data
        NSString*dealId = deal.deal_id;
        
        BOOL deleted = [self.utils deleteMyDealStoredDataWithDealId:dealId];
        if(deleted){
            NSLog(@"stored my deal data is deleted");
        }
        else{
            NSLog(@"stored my deal data is deletion failed! at deal id = %@",dealId);
        }

    }
        //save the deletion
    // [self.fetchedResultsController.managedObjectContext save:NULL];
    
}

-(void)cellSwipedLeft:(UISwipeGestureRecognizer*)gesture
{
    //NSLog(@"calling swipe left recognizer");
    if([gesture.view isKindOfClass:[EditTableCellView class]]){
        
        EditTableCellView* view = (EditTableCellView*)gesture.view;
        //1. close all the opening cells
        NSArray* cells = [self.tableView visibleCells];
        for(UITableViewCell* cell in cells){
            EditTableCellView* editView = [self findEditTableCellViewByCell:cell];
            
            if([editView isKindOfClass:[EditTableCellView class]]){
                //NSLog(@"in edit view");
                if(editView.center.x!=self.view.frame.size.width/2){
                    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                        editView.center=CGPointMake(self.view.frame.size.width/2, view.center.y);
                    } completion:nil];
                    editView.backgroundColor=[UIColor whiteColor];
                }
            }
        }
        
        //2. swipe gesture
        if(gesture.direction==UISwipeGestureRecognizerDirectionLeft){
           // NSLog(@"calling swipe recognizer in left");
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                view.center=CGPointMake(self.view.frame.size.width/2-(2*EDIT_BUTTON_WIDTH) + CELL_WIDTH_MARGIN, view.center.y);
                
            } completion:nil];
            view.backgroundColor=[UIColor clearColor];
        }
        //3. add tap gesture recognizer to recover
        UITapGestureRecognizer* tapToRecover = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToRecover:)];
        [view addGestureRecognizer:tapToRecover];
        
    }
    
}

-(void)tapToRecover:(UITapGestureRecognizer*)gesture
{
    if([gesture.view isKindOfClass:[EditTableCellView class]]){
        EditTableCellView* view = (EditTableCellView*)gesture.view;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            view.center=CGPointMake(self.view.frame.size.width/2, view.center.y);
        } completion:nil];
        view.backgroundColor=[UIColor whiteColor];
        
        //remove the tap gesture recognizer
        [view removeGestureRecognizer:gesture];
    }
    
}

-(void)cellSwipedRight:(UISwipeGestureRecognizer*)gesture
{
    if([gesture.view isKindOfClass:[EditTableCellView class]]){
        EditTableCellView* view = (EditTableCellView*)gesture.view;
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            view.center=CGPointMake(self.view.frame.size.width/2, view.center.y);
        } completion:nil];
        view.backgroundColor=[UIColor whiteColor];
    }
}

-(void)cellPanned:(UIPanGestureRecognizer*)gesture
{
    //NSLog(@"calling pan");
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
            //[self.tableView setContentOffset:CGPointMake(0, offsetY - translation.y) animated:YES];
        }
        else if(gesture.state==UIGestureRecognizerStateEnded){
            if(view.center.x<self.view.frame.size.width/2-EDIT_BUTTON_WIDTH-CELL_WIDTH_MARGIN){
                
                NSArray* cells = [self.tableView visibleCells];
                for(UITableViewCell* cell in cells){
                    EditTableCellView* editView = [self findEditTableCellViewByCell:cell];
                    if([editView isKindOfClass:[EditTableCellView class]]){
                        //NSLog(@"in edit view");
                        if(editView.center.x!=self.view.frame.size.width/2){
                            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                                editView.center=CGPointMake(self.view.frame.size.width/2, editView.center.y);
                                 editView.backgroundColor=[UIColor whiteColor];
                            } completion:nil];
                           
                            editView.initialCenter=CGPointMake(self.view.frame.size.width/2, editView.center.y);
                        }
                    }
                }
                
                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                    
                    view.center=CGPointMake(self.view.frame.size.width/2-(2*EDIT_BUTTON_WIDTH) + CELL_WIDTH_MARGIN, view.center.y);
                    view.backgroundColor=[UIColor clearColor];
                    
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

//using the tool provided by iOS's prevents the
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //NSLog(@"commit editing at index path");
//    if(editingStyle==UITableViewCellEditingStyleDelete){
//        //delete the deal in core data
//        Deal* deal = [self.fetchedResultsController objectAtIndexPath:indexPath];
//        [self.fetchedResultsController.managedObjectContext deleteObject:deal];
//        //delete local data
//        NSString*dealId = deal.deal_id;
//        
//        BOOL deleted = [self.utils deleteMyDealStoredDataWithDealId:dealId];
//        if(deleted){
//            NSLog(@"stored my deal data is deleted");
//        }
//        else{
//            NSLog(@"stored my deal data is deletion failed! at deal id = %@",dealId);
//        }
//        //animate the delete in table view
//        
//        //save the deletion
//       // [self.fetchedResultsController.managedObjectContext save:NULL];
//    }
//}
//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //NSLog(@"calling the can edit row at index path");
//    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSArray* subview = cell.subviews;
//    UIView* editView = subview[0];
//    while(![editView isKindOfClass:[EditTableCellView class]]){
//        subview = editView.subviews;
//        if(subview.count>1){
//            editView = [subview[0] isKindOfClass:[EditTableCellView class]]?subview[0]:subview[1];
//        }
//        else if(subview.count>0){
//            editView=subview[0];
//        }
//        else
//            break;
//    }
//    if([editView isKindOfClass:[EditTableCellView class]]){
//        //NSLog(@"found edit table cell view");
//        subview = editView.subviews;
//        if(subview.count>1){
//            //NSLog(@"edit table cell view has more than 1 subviews");
//            UIView* backgroundView = subview[1];
//            if(backgroundView.frame.size.width==CELL_EDIT_BACKGROUND_VIEW_WIDTH){
//                if(self.tableView.editing){
//                    [UIView animateWithDuration:0.2 animations:^{
//                        backgroundView.frame=CGRectMake(0, 0, CELL_EDIT_BACKGROUND_VIEW_WIDTH, CELL_HEIGHT);
//                    }];
//                    return YES;
//                }
//                else{
//                    //NSLog(@"not editing");
//                    [UIView animateWithDuration:0.2 animations:^{
//                        backgroundView.frame=CGRectMake(-CELL_EDIT_BACKGROUND_VIEW_WIDTH, 0, CELL_EDIT_BACKGROUND_VIEW_WIDTH, CELL_HEIGHT);
//                    }];
//                }
//            }
//        }
//    }
//
//    return NO;
//}
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //NSLog(@"calling the editing style for row at index path");
//    //UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//
//    return UITableViewCellEditingStyleDelete;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"calling height for cell");
    return CELL_HEIGHT;
}
-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index %@ highlighted",indexPath);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Deal* deal = [self.fetchedResultsController objectAtIndexPath:indexPath];
    DealObject* dealObject=[[DealObject alloc] init];
    //0. deal_id
    dealObject.deal_id = deal.deal_id;
    //1. title
    dealObject.title = deal.title;
    //2. price
    dealObject.price = deal.price;
    //3. condition
    dealObject.condition = deal.condition;
    //4. describe
    dealObject.describe = deal.describe;
    //5. shipping
    dealObject.shipping = deal.shipping;
    //6. exchange
    dealObject.exchange = deal.exchange;
    //7. create_date
    dealObject.create_date = deal.create_date;
    //8. expire_date
    dealObject.expire_date = deal.expire_date;
    //9. sound url
    dealObject.sound_url = deal.sound_url;
    //10. photoURL
    dealObject.photoURL = deal.photoURL;
    
    for (int i=0; i<dealObject.photoURL.count; i++) {
        nil;
        //NSLog(@"photo is %@",dealObject.photoURL[i]);
    }
    self.transferDealObject = dealObject;
    
    [self performSegueWithIdentifier:@"DealSummaryEditModalSegue" sender:self];
    //self.dealSummaryEditVC.myNewDeal=self.transferDealObject;
    //[self presentViewController:self.dealSummaryEditVC animated:YES completion:nil];
    
    NSLog(@"selected cell");
    
    //self.navigationVC setro
    //[self.navigationVC pushViewController:self.dealSummaryEditVC animated:YES];
    //NSLog(@"self.navigation controller is %@",self.navigationController);
    //[self.navigationController pushViewController:self.dealSummaryEditVC animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id what = [self.fetchedResultsController.sections objectAtIndex:section];
    //NSLog(@"what is %@",what);
    NSInteger rows = [what numberOfObjects];
    //NSLog(@"calling number of rows method %ld",rows);
    return rows;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    if(section == 0){
        footer.backgroundColor=[UIColor greenColor];
        return nil;
    }
    else
        footer.backgroundColor=[UIColor purpleColor];
    return footer;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FOOTER_VIEW_HEIGHT;
}

-(void)editButtonClicked
{
    self.editingMode = self.editingMode?NO:YES;
    if(self.editingMode){
        
        NSArray* visibleCells = self.tableView.visibleCells;
        for(UITableViewCell* cell in visibleCells){
            
//            NSArray* subview = cell.subviews;
//            UIView* editView = subview[0];
//            while(![editView isKindOfClass:[EditTableCellView class]]){
//                subview = editView.subviews;
//                if(subview.count>1){
//                    editView = [subview[0] isKindOfClass:[EditTableCellView class]]?subview[0]:subview[1];
//                }
//                else if(subview.count>0){
//                    editView=subview[0];
//                }
//                else
//                    break;
//            }
            EditTableCellView* editView = [self findEditTableCellViewByCell:cell];
            
            if(editView){
                UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cellPanned:)];
                [editView addGestureRecognizer:pan];
            }
        }
        
    }
    else{
        NSArray* visibleCells = self.tableView.visibleCells;
        for(UITableViewCell* cell in visibleCells){
            EditTableCellView* editView = [self findEditTableCellViewByCell:cell];
            if(editView){
                NSArray* gestures = editView.gestureRecognizers;
                for(UIGestureRecognizer* gesture in gestures){
                    if([gesture isKindOfClass:[UIPanGestureRecognizer class]]){
                        [editView removeGestureRecognizer:gesture];
                        break;
                    }
                }
                if(editView.center.x!=self.view.frame.size.width/2){
                    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                        editView.center=CGPointMake(self.view.frame.size.width/2, editView.center.y);
                        editView.backgroundColor=[UIColor whiteColor];
                    } completion:nil];
                }
            }
        }
    }
}



#pragma mark - refresh animation

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = self.tableView.contentOffset.y;
    
    //NSLog(@"tableview scrolled to %f",offsetY);
    static BOOL userLetGo = NO;
    static BOOL needRefresh=NO;
    static NSString *timeStr = nil;
    //NSArray* subviews = [self.pullDownView subviews];
    NSArray *gestures = self.tableView.gestureRecognizers;
    UIPanGestureRecognizer *panGesture = nil;
    for(UIGestureRecognizer *gesture in gestures){
        if([gesture isKindOfClass:[UIPanGestureRecognizer class]]){
            panGesture = (UIPanGestureRecognizer*)gesture;
            break;
        }
    }
    if(panGesture.state == UIGestureRecognizerStateBegan){
        userLetGo = NO;
        needRefresh=NO;
        self.pullDownImageView.hidden = NO;
        [self.spinner stopAnimating];
        
    }
    //this is the moment when user let go the scrollview(collectionView)
    if(!userLetGo && panGesture.state ==UIGestureRecognizerStatePossible){
        //NSLog(@"gr is possible");
        //self.spinner.frame = CGRectMake(0, 0, 50, 50);
        //every time need to use startAnimating, we need to add spinner to the subview;
        //[self.pullDownView addSubview:self.spinner];
        [_spinner startAnimating];
        timeStr = [NSString stringWithFormat:@"last refreshed on %@",[self getCurrentDateTime]];
        userLetGo = YES;
    }
    if(!userLetGo){
        if(offsetY>-PULLDOWN_VIEW_THRESHOLD){
            if(self.pullDownImageView.image != [UIImage imageNamed:@"downArrow.png"]){
                self.pullDownImageView.image = [UIImage imageNamed:@"downArrow.png"];
            }
            self.pullDownInfoLabel.text = @"pull down to refresh";
            self.pullDownTimeLabel.text = timeStr;
            
        }
        else{
            if(self.pullDownImageView.image != [UIImage imageNamed:@"upArrow.png"]){
                self.pullDownImageView.image = [UIImage imageNamed:@"upArrow.png"];
            }
            needRefresh=YES;
            _pullDownInfoLabel.text = @"let go to refresh";
            //_pullDownTimeLabel.text = timeStr;
        }
    }
    else if(needRefresh){
        [self.spinner startAnimating];
        self.pullDownImageView.hidden = YES;
        [self fetchDealsFromCoreData];
    
        if(offsetY > -2){
            [self.spinner stopAnimating];
        }
    }
    else{
        [self.spinner stopAnimating];
        
    }
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue is %@",segue.identifier);

    if([segue.identifier isEqualToString:@"DealSummaryEditModalSegue"]){
        if([segue.destinationViewController isKindOfClass:[DealSummaryEditViewController class]]){
            DealSummaryEditViewController* dealSummaryEditVC=(DealSummaryEditViewController*)segue.destinationViewController;
            dealSummaryEditVC.myNewDeal = self.transferDealObject;
            
        }
    }
}


#pragma mark - setup
-(NSFetchedResultsController *)fetchedResultsController{
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
    [self.fetchedResultsController performFetch:NULL];
    [self.tableView reloadData];
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
        _tableView.frame=CGRectMake(0, TAB_BAR_HEIGHT ,self.view.frame.size.width,self.view.frame.size.height - NAVIGATION_BAR_HEIGHT -TAB_BAR_HEIGHT + TAB_BAR_OFFSET);
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

-(UIView*)pullDownView{
    if(!_pullDownView){
        CGRect frame = CGRectMake(0, -PULLDOWN_VIEW_HEIGHT, self.view.frame.size.width,PULLDOWN_VIEW_HEIGHT);
        _pullDownView = [[UIView alloc] initWithFrame:frame];
        _pullDownView.backgroundColor = [UIColor lightGrayColor];
        UIImage *downArrow = [UIImage imageNamed:@"downArrow.png"];
        self.pullDownImageView.image=downArrow;
        self.pullDownImageView.backgroundColor = [UIColor clearColor];
        self.pullDownImageView.frame = CGRectMake(20, 0, 20, PULLDOWN_VIEW_HEIGHT);
        [_pullDownView addSubview:_pullDownImageView];
        
        self.pullDownInfoLabel.text = @"pull down to refresh";
        self.pullDownInfoLabel.font = [UIFont fontWithName:@"Arial" size:14.0f];
        [_pullDownView addSubview:self.pullDownInfoLabel];

        self.pullDownTimeLabel.text = [NSString stringWithFormat:@"last refreshed on %@",[self getCurrentDateTime]];
        self.pullDownTimeLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        [_pullDownView addSubview:self.pullDownTimeLabel];
        
        [_pullDownView addSubview:self.spinner];
    }
    return _pullDownView;
}
-(UILabel*)pullDownInfoLabel
{
    if(!_pullDownInfoLabel){
        _pullDownInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 250, PULLDOWN_VIEW_HEIGHT/2)];
    }
    return  _pullDownInfoLabel;
}
-(UILabel*)pullDownTimeLabel
{
    if(!_pullDownTimeLabel){
        _pullDownTimeLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, PULLDOWN_VIEW_HEIGHT/2, 250, PULLDOWN_VIEW_HEIGHT/2)];
    }
    return _pullDownTimeLabel;
}
-(UIImageView*)pullDownImageView
{
    if(!_pullDownImageView){
        _pullDownImageView = [[UIImageView alloc] init];
    }
    return _pullDownImageView;
}
-(UIActivityIndicatorView*)spinner
{
    if(!_spinner){
        _spinner=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _spinner.frame=CGRectMake(0, 0, 50, 50);
    }
    return _spinner;
}
//-(UINavigationController*)navigationVC
//{
//    if(!_navigationVC){
//        _navigationVC=[[UINavigationController alloc] init];
//    }
//    return _navigationVC;
//}

//-(DealSummaryEditViewController*)dealSummaryEditVC
//{
//    if(!_dealSummaryEditVC){
//        _dealSummaryEditVC = [[DealSummaryEditViewController alloc] init];
//    }
//    return _dealSummaryEditVC;
//}
-(void)setup
{
    [self.view addSubview:self.tableView];
//    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 400, 100, 50)];
//    [button setBackgroundColor:[UIColor purpleColor]];
//    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
    [self.tableView addSubview:self.pullDownView];
    _userHasChanged=NO;
    //self.view.backgroundColor=[UIColor redColor];
    self.editingMode = NO;
    
    
}
-(void)buttonClicked:(UIButton*)sender
{
    NSLog(@"button clicked");
    [self.fetchedResultsController performFetch:NULL];
    [self.tableView reloadData];
    
}
-(NSString *)getCurrentDateTime
{
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@" MMM/dd/yyyy 'at' HH':'mm':'ss"];
    return [dateFormatter stringFromDate:date];
}

#pragma  mark - life cycle methods
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"should perform segue with identifier: %@",identifier);
    NSLog(@"sender is %@",sender);
    return  YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    
    //NSLog(@"deal list view navigation view controller %@",self.navigationController);
    //[self.navigationController setNavigationBarHidden:NO];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
