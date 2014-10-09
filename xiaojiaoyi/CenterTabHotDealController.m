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
#define TRANSITION_THRESHOLD 1

@interface CenterTabHotDealController ()

@end

@implementation CenterTabHotDealController

#pragma mark - collection view setup
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    NSLog(@"calling hit test");
//    
//    return self.view;
//}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"hot deal view touches began");
    //UITouch *touch = [touches anyObject];
    //CGPoint curLoc = [touch locationInView:self.view];
    //CGPoint prevLoc = [touch previousLocationInView:self.view];
   // NSLog(@"prevLoc is x=%f,y=%f and curLoc is x=%f,y=%f",prevLoc.x,prevLoc.y,curLoc.x,curLoc.y);
    
//    NSArray* gestures = self.view.gestureRecognizers;
//    for(int i=0;i<gestures.count;i++){
//        [gestures[i] touchesBegan:touches withEvent:event];
//    }
//    [self.nextResponder touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"hot deal view touches moved");
    //NSLog(@"touches size is %ld",touches.count);
    //CGPoint prevLoc = [[touches anyObject] previousLocationInView:self.view];
    //NSLog(@"hotdeal prevLoc x=%f ,y=%f",prevLoc.x,prevLoc.y);
    //CGPoint currentLoc = [[touches anyObject] locationInView:self.view];
    //NSLog(@"hotdeal currentLoc x=%f ,y=%f",currentLoc.x,currentLoc.y);
//    
//    NSArray* gestures = self.view.gestureRecognizers;
//    for(int i=0;i<gestures.count;i++){
//        [gestures[i] touchesMoved:touches withEvent:event];
//    }
//    [self.nextResponder touchesBegan:touches withEvent:event];
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSArray* gestures = self.view.gestureRecognizers;
//    for(int i=0;i<gestures.count;i++){
//        [gestures[i] touchesCancelled:touches withEvent:event];
//    }
//    [self.nextResponder touchesCancelled:touches withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSArray* gestures = self.view.gestureRecognizers;
//    for(int i=0;i<gestures.count;i++){
//        [gestures[i] touchesEnded:touches withEvent:event];
//    }
//    [self.nextResponder touchesEnded:touches withEvent:event];
    
}
-(UICollectionViewFlowLayout*) flowLayout
{
    if(!_flowLayout){
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumInteritemSpacing =5;
        _flowLayout.minimumLineSpacing = 5;
        _flowLayout.itemSize = CGSizeMake(140, 170);
    }
    return _flowLayout;
}

-(UICollectionViewController*)collectionVC
{
    if(!_collectionVC){
        
        _collectionVC = [[UICollectionViewController alloc] initWithCollectionViewLayout:self.flowLayout];
        CGFloat originY = _searchBar.frame.size.height + _searchBar.frame.origin.y;
        //NSLog(@"originY is %f",originY);
        CGRect collectionViewFrame = CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
        //NSLog(@"frame y is %f",collectionViewFrame.origin.y);
        
        _collectionVC.collectionView = [[GestureCollectionView alloc] initWithFrame:collectionViewFrame collectionViewLayout:self.flowLayout];
        
        NSArray *gestures = _collectionVC.collectionView.gestureRecognizers;
        for(int i=0;i<gestures.count;i++){
            UIGestureRecognizer* g= (UIGestureRecognizer*)gestures[i];
            //NSLog(@"gesture%d is %@",i,g);
            [g setCancelsTouchesInView: NO];
//            g.cancelsTouchesInView = NO;
        }
        _collectionVC.collectionView.frame = collectionViewFrame;
        //NSLog(@"frame origin y is %f",_collectionVC.collectionView.frame.origin.y);
        //_collectionVC.collectionView.frame=collectionViewFrame;
        
        _collectionVC.collectionView.delegate = self;
        _collectionVC.collectionView.dataSource = self;
        _collectionVC.collectionView.backgroundColor = [UIColor clearColor];
        [_collectionVC.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"hotDealCollectionViewCell"];
    }
    [self.view addSubview:_collectionVC.collectionView];
    [self addChildViewController:_collectionVC];
    [_collectionVC didMoveToParentViewController:self];
    return _collectionVC;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            size= CGSizeMake(100, 250);
        }
        else if(indexPath.row == 1)
        {
            size = CGSizeMake(150, 110);
        }
        else{
            size = CGSizeMake(150, 130);
        }
    }
    else{
        size = CGSizeMake(140, 170);
    }
    return size;
}

-collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UICollectionViewCell *cell;
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotDealCollectionViewCell" forIndexPath:indexPath];
    //NSLog(@"at index path: section = %ld row = %ld",indexPath.section,indexPath.row);

        //cell = [[UICollectionViewCell alloc] init];
        if(indexPath.section == 0){
            cell.backgroundColor = [UIColor greenColor];
        }
        else{
            cell.backgroundColor = [UIColor grayColor];
        }
    NSArray *gestures = cell.gestureRecognizers;
    for(int i=0;i<gestures.count;i++){
        UIGestureRecognizer* g= (UIGestureRecognizer*)gestures[i];
        //NSLog(@"gesture%d is %@",i,g);

        [g setCancelsTouchesInView: NO];
    }

    //NSLog(@"cell bounds is %f and %f",cell.bounds.size.width,cell.bounds.size.height);
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0){
        return 3;
    }
    else
        return 6;
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"!!highlighted item at section:%ld and row: %ld",indexPath.section,indexPath.row);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"!!selected item at section:%ld and row: %ld",indexPath.section,indexPath.row);
}
//=================================================
#pragma mark - search bar methods
-(void)setupSearchBar
{
    NSLog(@"width is%f",self.view.frame.size.width);
    
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
    
    [panGR setMaximumNumberOfTouches:1];
    [panGR setMinimumNumberOfTouches:1];
    
    [self.view addGestureRecognizer:swipeGR];
    [self.view addGestureRecognizer:panGR];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapGR];
}

-(void)showSearchBar
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _searchBar.frame = CGRectMake(0, TAB_BAR_HEIGHT, self.view.frame.size.width, SEARCH_BAR_HEIGHT);
    } completion:nil];
    
}
-(void)hideSearchBar
{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        _searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, SEARCH_BAR_HEIGHT);
    } completion:nil];
    
}
-(void)tap:(UITapGestureRecognizer*)gesture
{
    NSLog(@"HDC calling tap recognizer");
    if([_searchBar isFirstResponder])
        [_searchBar resignFirstResponder];
}

-(void)showOrHighSearchbarBySwipeGesture:(UISwipeGestureRecognizer*)gesture
{
    NSLog(@"HDC calling swipe recognizer and direction is %ld",gesture.direction);

    if(gesture.direction == UISwipeGestureRecognizerDirectionDown){
        [self showSearchBar];
    }
    else if(gesture.direction == UISwipeGestureRecognizerDirectionUp){
        [self hideSearchBar];
    }
}
-(void)showOrHideSearchBarByPanGesture:(UIPanGestureRecognizer*)gesture
{
    NSLog(@"HDV calling pan recognizer");
    UIGestureRecognizer*g = (UIGestureRecognizer *)_collectionVC.collectionView.gestureRecognizers[0];
    NSLog(@"collectionview gr's cancel touch:%d", g.cancelsTouchesInView);
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


#pragma mark - overall setup
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    static CGFloat yPos = 0;
//    if(scrollView.contentOffset.y - yPos > TRANSITION_THRESHOLD){
//        [self hideSearchBar];
//        yPos =scrollView.contentOffset.y;
//    }
//    else if(scrollView.contentOffset.y - yPos < -TRANSITION_THRESHOLD){
//        [self showSearchBar];
//        yPos = scrollView.contentOffset.y;
//    }

}

-(void)setup
{
    [self setupSearchBar];
    
}

#pragma mark - life cycle methods
//-(void)mainDelegatePanMethod:(UIPanGestureRecognizer *)gesture
//{
//    
//    if(gesture.state == UIGestureRecognizerStateChanged || gesture.state == UIGestureRecognizerStateBegan){
//        //NSLog(@"calling the pan gesture recognizer");
//        CGPoint transition  = [gesture translationInView: _mainDelegateView]; // ?
//        [self.mainVC slideWithTransition:transition ended:NO];
//        
//    }
//    else if(gesture.state==UIGestureRecognizerStateEnded){
//        CGPoint transition = [gesture translationInView: _mainDelegateView];
//        [self.mainVC slideWithTransition:transition ended:YES];
//    }
//    
//    //[_mainDelegateView.nextResponder
//}
//-(GestureView*)mainDelegateView
//{
//    if(!_mainDelegateView){
//        _mainDelegateView = [[GestureView alloc] initWithFrame:_collectionVC.collectionView.frame];
//    }
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self.mainVC action:@selector(reset)];
//    [_mainDelegateView addGestureRecognizer:tap];
//    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(mainDelegatePanMethod)];
//    [_mainDelegateView addGestureRecognizer:pan];
//    
//    
//    return _mainDelegateView;
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view = [[GestureView alloc] init];
    self.view.frame = [UIScreen mainScreen].bounds;
    //self.view.userInteractionEnabled = YES;
    [self setup];
    [self setupGestureRecognizer];
    [self collectionVC];
    //[UIView recursivePrintViewTree:self.view];
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
