//
//  CenterTabHotDealController.m
//  xiaojiaoyi
//
//  Created by chen on 10/4/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "CenterTabHotDealController.h"

#define SEARCH_BAR_HEIGHT 50
#define TAB_BAR_HEIGHT 50
#define TRANSITION_THRESHOLD 0.0
#define COLLECTION_VIEW_MARGIN 0
#define COLLECTION_VIEW_HEADER_MARGIN 8
#define COLLECTION_VIEW_HEADER_LEFT_WIDTH 110
#define COLLECTION_VIEW_HEADER_UPPER_HEIGHT 120
#define COLLECTION_VIEW_HEADER_HEIGHT 250

#define PULLDOWN_VIEW_THRESHOLD 50
#define PULLDOWN_VIEW_HEIGHT 50
#define REFRESH_OFFSET 30
#define REFRESH_LIMIT 5

@interface CenterTabHotDealController ()

@property (nonatomic) UIView* pullDownView;
@property (nonatomic) UIActivityIndicatorView *spinner;
@property (nonatomic) UIImageView *pullDownImageView;
@property (nonatomic) UILabel *pullDownInfoLabel;
@property (nonatomic) UILabel *pullDownTimeLabel;

@property (nonatomic) NSMutableArray* businesses;
//@property (nonatomic) NSMutableDictionary* cells;
@property (nonatomic) NSMutableArray* names;
@property (nonatomic) NSMutableArray* urls;
@property (nonatomic) UIImage* defaultImage;
@property (nonatomic) NSMutableArray* images;
@property (nonatomic) NSMutableArray* locationLatitude;
@property (nonatomic) NSMutableArray* locationLongitude;
@property (nonatomic) NSMutableArray* locationAddress;
@property (nonatomic) NSMutableArray* phoneNumber;
@property (nonatomic) NSMutableArray* reviewCount;
@property (nonatomic) NSMutableArray* review;
@property (nonatomic) NSMutableArray* ratingImages;
@property (nonatomic) NSMutableArray* ratingImagesURL;
@property (nonatomic) NSMutableArray* categories;
@property (nonatomic) NSMutableArray* isClosed;

@property (nonatomic) YelpDataSource* dataSource;
@property (nonatomic) NSInteger offset;
@property (nonatomic) NSInteger batchNumber;
@property (nonatomic) NSString* queryString;
@property (nonatomic) NSString* categoryString;
@property (nonatomic) NSString* locationString;
@property (nonatomic) BOOL needToRefresh;
@property (nonatomic) NSIndexPath* selectedItem;

@end

@implementation CenterTabHotDealController

#pragma mark - touch event methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.nextResponder touchesBegan:touches withEvent:event];
    //NSLog(@"hot deal view touches began");
    //UITouch *touch = [touches anyObject];
    //CGPoint curLoc = [touch locationInView:self.view];
    //CGPoint prevLoc = [touch previousLocationInView:self.view];
   // NSLog(@"prevLoc is x=%f,y=%f and curLoc is x=%f,y=%f",prevLoc.x,prevLoc.y,curLoc.x,curLoc.y);
//    NSArray* gestures = self.view.gestureRecognizers;
//    for(int i=0;i<gestures.count;i++){
//        [gestures[i] touchesBegan:touches withEvent:event];
//    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self.nextResponder touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGFloat yOffset = [touch locationInView:self.view].y - [touch previousLocationInView:self.view].y;
    if(yOffset < -TRANSITION_THRESHOLD){
        [self hideSearchBar];
    }
    else if(yOffset > TRANSITION_THRESHOLD){
        [self showSearchBar];
    }
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"HDC gesture cancelled");
    [self tap:nil];
    [super touchesCancelled:touches withEvent:event];
    [self.nextResponder touchesCancelled:touches withEvent:event];
    [self.view.superview touchesCancelled:touches withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"gesture ended");
    [self tap:nil];
    [super touchesEnded:touches withEvent:event];
    [self.nextResponder touchesEnded:touches withEvent:event];
    if(self.mainVC){
        //NSLog(@"main view is reset: %d",self.mainVC.isReset);
        //if(!self.mainVC.isReset){
            [self.mainVC resetWithCenterView:self.mainVC.centerViewController.view];//???
        //}
    }
    [self.view.superview touchesEnded:touches withEvent:event];
}

//=======================================
#pragma mark - collection view layout methods
-(UICollectionViewFlowLayout*) flowLayout
{
    if(!_flowLayout){
        _flowLayout = [[CenterCollectionViewFlowLayout alloc] init];
//        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumInteritemSpacing =0;
        _flowLayout.minimumLineSpacing = 5;
        _flowLayout.itemSize = CGSizeMake(170, 170);
        
        //H3.need to set header referenceSize to nonZeroSize to show the header!
        _flowLayout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, COLLECTION_VIEW_HEADER_HEIGHT);
        _flowLayout.footerReferenceSize = CGSizeMake(self.view.frame.size.width,100);
    }
    return _flowLayout;
}
//set insets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 12, 5, 12);
}

//the collection view regular cell size
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeMake(145, 170);
    return size;
}
//set Header and Footer
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //Header2. calling the supplementary view
    UICollectionReusableView*view = nil;
    if(kind == UICollectionElementKindSectionHeader){
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CenterHotDealCollectionViewHeader" forIndexPath:indexPath];
        if(!view){
            //view= [[UICollectionReusableView alloc] init];
            view = [[GestureCollectionReusableView alloc] init];
        }
        UIButton *leftButton = [[GestureButton alloc] initWithFrame:CGRectMake(COLLECTION_VIEW_HEADER_MARGIN, 0, COLLECTION_VIEW_HEADER_LEFT_WIDTH, COLLECTION_VIEW_HEADER_HEIGHT)];
        leftButton.backgroundColor = [UIColor colorWithRed:0 green:255 blue:0 alpha:0.5];
        [leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setTitle:@"Promo_1" forState:UIControlStateNormal];
        
        UIButton *upperButton = [[GestureButton alloc] initWithFrame:CGRectMake(COLLECTION_VIEW_HEADER_LEFT_WIDTH + COLLECTION_VIEW_HEADER_MARGIN*2  ,0 , self.view.frame.size.width-(COLLECTION_VIEW_HEADER_LEFT_WIDTH + COLLECTION_VIEW_HEADER_MARGIN*3), COLLECTION_VIEW_HEADER_UPPER_HEIGHT)];
        upperButton.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.5];
        [upperButton addTarget:self action:@selector(topButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [upperButton setTitle:@"Commercial_1" forState:UIControlStateNormal];
        
        UIButton *lowerButton = [[GestureButton alloc] initWithFrame:CGRectMake(COLLECTION_VIEW_HEADER_LEFT_WIDTH + COLLECTION_VIEW_HEADER_MARGIN*2, COLLECTION_VIEW_HEADER_UPPER_HEIGHT+COLLECTION_VIEW_HEADER_MARGIN, self.view.frame.size.width-(COLLECTION_VIEW_HEADER_LEFT_WIDTH + COLLECTION_VIEW_HEADER_MARGIN*3) , COLLECTION_VIEW_HEADER_HEIGHT - COLLECTION_VIEW_HEADER_UPPER_HEIGHT - COLLECTION_VIEW_HEADER_MARGIN)];
        [lowerButton addTarget:self action:@selector(bottomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        lowerButton.backgroundColor = [UIColor blueColor];
        [lowerButton setTitle:@"Commercial_2" forState:UIControlStateNormal];
        
        view.frame = CGRectMake(0, 0,self.view.frame.size.width - 2*COLLECTION_VIEW_MARGIN, 250);
        [view addSubview:leftButton];
        [view addSubview:upperButton];
        [view addSubview:lowerButton];
    }
    else if(kind == UICollectionElementKindSectionFooter){
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CenterHotDealCollectionViewFooter" forIndexPath:indexPath];
        if(!view){
            view =[[GestureCollectionReusableView alloc] init];
        }
        view.backgroundColor = [UIColor lightGrayColor];
        CGFloat footerOriginY=self.collectionVC.collectionView.frame.origin.y + self.collectionVC.collectionView.frame.size.height + COLLECTION_VIEW_HEADER_HEIGHT;
        //NSLog(@"footer origin y is %f",footerOriginY);
        view.frame = CGRectMake(0,footerOriginY , self.view.frame.size.width, 100);
    }
    [_collectionVC.collectionView addSubview:view];
    
    return view;
}

//collecion view controller setup
-(UICollectionViewController*)collectionVC
{
    if(!_collectionVC){
        _collectionVC = [[UICollectionViewController alloc] initWithCollectionViewLayout:self.flowLayout];
        CGFloat originY = _searchBar.frame.size.height + _searchBar.frame.origin.y;
        //NSLog(@"originY is %f",originY);
        CGRect collectionViewFrame = CGRectMake(COLLECTION_VIEW_MARGIN, originY, self.view.frame.size.width -2*COLLECTION_VIEW_MARGIN, self.view.frame.size.height - originY);
        //NSLog(@"frame y is %f",collectionViewFrame.origin.y);
        
        _collectionVC.collectionView = [[GestureCollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:self.flowLayout];
        _collectionVC.collectionView.frame = collectionViewFrame;
        _collectionVC.collectionView.delegate = self;
        _collectionVC.collectionView.dataSource = self;
        _collectionVC.collectionView.backgroundColor = [UIColor whiteColor];
        
        UIView *pullDownView=[self pullDownView];
        //pullDownView.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
        //[_collectionVC.collectionView bringSubviewToFront:pullDownView];
        [_collectionVC.collectionView addSubview:pullDownView];
        
        //_collectionVC.collectionView.backgroundView =
        [_collectionVC.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"hotDealCollectionViewCell"];
        
        //Header1.register the header
        [_collectionVC.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CenterHotDealCollectionViewHeader"];
        [_collectionVC.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CenterHotDealCollectionViewFooter"];
        
//        NSArray *gestures = _collectionVC.collectionView.gestureRecognizers;
//        for(int i=0;i<gestures.count;i++){
//            UIGestureRecognizer* g= (UIGestureRecognizer*)gestures[i];
//            /*this method is of no use. because GR by default can only respond to one gesture,even on different views, as long as they are in the same part area on the screen. Cannot customize UIScrollView's gesture recognizer's delegate
//            */
//            [g setCancelsTouchesInView: NO];
//        }
        
        //NSLog(@"frame origin y is %f",_collectionVC.collectionView.frame.origin.y);
        //_collectionVC.collectionView.frame=collectionViewFrame;
    }
    
    //view controller container
    [self.view addSubview:_collectionVC.collectionView];
    [self addChildViewController:_collectionVC];
    [_collectionVC didMoveToParentViewController:self];
    return _collectionVC;
}

//collection view data source methods
-(UICollectionViewCell*) collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"calling cell for collection view");
//    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotDealCollectionViewCell" forIndexPath:indexPath];
    //NSLog(@"at index path: section = %ld row = %ld",indexPath.section,indexPath.row);
    
    //NSLog(@"calling the collection view cell method and indexPath is %ld", indexPath.row);
    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotDealCollectionViewCell" forIndexPath:indexPath];
//    NSArray *subviews = cell.contentView.subviews;
//    for(int i=0;i<subviews.count;i++){
//        NSLog(@"subview [i] is %@",subviews[i]);
//    }
    if(!cell){
        cell=[[CollectionViewCell alloc] init];
    }
    if(!cell.imageView){
        cell.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.width)];
    }
    if(!cell.label){
        cell.label=[[UILabel alloc] initWithFrame:CGRectMake(2, cell.frame.size.width, cell.frame.size.width, cell.frame.size.height-cell.frame.size.width)];
    }
//    UIImageView *imageView;
//    UILabel *label;
//    if(subviews.count>0){
//        for(int i=0;i<subviews.count;i++){
//            if([subviews[i] isKindOfClass:[UIImageView class]]){
//                imageView = (UIImageView *)subviews[i];
//                imageView.frame = CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.width);
//                //imageView.image = [UIImage imageNamed:@"apple image.jpg"];
//                //sleep(1);
//            }
//            else if([subviews[i] isKindOfClass:[UILabel class]]){
//                label = (UILabel*)subviews[i];
//                label.frame = CGRectMake(2, cell.bounds.size.width, cell.bounds.size.width, cell.bounds.size.height - cell.bounds.size.width);
//                //labelView.text = [NSString stringWithFormat:@"this is %ld",indexPath.row];
//            }
//        }
//    }
//    else{
//        imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.width)];
//        label=[[UILabel alloc] initWithFrame:CGRectMake(0, cell.frame.size.width, cell.frame.size.width, cell.frame.size.height-cell.frame.size.width)];
//        [cell addSubview:imageView];
//        [cell addSubview:label];
//    }
    
    [cell.layer setBorderWidth:2.0f];
    [cell.layer setBorderColor:[[UIColor blueColor] CGColor]];
    [cell.layer setShadowRadius:5];
    [cell.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [cell.layer setCornerRadius:5.0f];
    NSInteger idx = indexPath.row;
    cell.imageView.layer.cornerRadius=5.0;
    
    if(cell.imageView.superview != cell){
        [cell addSubview:cell.imageView];
    }
    if(cell.label.superview !=cell){
        [cell addSubview:cell.label];
    }
    
    if(self.images.count>idx && self.images[idx] == self.defaultImage){
        cell.imageView.image = self.defaultImage;
        cell.label.text = [NSString stringWithFormat:@""];
        
        if([self.urls objectAtIndex:idx]){
//            cell.imageView.image = [UIImage imageNamed:@"apple image.jpg"];
//            cell.label.text = [NSString stringWithFormat:@""];
            NSURLSession* session = [NSURLSession sharedSession];
            NSURLRequest* request = [[NSURLRequest alloc] initWithURL:self.urls[idx]];
            NSURLSessionDownloadTask* downloadTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error){
                NSHTTPURLResponse* r = (NSHTTPURLResponse*)response;
                if(r.statusCode==200){
                    //dispatch_async(dispatch_get_main_queue(), ^{
                        //[self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                        NSData* data = [NSData dataWithContentsOfURL:location];
                        UIImage* newImage = [UIImage imageWithData:data];
                        //UIImage* newImage = [UIImage imageWithContentsOfFile:location.path];
                    
                        if(newImage){
                            //NSLog(@"file is %@",location.lastPathComponent);
                            self.images[idx] =[newImage copy];
                            //cell.image=[newImage copy];
                            cell.imageView.image=self.images[idx];
                            cell.label.text=self.names[idx];
                            cell.hasImage=YES;
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.collectionVC.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                        });
                    
                    //});
                }
                
            }];
            [downloadTask resume];
        }
    }
    else{
        cell.imageView.image = self.images[idx];
        cell.label.text =self.names[idx];
        cell.label.attributedText=[[NSAttributedString alloc] initWithString:self.names[idx] attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Georgia" size:14],NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
    
    return cell;

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.urls.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self tap:nil];
    NSLog(@"!!highlighted item at section:%ld and row: %ld",indexPath.section,indexPath.row);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"!!selected item at section:%ld and row: %ld",indexPath.section,indexPath.row);
    //NSLog(@"self.superviewcontroller is %@",self.parentViewController.parentViewController);
    self.selectedItem = indexPath;
    
    //[self.parentViewController.parentViewController performSegueWithIdentifier:@"YelpDetailPushSegue" sender:self];
    [self.mainVC performSegueWithIdentifier:@"YelpDetailPushSegue" sender:self];
    
}

//============================================
#pragma mark - commercial button methods
-(void)leftButtonClicked:(id)sender
{
    //NSLog(@"left button clicked");
    if(self.mainVC.mainContainerView.frame.origin.x!=0){
        [self.mainVC reset];
    }
    
}
-(void)topButtonClicked:(id)sender
{
    //NSLog(@"top button clicked");
    if(self.mainVC.mainContainerView.frame.origin.x!=0){
        [self.mainVC reset];
    }
}
-(void)bottomButtonClicked:(id)sender
{
    //NSLog(@"bottom button clicked");
    if(self.mainVC.mainContainerView.frame.origin.x!=0){
        [self.mainVC reset];
    }
}

//=================================================
#pragma mark - search bar methods
-(void)setupSearchBar
{
    //NSLog(@"width is%f",self.view.frame.size.width);
    if(!_searchBar){
        CGRect searchBarFrame = CGRectMake(0,TAB_BAR_HEIGHT, self.view.frame.size.width, SEARCH_BAR_HEIGHT);
        _searchBar = [[UISearchBar alloc] initWithFrame:searchBarFrame];
    }
    [self.view addSubview:_searchBar];
}
-(void)setupGestureRecognizer
{
    UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHighSearchbarBySwipeGesture:)];
    [swipeGR setDirection:UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp];
    [swipeGR setNumberOfTouchesRequired:1];
    
    UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(showOrHideSearchBarByPanGesture:)];
    [panGR setCancelsTouchesInView:NO];
    panGR.cancelsTouchesInView = NO;
    [panGR setMaximumNumberOfTouches:1];
    [panGR setMinimumNumberOfTouches:1];

    //[self.view addGestureRecognizer:swipeGR];
    panGR.delegate = self;
    //if this panGR is added it conflicts with another PanGR?
    //blocking the panGR on the Center View's panGR
    [self.view addGestureRecognizer:panGR];

    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapGR];
}

-(void)showSearchBar
{
    //CGFloat originY = _searchBar.frame.size.height + _searchBar.frame.origin.y;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _searchBar.frame = CGRectMake(0, TAB_BAR_HEIGHT, self.view.frame.size.width, SEARCH_BAR_HEIGHT);
        _collectionVC.collectionView.frame = CGRectMake(COLLECTION_VIEW_MARGIN, TAB_BAR_HEIGHT + SEARCH_BAR_HEIGHT, self.view.frame.size.width-2*COLLECTION_VIEW_MARGIN, self.view.frame.size.height - (TAB_BAR_HEIGHT + SEARCH_BAR_HEIGHT));
    } completion:nil];
}
-(void)hideSearchBar
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, SEARCH_BAR_HEIGHT);
        _collectionVC.collectionView.frame = CGRectMake(COLLECTION_VIEW_MARGIN, TAB_BAR_HEIGHT, self.view.frame.size.width -2*COLLECTION_VIEW_MARGIN, self.view.frame.size.height - TAB_BAR_HEIGHT);
    } completion:nil];
}
-(void)tap:(UITapGestureRecognizer*)gesture
{
    //NSLog(@"HDC calling tap recognizer");
    //NSLog(@"gesture is %@ and view is %@",gesture,gesture.view);
    if([_searchBar isFirstResponder])
        [_searchBar resignFirstResponder];
}

-(void)showOrHighSearchbarBySwipeGesture:(UISwipeGestureRecognizer*)gesture
{
    //NSLog(@"HDC calling swipe recognizer and direction is %ld",gesture.direction);
    if(gesture.direction == UISwipeGestureRecognizerDirectionDown){
        [self showSearchBar];
    }
    else if(gesture.direction == UISwipeGestureRecognizerDirectionUp){
        [self hideSearchBar];
    }
}

-(void)showOrHideSearchBarByPanGesture:(UIPanGestureRecognizer*)gesture
{
    //UIGestureRecognizer*g = (UIGestureRecognizer *)_collectionVC.collectionView.gestureRecognizers[0];
    if(gesture.state == UIGestureRecognizerStateChanged){
        CGPoint transition  = [gesture translationInView: self.view];
        if(transition.y > TRANSITION_THRESHOLD){
            [self showSearchBar];
        }
        else if(transition.y < -TRANSITION_THRESHOLD){
            [self hideSearchBar];
        }
    }
}

#pragma mark - scroll view methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static BOOL userLetGo = NO;
    static NSString *timeStr = nil;
    CGFloat offset = [_collectionVC.collectionView contentOffset].y;
    //NSLog(@"scroll view at offset %f",offset);
    //NSArray* subviews = [self.pullDownView subviews];
    NSArray *gestures = _collectionVC.collectionView.gestureRecognizers;
    
    UIPanGestureRecognizer *panGesture = nil;
    for(UIGestureRecognizer *gesture in gestures){
        if([gesture isKindOfClass:[UIPanGestureRecognizer class]])
            panGesture = (UIPanGestureRecognizer*)gesture;
    }
    if(panGesture.state == UIGestureRecognizerStateBegan){
        userLetGo = NO;
        _pullDownImageView.hidden = NO;
        [_spinner stopAnimating];
    }
    
    //this is the moment when user let go the scrollview(collectionView)
    if(!userLetGo && panGesture.state ==UIGestureRecognizerStatePossible){
        //NSLog(@"pan guesture ended");
        _spinner.frame = CGRectMake(0, 0, 50, 50);
        //every time need to use startAnimating, we need to add spinner to the subview;
        [self.pullDownView addSubview:_spinner];
        [_spinner startAnimating];
        timeStr = [NSString stringWithFormat:@"last refreshed on %@",[self getCurrentDateTime]];
        userLetGo = YES;
    }
    if(!userLetGo){
        if(offset>-PULLDOWN_VIEW_THRESHOLD-20){
            if(_pullDownImageView.image != [UIImage imageNamed:@"pull_down_arrow.jpg"]){
                _pullDownImageView.image = [UIImage imageNamed:@"pull_down_arrow.jpg"];
            }
            _pullDownInfoLabel.text = @"pull down to refresh";
            _pullDownTimeLabel.text = timeStr;
            
        }
        else{
            if(_pullDownImageView.image != [UIImage imageNamed:@"pull_up_arrow.jpg"]){
                _pullDownImageView.image = [UIImage imageNamed:@"pull_up_arrow.jpg"];
            }
            _pullDownInfoLabel.text = @"let go to refresh";
            //_pullDownTimeLabel.text = timeStr;
        }
    }
    else{
        [_spinner startAnimating];
        _pullDownImageView.hidden = YES;
    }
    //refresh and fetch more data
    if( self.batchNumber <= REFRESH_LIMIT && offset > ((self.names.count%2==1?self.names.count+1:self.names.count)/2 - 2)*175 + 5 + REFRESH_OFFSET + COLLECTION_VIEW_HEADER_HEIGHT){
        if(self.needToRefresh){
            NSLog(@"call to refresh");
            //[self refreshDataWithQuery:self.query category:self.category andLocation:self.location offset:[NSString stringWithFormat:@"%ld",self.offset]];
            
            [self refreshDataWithoffset:[NSString stringWithFormat:@"%ld",self.offset+1]];
            //[self refreshDataWithLocationAndQuery:self.queryString category:self.categoryString offset:[NSString stringWithFormat:@"%ld",self.offset]];
            self.needToRefresh=NO;
        }
    }
}
//pull down view
-(UIView*)pullDownView{
    if(!_pullDownView){
        CGRect frame = CGRectMake(0, -PULLDOWN_VIEW_HEIGHT, self.view.frame.size.width,PULLDOWN_VIEW_HEIGHT);
        _pullDownView = [[UIView alloc] initWithFrame:frame];
        _pullDownView.backgroundColor = [UIColor lightGrayColor];
        
        UIImage *image = [UIImage imageNamed:@"pull_down_arrow.jpg"];
        if(!_pullDownImageView){
            _pullDownImageView = [[UIImageView alloc] initWithImage:image];
        }
        _pullDownImageView.backgroundColor = [UIColor clearColor];
        _pullDownImageView.frame = CGRectMake(20, 0, 20, PULLDOWN_VIEW_HEIGHT);
        
        [_pullDownView addSubview:_pullDownImageView];
        
        if(!_pullDownInfoLabel){
            _pullDownInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 250, PULLDOWN_VIEW_HEIGHT/2)];
        }
        _pullDownInfoLabel.text = @"pull down to refresh";
        _pullDownInfoLabel.font = [UIFont fontWithName:@"Arial" size:14.0f];
        [_pullDownView addSubview:_pullDownInfoLabel];
        
        if(!_pullDownTimeLabel){
            _pullDownTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, PULLDOWN_VIEW_HEIGHT/2, 250, PULLDOWN_VIEW_HEIGHT/2)];
        }
        _pullDownTimeLabel.text = [NSString stringWithFormat:@"last refreshed on %@",[self getCurrentDateTime]];
        _pullDownTimeLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        
        [_pullDownView addSubview:_pullDownTimeLabel];
        
        
    }
    return _pullDownView;
}


#pragma mark - segue preparation
-(void)pushToYelpDetailViewController:(YelpDetailViewController*)yelpDetailVC
{
    //NSLog(@"selected item is %@",self.selectedItem);
    CLLocationCoordinate2D coordinate;
    NSInteger idx= self.selectedItem.row;
    NSNumber* latitude = self.locationLatitude[idx];
    NSNumber* longitude = self.locationLongitude[idx];
    coordinate.latitude = latitude.doubleValue;
    coordinate.longitude = longitude.doubleValue;
    
    Location *annotation = [[Location alloc] initWithName:self.names[self.selectedItem.row] Location:coordinate];
    yelpDetailVC.pins=[[NSMutableArray alloc] init];
    [yelpDetailVC.pins addObject:annotation];
    //NSLog(@"latitude is %@,longitude is %@",self.locationLatitude[idx],self.locationLongitude[idx]);
    //[yelpDetailVC clear];
    yelpDetailVC.image=self.images[idx];
    yelpDetailVC.titleString = self.names[idx];
    yelpDetailVC.address = self.locationAddress[idx];
    yelpDetailVC.photoNumber = self.phoneNumber[idx];
    yelpDetailVC.reviewCount = self.reviewCount[idx];
    yelpDetailVC.review = self.review[idx];
    yelpDetailVC.ratingImageURL=self.ratingImagesURL[idx];
    yelpDetailVC.isClosed = self.isClosed[idx];
    yelpDetailVC.category = self.categories[idx];
    
    NSLog(@"push to Yelp Detail View Controller");
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"YelpDetailPushSegue"]){
        
        NSLog(@"is YelpDetailPushSegue");
    }
}
#pragma mark - overall setup
-(YelpDataSource*)dataSource
{
    if(!_dataSource){
        //_dataSource=[[YelpDataSource alloc] initWithQuery:@"food" andRegion:@"San Francisco"];
        _dataSource=[[YelpDataSource alloc] init];
        [_dataSource setQuery:self.queryString category:self.categoryString location:self.locationString offset:@"0"];
    }
    return _dataSource;
}


-(void)clear
{
    NSInteger count = self.urls.count;
    [self.names removeAllObjects];
    [self.urls removeAllObjects];
    [self.images removeAllObjects];
    [self.locationLongitude removeAllObjects];
    [self.locationLatitude removeAllObjects];
    [self.locationAddress removeAllObjects];
    [self.phoneNumber removeAllObjects];
    [self.review removeAllObjects];
    [self.reviewCount removeAllObjects];
    [self.ratingImages removeAllObjects];
    [self.ratingImagesURL removeAllObjects];
    [self.categories removeAllObjects];
    [self.isClosed removeAllObjects];
    
    self.offset=0;
    NSMutableArray* arr = [[NSMutableArray alloc] init];
    for(int i =0;i<count;i++){
        [arr addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [self.collectionVC.collectionView deleteItemsAtIndexPaths:arr];
}
-(void)refreshDataWithoffset:(NSString*)offset
{
    [self.dataSource setQuery:nil category:nil location:nil offset:offset];
    [self.dataSource fetchDataWithCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse * r = (NSHTTPURLResponse*)response;
        if(r.statusCode == 200){
            //NSLog(@"is successful");
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error: &error];
            //NSLog(@"%@",json);
            self.businesses = [json valueForKey:@"businesses"];

            //NSLog(@"%@",self.businesses[0]);
            for(NSInteger i=0;i<[self.businesses count];i++){
                NSString *name = [self.businesses[i] valueForKey:@"name"];
                NSString *urlStr = [self.businesses[i] valueForKey:@"image_url"];
                NSDictionary* location = [[self.businesses[i] valueForKey:@"location"] valueForKey:@"coordinate"];
                NSNumber* latitude = (NSNumber*)[location valueForKey:@"latitude"];
                NSNumber* longitude = (NSNumber*)[location valueForKey:@"longitude"];
                //NSLog(@"lat is %@, longitude %@",latitude,longitude);
                
                NSArray* displayAddr = [[self.businesses[i] valueForKey:@"location"] valueForKey:@"display_address"];
                NSMutableString* address = [[NSMutableString alloc] init];
                for(int i =0;i< displayAddr.count-1;i++){
                    [address appendString:[NSString stringWithFormat:@"%@\r\n",displayAddr[i]]];
                }
                [address appendString:displayAddr[displayAddr.count-1]];
                NSString* phoneNumber = [self.businesses[i] valueForKey:@"display_phone"];
                NSNumber* reviewNumber = [self.businesses[i] valueForKey:@"review_count"];
                NSString* review = [self.businesses[i] valueForKey:@"snippet_text"];
                NSString* ratingImageURL = [self.businesses[i] valueForKey:@"rating_img_url_large"];
                NSNumber* isClosed = [self.businesses[i] valueForKey:@"is_closed"];
                NSArray* categories = [self.businesses[i] valueForKey:@"categories"];
                NSMutableString* category = [[NSMutableString alloc] init];
                NSArray* subCategoryArr=nil;
                for(int i=0;i<categories.count-1;i++){
                    subCategoryArr = categories[i];
                    [category appendString:[NSString stringWithFormat:@"%@, ",subCategoryArr[0]]];
                }
                subCategoryArr = categories[categories.count-1];
                [category appendString:[NSString stringWithFormat:@"%@",subCategoryArr[0]]];
                
                if(name && urlStr && latitude && longitude && address &&address.length>0){
                    [self.names addObject:name];
                    [self.urls addObject:[NSURL URLWithString:urlStr]];
                    [self.locationLatitude addObject:latitude];
                    [self.locationLongitude addObject:longitude];
                    [self.locationAddress addObject:address];
                    //NSLog(@"address is %@",address);
                    [self.images addObject:self.defaultImage];
                    if(phoneNumber)
                        [self.phoneNumber addObject:phoneNumber];
                    if(reviewNumber)
                        [self.reviewCount addObject:reviewNumber];
                    if(review)
                        [self.review addObject:review];
                    if(ratingImageURL)
                        [self.ratingImagesURL addObject:ratingImageURL];
                    
                    [self.ratingImages addObject:self.defaultImage];
                    if(isClosed)
                        [self.isClosed addObject:isClosed];
                    if(category)
                        [self.categories addObject:category];
                    self.offset=self.offset+1;
                }
                //NSLog(@"-------");
            }
            self.batchNumber=self.batchNumber+1;
            //NSLog(@"batch is %ld",self.batchNumber);
            //self.offset=self.offset+self.businesses.count;
            self.needToRefresh=YES;
            //call it on the main queue to refresh the screen immediately!!
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionVC.collectionView reloadData];
                //[self.collectionView reloadData];
            });
            
        }
    }];
}



-(void)setup
{
    [self setupSearchBar];
    self.defaultImage=[UIImage imageNamed:@"apple image.jpg"];
    self.view.frame = [UIScreen mainScreen].bounds;
    //initialize the query settings
    self.queryString=@"";
    self.categoryString=@"restaurants";
    self.locationString=@"San Francisco";
    //self.cells = [[NSMutableDictionary alloc] init];
    self.names=[[NSMutableArray alloc] init];
    self.urls=[[NSMutableArray alloc] init];
    self.images=[[NSMutableArray alloc] init];
    self.locationAddress=[[NSMutableArray alloc] init];
    self.locationLatitude=[[NSMutableArray alloc] init];
    self.locationLongitude = [[NSMutableArray alloc] init];
    self.categories = [[NSMutableArray alloc] init];
    self.phoneNumber = [[NSMutableArray alloc] init];
    self.review = [[NSMutableArray alloc] init];
    self.reviewCount = [[NSMutableArray alloc] init];
    self.ratingImagesURL = [[NSMutableArray alloc] init];
    self.ratingImages = [[NSMutableArray alloc] init];
    self.isClosed= [[NSMutableArray alloc] init];
    
    self.needToRefresh=NO;
    self.offset=0;
    [self refreshDataWithoffset:@"0"];
    
    [self collectionVC];
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

#pragma mark - life cycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setup];

}

-(NSString *)getCurrentDateTime
{
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@" MMM/dd/yyyy 'at' HH':'mm':'ss"];
    return [dateFormatter stringFromDate:date];
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
