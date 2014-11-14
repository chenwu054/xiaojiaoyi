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

@interface CenterTabHotDealController ()

@property (nonatomic) UIView* pullDownView;
@property (nonatomic) UIActivityIndicatorView *spinner;
@property (nonatomic) UIImageView *pullDownImageView;
@property (nonatomic) UILabel *pullDownInfoLabel;
@property (nonatomic) UILabel *pullDownTimeLabel;
@property (nonatomic) YelpDataSource* dataSource;
@property (nonatomic) NSMutableArray* businesses;
@property (nonatomic) NSMutableDictionary* cells;
@property (nonatomic) NSMutableArray* names;
@property (nonatomic) NSMutableArray* urls;
@property (nonatomic) NSMutableDictionary* images;

@property (nonatomic) UIImage* defaultImage;

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
        
        UIButton *upperButton = [[GestureButton alloc] initWithFrame:CGRectMake(COLLECTION_VIEW_HEADER_LEFT_WIDTH + COLLECTION_VIEW_HEADER_MARGIN*2  ,0 , self.view.frame.size.width-(COLLECTION_VIEW_HEADER_LEFT_WIDTH + COLLECTION_VIEW_HEADER_MARGIN*3), COLLECTION_VIEW_HEADER_UPPER_HEIGHT)];
        upperButton.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.5];
        [upperButton addTarget:self action:@selector(topButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *lowerButton = [[GestureButton alloc] initWithFrame:CGRectMake(COLLECTION_VIEW_HEADER_LEFT_WIDTH + COLLECTION_VIEW_HEADER_MARGIN*2, COLLECTION_VIEW_HEADER_UPPER_HEIGHT+COLLECTION_VIEW_HEADER_MARGIN, self.view.frame.size.width-(COLLECTION_VIEW_HEADER_LEFT_WIDTH + COLLECTION_VIEW_HEADER_MARGIN*3) , COLLECTION_VIEW_HEADER_HEIGHT - COLLECTION_VIEW_HEADER_UPPER_HEIGHT - COLLECTION_VIEW_HEADER_MARGIN)];
        [lowerButton addTarget:self action:@selector(bottomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        lowerButton.backgroundColor = [UIColor blueColor];
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
    
    if(![self.images objectForKey:@(idx)]){
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
                            [self.images setObject:[newImage copy] forKey:@(idx)];
                            //cell.image=[newImage copy];
                            cell.imageView.image=[self.images objectForKey:@(idx)];
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
        cell.imageView.image = [self.images objectForKey:@(idx)];
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
        if(offset>-PULLDOWN_VIEW_THRESHOLD){
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
}

#pragma mark - overall setup

//pull down view
-(UIView*)pullDownView{
    if(!_pullDownView){
        CGRect frame = CGRectMake(0, -0, self.view.frame.size.width,PULLDOWN_VIEW_HEIGHT);
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

-(YelpDataSource*)dataSource
{
    if(!_dataSource){
        _dataSource=[[YelpDataSource alloc] initWithQuery:@"food" andRegion:@"San Francisco"];
    }
    return _dataSource;
}

-(void)setup
{
    [self setupSearchBar];
    [self.dataSource fetchDataWithCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse * r = (NSHTTPURLResponse*)response;
        if(r.statusCode == 200){
            //NSLog(@"is successful");
            NSError * error;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error: &error];
            //NSLog(@"%@",json);
            self.businesses = [json valueForKey:@"businesses"];
            self.cells = [[NSMutableDictionary alloc] init];
            self.names=[[NSMutableArray alloc] init];
            self.urls=[[NSMutableArray alloc] init];
            self.images=[[NSMutableDictionary alloc] init];
            for(NSInteger i=0;i<[self.businesses count];i++){
                //NSLog(@"name is: %@",[self.businesses[i] valueForKey:@"name"]);
                NSString *name = [self.businesses[i] valueForKey:@"name"];
                NSString *urlStr = [self.businesses[i] valueForKey:@"image_url"];
                //CollectionViewCell * aCell=[[CollectionViewCell alloc] initWithName:name andURL:[NSURL URLWithString:urlStr]];
                //[self.cells setObject:aCell forKey:@(i)];
                
                [self.names addObject:name];
                [self.urls addObject:[NSURL URLWithString:urlStr]];
                
                //NSLog(@"the cells are %@, %@, %@",@(i),((CollectionViewCell*)[_cells objectForKey:@(i)]).name,((CollectionViewCell *)[_cells objectForKey:@(i)]).imageURL);
            }
            //call it on the main queue to refresh the screen immediately!!
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionVC.collectionView reloadData];
                //[self.collectionView reloadData];
            });
        }

        
    }];
    
}
-(NSString *)getCurrentDateTime
{
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@" MMM/dd/yyyy 'at' HH':'mm':'ss"];
    return [dateFormatter stringFromDate:date];
}

#pragma mark - life cycle methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.defaultImage=[UIImage imageNamed:@"apple image.jpg"];
    //self.view = [[GestureView alloc] init];
    //NSLog(@"default GR count is %ld",self.view.gestureRecognizers.count);
    self.view.frame = [UIScreen mainScreen].bounds;
    //[self.view setUserInteractionEnabled:YES];
    [self setup];
    //[self setupGestureRecognizer];
    [self collectionVC];
    //[UIView recursivePrintViewTree:self.view];
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    //[UIView recursivePrintViewTree:_collectionVC.collectionView];
    
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
