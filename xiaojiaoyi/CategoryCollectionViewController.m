//
//  CategoryCollectionViewController.m
//  xiaojiaoyi
//
//  Created by chen on 10/14/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "CategoryCollectionViewController.h"
#define NAVIGATION_BAR_HEIGHT 60 
#define COLLECTION_VIEW_MARGIN 0
#define PULLDOWN_VIEW_THRESHOLD 50
#define REFRESH_OFFSET 20
#define REFRESH_LIMIT 5

@interface CategoryCollectionViewController ()

@property (nonatomic) UIView* pullDownView;
@property (nonatomic) UIActivityIndicatorView *spinner;
@property (nonatomic) UIImageView *pullDownImageView;
@property (nonatomic) UILabel *pullDownInfoLabel;
@property (nonatomic) UILabel *pullDownTimeLabel;

@property (nonatomic) UICollectionViewFlowLayout* flowLayout;
@property (nonatomic) YelpDataSource* dataSource;
@property (nonatomic) NSMutableArray* businesses;
@property (nonatomic) NSMutableDictionary* cells;

@property (nonatomic) UIImage* defaultImage;


@property (nonatomic) NSInteger batchNumber;
@property (nonatomic) NSString* queryString;
@property (nonatomic) NSString* categoryString;
@property (nonatomic) NSString* locationString;
@property (nonatomic) BOOL needToRefresh;

@property (nonatomic) NSString* latitude;
@property (nonatomic) NSString* longitude;
@property (nonatomic) NSIndexPath* selectedItem;
//@property (nonatomic) NSMutableArray* images;
@property (nonatomic) NSMutableDictionary* names;
@property (nonatomic) NSMutableDictionary* urls;
@property (nonatomic) NSMutableDictionary* images;
@property (nonatomic) NSMutableDictionary* locationLatitude;
@property (nonatomic) NSMutableDictionary* locationLongitude;
@property (nonatomic) NSMutableDictionary* locationAddress;
@property (nonatomic) NSMutableDictionary* phoneNumber;
@property (nonatomic) NSMutableDictionary* reviewCount;
@property (nonatomic) NSMutableDictionary* review;
@property (nonatomic) NSMutableDictionary* ratingImages;
@property (nonatomic) NSMutableDictionary* ratingImagesURL;
@property (nonatomic) NSMutableDictionary* categories;
@property (nonatomic) NSMutableDictionary* isClosed;
@property (nonatomic) NSMutableDictionary* reviewerImageURL;
//@property (nonatomic) NSMutableDictionary* reviewerImage;
@property (nonatomic) NSMutableSet* namesLoaded;

@end

@implementation CategoryCollectionViewController

#pragma mark - touch event methods
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.nextResponder touchesBegan:touches withEvent:event];
    //NSLog(@"category view touches began");
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

}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"category view gesture cancelled");
    //[self tap:nil];
    [super touchesCancelled:touches withEvent:event];
    [self.nextResponder touchesCancelled:touches withEvent:event];
    [self.view.superview touchesCancelled:touches withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"category view gesture ended");
    //[self tap:nil];
    [super touchesEnded:touches withEvent:event];
    [self.nextResponder touchesEnded:touches withEvent:event];
    if(self.mainVC){
        //NSLog(@"main view is reset: %d",self.mainVC.isReset);
        //if(!self.mainVC.isReset){
        [self.mainVC resetWithCenterView:self.mainVC.mainContainerView];//???
        //}
    }
    [self.view.superview touchesEnded:touches withEvent:event];
}

#pragma mark - collection view layout methods
-(UICollectionViewFlowLayout*) flowLayout
{
    //NSLog(@"calling flow layout");
    if(!_flowLayout){
        _flowLayout = [[CenterCollectionViewFlowLayout alloc] init];
        //        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumInteritemSpacing =0;
        _flowLayout.minimumLineSpacing = 5;
        _flowLayout.itemSize = CGSizeMake(150, 170);
        
        //H3.need to set header referenceSize to nonZeroSize to show the header!
        _flowLayout.footerReferenceSize = CGSizeMake(self.view.frame.size.width,50);
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
    //this method determines the cell size
    //NSLog(@"! calling layout for item at index path");
    CGSize size = CGSizeMake(145, 170);
    return size;
}
//set Header and Footer
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"! calling viewForSupplymentary elements at index path");
    //Header2. calling the supplementary view
    UICollectionReusableView*view = nil;
    
    if(kind == UICollectionElementKindSectionFooter){
        view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"CategoryCollectionViewFooter" forIndexPath:indexPath];
        if(!view){
            view =[[GestureCollectionReusableView alloc] init];
        }
        view.backgroundColor = [UIColor lightGrayColor];
        CGFloat footerOriginY=self.collectionVC.collectionView.frame.origin.y + self.collectionVC.collectionView.frame.size.height;
        //NSLog(@"footer origin y is %f",footerOriginY);
        view.frame = CGRectMake(0,footerOriginY , self.view.frame.size.width, 20);
        [self.collectionVC.collectionView addSubview:view];
    }
    return view;
}
//collecion view controller setup
#pragma mark - collection view controller methods
-(UICollectionViewController*)collectionVC
{
    //NSLog(@"! calling collectionVC");
    if(!_collectionVC){
        _collectionVC = [[UICollectionViewController alloc] init]; //initWithCollectionViewLayout:self.flowLayout];
        CGRect collectionViewFrame = CGRectMake(COLLECTION_VIEW_MARGIN, NAVIGATION_BAR_HEIGHT, self.view.frame.size.width -2*COLLECTION_VIEW_MARGIN, self.view.frame.size.height - NAVIGATION_BAR_HEIGHT - 0);
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
        [_collectionVC.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"CategoryCollectionCell"];
        
        //Header1.register the header
        //[_collectionVC.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CenterHotDealCollectionViewHeader"];
        [_collectionVC.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"CategoryCollectionViewFooter"];
        
        //        NSArray *gestures = _collectionVC.collectionView.gestureRecognizers;
        //        for(int i=0;i<gestures.count;i++){
        //            UIGestureRecognizer* g= (UIGestureRecognizer*)gestures[i];
        //            /*this method is of no use. because GR by default can only respond to one gesture,even on different views, as long as they are in the same part area on the screen. Cannot customize UIScrollView's gesture recognizer's delegate
        //            */
        //            [g setCancelsTouchesInView: NO];
        //        }
        
        //NSLog(@"frame origin y is %f",_collectionVC.collectionView.frame.origin.y);
        //_collectionVC.collectionView.frame=collectionViewFrame;
        //view controller container
        [self.view addSubview:_collectionVC.collectionView];
        [self addChildViewController:_collectionVC];
        [_collectionVC didMoveToParentViewController:self];
    }
    return _collectionVC;
}

//collection view data source methods
-(UICollectionViewCell*) collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"! calling cell in collection view");
    CollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CategoryCollectionCell" forIndexPath:indexPath];
    if(!cell){
        cell=[[CollectionViewCell alloc] init];
    }
    if(!cell.imageView){
        cell.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.width)];
    }
    if(!cell.label){
        cell.label=[[UILabel alloc] initWithFrame:CGRectMake(2, cell.frame.size.width, cell.frame.size.width, cell.frame.size.height-cell.frame.size.width)];
    }
    
    [cell.layer setBorderWidth:2.0f];
    [cell.layer setBorderColor:[[UIColor blueColor] CGColor]];
    [cell.layer setShadowRadius:5];
    [cell.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [cell.layer setCornerRadius:5.0f];
    cell.backgroundColor=[UIColor lightGrayColor];
    
    cell.imageView.layer.cornerRadius=5.0;
    
    if(cell.imageView.superview != cell){
        [cell addSubview:cell.imageView];
    }
    if(cell.label.superview !=cell){
        [cell addSubview:cell.label];
    }
    NSString*idx = [NSString stringWithFormat:@"%ld",indexPath.row];
    if(self.images[idx] && self.images[idx]==self.defaultImage){
        cell.imageView.image = self.defaultImage;
        cell.label.text = [NSString stringWithFormat:@""];
        
        if(self.urls[idx]){
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
                        self.images[idx]=[newImage copy];
                        //cell.image=[newImage copy];
                        cell.imageView.image=self.images[idx];
                        cell.label.text=self.names[idx];
                        cell.hasImage=YES;
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionVC.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
                    });
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
    //NSLog(@"cell height is %f, cell width is %f",cell.frame.size.height,cell.frame.size.width);
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //NSLog(@"! calling number of items in section: %ld",self.urls.count);
    return self.urls.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //NSLog(@"! calling number of sections");
    return 1;
}
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    //[self tap:nil];
    NSLog(@"!!highlighted item at section:%ld and row: %ld",indexPath.section,indexPath.row);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(![self.mainVC isReset]){
        [self.mainVC reset];
    }
    else{
        NSLog(@"!!selected item at section:%ld and row: %ld",indexPath.section,indexPath.row);
        self.selectedItem=indexPath;
        [self.mainVC performSegueWithIdentifier:@"YelpDetailPushSegue" sender:self];
    }
}

#pragma mark - scroll view methods
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"!calling scroll");
    CGFloat offset = [_collectionVC.collectionView contentOffset].y;
    //NSLog(@"content off set is %f",offset);
    if( self.batchNumber <= REFRESH_LIMIT && offset > ((self.names.count%2==1?self.names.count+1:self.names.count)/2 - 2)*175 + REFRESH_OFFSET){
        if(self.needToRefresh){
            //NSLog(@"call to refresh");
           // [self refreshDataWithQuery:self.query category:self.category andLocation:self.location offset:[NSString stringWithFormat:@"%ld",self.offset]];
            
            //note: offset + 1 is the new offset
            //[self refreshDataWithLocationAndQuery:self.query category:self.category offset:[NSString stringWithFormat:@"%ld",self.offset+1]];
            [self refreshDataWithLocationAndQuery:self.query category:self.category offset:[NSString stringWithFormat:@"%ld",self.batchNumber*20]];
            //NSLog(@"calling to refresh with offset: %ld",self.offset+1);
            
            self.needToRefresh=NO;
        }
    }
    
}

-(void)pushToYelpDetailViewController:(YelpDetailViewController*)yelpDetailVC
{
    CLLocationCoordinate2D coordinate;
    NSString* offsetString= [NSString stringWithFormat:@"%ld",self.selectedItem.row];
    NSNumber* latitude = self.locationLatitude[offsetString];
    NSNumber* longitude = self.locationLongitude[offsetString];
    coordinate.latitude = latitude.doubleValue;
    coordinate.longitude = longitude.doubleValue;
    
    Location *annotation = [[Location alloc] initWithName:self.names[offsetString] Location:coordinate];
    yelpDetailVC.pins=[[NSMutableArray alloc] init];
    [yelpDetailVC.pins addObject:annotation];
    //NSLog(@"latitude is %@,longitude is %@",self.locationLatitude[idx],self.locationLongitude[idx]);
    //[yelpDetailVC clear];
    yelpDetailVC.image=self.images[offsetString];
    yelpDetailVC.titleString = self.names[offsetString];
    yelpDetailVC.address = self.locationAddress[offsetString];
    yelpDetailVC.photoNumber = self.phoneNumber[offsetString];
    yelpDetailVC.reviewCount = self.reviewCount[offsetString];
    yelpDetailVC.review = self.review[offsetString];
    yelpDetailVC.ratingImageURL=self.ratingImagesURL[offsetString];
    yelpDetailVC.isClosed = self.isClosed[offsetString];
    yelpDetailVC.category = self.categories[offsetString];
    yelpDetailVC.title=self.names[offsetString];
    yelpDetailVC.reviewImageURLString = self.reviewerImageURL[offsetString];
    
    //NSLog(@"push to Yelp Detail View Controller");
}
#pragma mark - segue preparation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"YelpDetailPushSegue"]){

        NSLog(@"is YelpDetailPushSegue");
    }
}
//=============
#pragma mark - property setup methods
-(void)setLatitude:(NSString*)latitude andLongtitude:(NSString*)longitude
{
    self.latitude=latitude;
    self.longitude=longitude;
    [self.dataSource setLocationLatitude:latitude andLongitude:longitude];
    
}
-(UINavigationBar *)navigationBar
{
    if(!_navigationBar){
        _navigationBar = [[UINavigationBar alloc] init];
    }
    _navigationBar.frame = CGRectMake(0,0,self.view.frame.size.width,NAVIGATION_BAR_HEIGHT);
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
-(YelpDataSource*)dataSource
{
    if(!_dataSource){
        _dataSource=[[YelpDataSource alloc] init];
    }
    return _dataSource;
}
-(NSMutableDictionary*)names
{
    if(!_names){
        _names=[[NSMutableDictionary alloc] init];
    }
    return _names;
}
-(NSMutableDictionary*)urls
{
    if(!_urls){
        _urls=[[NSMutableDictionary alloc] init];
    }
    return _urls;
}
-(NSMutableDictionary*)images
{
    if(!_images){
        _images=[[NSMutableDictionary alloc] init];
    }
    return _images;
}

-(void)clear
{
    NSLog(@"! calling clear");
    //delete all the current cells, need to reset the arrays first before deleting all the indexPaths,
    //because iOS will call to check how many cells in the section. If delete first, then reset array, before the arrays are reset, iOS checks the number
    //it will still be nonzero. This will cause mismatch and iOS will through exception about this mismatch: number before update(insert and delete) +/- number inserted/deleted should be equal to the number after the update!
    NSInteger count = self.urls.count;
    NSInteger collectionViewCellNumber = [self collectionView:self.collectionVC.collectionView numberOfItemsInSection:0];
    if(count!=collectionViewCellNumber){
        NSLog(@"count != collectionViewCellNumber: %ld,%ld",count,collectionViewCellNumber);
        count = MIN(count,collectionViewCellNumber);
    }
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
//    [self.reviewerImage removeAllObjects];
    [self.reviewerImageURL removeAllObjects];
    [self.namesLoaded removeAllObjects];
    
    self.offset=0;
    self.batchNumber=0;
    self.needToRefresh=true;
    NSIndexPath* idx=nil;//[NSIndexPath indexPathForRow:self.urls.count-1 inSection:0];
    NSMutableArray* indices = [[NSMutableArray alloc] init];
    for(int i=0;i<count;i++){
        idx=[NSIndexPath indexPathForRow:i inSection:0];
        [indices addObject:idx];
    }
    if(indices.count>0){
        [self.collectionVC.collectionView deleteItemsAtIndexPaths:indices];
    }
    
    
}

//not used!!
//-(void)refreshDataWithQuery:(NSString*)query category:(NSString*)category andLocation:(NSString*)location offset:(NSString*)offset
//{
//    NSLog(@"!calling refresh");
//    self.query=query;
//    self.category=category;
//    self.location=location;
//    
//    [self.dataSource setQuery:query category:category location:location offset:offset?offset:@"0"];
//    [self.dataSource fetchDataWithCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSHTTPURLResponse * r = (NSHTTPURLResponse*)response;
//        //NSLog(@"response is %@",response);
//        //NSLog(@"error is %@",error);
//        if(r.statusCode == 200){
//            //NSLog(@"is successful");
//            NSError * error;
//            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error: &error];
//            //NSLog(@"%@",json);
//            self.businesses = [json valueForKey:@"businesses"];
//            NSInteger itemAddedNum = 0;
//            for(NSInteger i=0;i<[self.businesses count];i++){
//                //NSLog(@"name is: %@",[self.businesses[i] valueForKey:@"name"]);
//                NSString *name = [self.businesses[i] valueForKey:@"name"];
//                NSString *urlStr = [self.businesses[i] valueForKey:@"image_url"];
//                //!! NSMutableArray cannot add nil object.
//                if(name && urlStr && ![urlStr isEqualToString:@""]){
//                    [self.names addObject:name];
//                    [self.urls addObject:[NSURL URLWithString:urlStr]];
//                    itemAddedNum=itemAddedNum+1;//self.businesses.count; //self.batchNumber*20-1;
//                }
//            }
//            self.batchNumber=self.batchNumber+1;
//            itemAddedNum = self.offset + itemAddedNum;
//            self.offset=itemAddedNum;
//            
//            NSLog(@"batch is %ld and offset is %ld",self.batchNumber,self.offset);
//
//            self.needToRefresh=YES;
//            NSLog(@"busnesses count is %ld",self.businesses.count);
//            //call it on the main queue to refresh the screen immediately!!
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.collectionVC.collectionView reloadData];
//                if(self.freshStart){
//                    
//                    //need to scroll back to the top every time a new request is sent.
//                    if(self.urls.count>0){
//                        [self.collectionVC.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
//                        self.freshStart=NO;
//                    }
//                }
//                //[self.collectionView reloadData];
//            });
//        }
//    }];
//}

//use this method
-(void)refreshDataWithLocationAndQuery:(NSString*)query category:(NSString*)category offset:(NSString*)offset
{
    //NSLog(@"!calling refresh with location");
    self.query=query;
    self.category=category;
    [self.dataSource setQuery:query category:category location:nil offset:offset?offset:[NSString stringWithFormat:@"%ld",self.offset]];
    [self.dataSource fetchDataWithLocationAndOffset:offset andCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse * r = (NSHTTPURLResponse*)response;
        //NSLog(@"response is %@",response);
        //NSLog(@"error is %@",error);
        if(r.statusCode == 200){
            //NSLog(@"is successful");
            NSError * error;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error: &error];
            //NSLog(@"%@",json);
            self.businesses = [json valueForKey:@"businesses"];
            for(NSInteger i=0;i<[self.businesses count];i++){
                //NSLog(@"name is: %@",[self.businesses[i] valueForKey:@"name"]);
                NSString *name = [self.businesses[i] valueForKey:@"name"];
                NSString *urlStr = [self.businesses[i] valueForKey:@"image_url"];
                NSDictionary* location = [[self.businesses[i] valueForKey:@"location"] valueForKey:@"coordinate"];
                NSNumber* latitude=(NSNumber*)[location valueForKey:@"latitude"];
                NSNumber* longitude=(NSNumber*)[location valueForKey:@"longitude"];
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
                NSString* reviewerImageURL = [self.businesses[i] valueForKey:@"snippet_image_url"];
                
                NSMutableString* categoryString = [[NSMutableString alloc] init];
                NSArray* subCategoryArr=nil;
                for(int i=0;i<categories.count-1;i++){
                    subCategoryArr = categories[i];
                    [categoryString appendString:[NSString stringWithFormat:@"%@, ",subCategoryArr[0]]];
                }
                subCategoryArr = categories[categories.count-1];
                [categoryString appendString:[NSString stringWithFormat:@"%@",subCategoryArr[0]]];
                
                //!! NSMutableArray cannot add nil object.
                if(name && ![self.namesLoaded containsObject:name] && urlStr && latitude && longitude && address &&address.length>0){
//                    [self.names addObject:name];
                    NSString* offsetString = [NSString stringWithFormat:@"%ld",self.offset];
                    self.names[offsetString]=name;
                    [self.namesLoaded addObject:name];
//                    [self.urls addObject:[NSURL URLWithString:urlStr]];
                    self.urls[offsetString]=[NSURL URLWithString:urlStr];
//                    [self.locationLatitude addObject:latitude];
                    self.locationLatitude[offsetString]=latitude;
//                    [self.locationLongitude addObject:longitude];
                    self.locationLongitude[offsetString]=longitude;
//                    [self.locationAddress addObject:address];
                    self.locationAddress[offsetString]=address;
                    //NSLog(@"address is %@",address);
//                    [self.images addObject:self.defaultImage];
                    self.images[offsetString]=self.defaultImage;
                    if(reviewerImageURL)
                        self.reviewerImageURL[offsetString] = reviewerImageURL;//?reviewerImageURL:@"";
                    if(phoneNumber)
                        self.phoneNumber[offsetString]=phoneNumber;//?phoneNumber:@"";
//                        [self.phoneNumber addObject:phoneNumber];
                    if(reviewNumber)
                        self.reviewCount[offsetString]=reviewNumber;//?reviewNumber:0;
//                        [self.reviewCount addObject:reviewNumber];
                    if(review)
                        self.review[offsetString]=review;//?review:@"";
//                        [self.review addObject:review];
                    if(ratingImageURL)
                        self.ratingImagesURL[offsetString]=ratingImageURL;//?ratingImageURL:@"";
//                        [self.ratingImagesURL addObject:ratingImageURL];
                    self.ratingImages[offsetString]=self.defaultImage;
//                    [self.ratingImages addObject:self.defaultImage];
                    if(isClosed)
                        self.isClosed[offsetString]=isClosed;//?isClosed:@1;
//                        [self.isClosed addObject:isClosed];
                    if(categoryString)
                        self.categories[offsetString]=categoryString;//?categoryString:@"";
//                        [self.categories addObject:categoryString];
                    self.offset=self.offset+1;
                }
                else{
                    nil;
//                    if(name==nil)
//                        NSLog(@"ooops! an item is NOT added due to lack of name");
//                    
//                    //mostly urlStr is missing, so these items are neglected
//                    if(urlStr==nil)
//                        NSLog(@"ooops! an item is NOT added due to lack of url string");
//                    if(latitude==nil)
//                        NSLog(@"ooops! an item is NOT added due to lack of latitude");
//                    if(longitude==nil)
//                        NSLog(@"ooops! an item is NOT added due to lack of longitude");
//                    if(address==nil)
//                        NSLog(@"ooops! an item is NOT added due to lack of address");
//                    if(address.length==0)
//                        NSLog(@"ooops! an item is NOT added due to lack of address length == 0");
                }
            }
            //NSLog(@"url count is %ld",self.urls.count);
            //TODO: fetch offset is different from current offset, otherwise the following batch would have few distinct items to list,use self.batchNumber * 20 as the fetch offset and use self.offset as the number;
            //
            self.batchNumber=self.batchNumber+1;
            //NSLog(@"batch is %ld",self.batchNumber);
            self.needToRefresh=YES;
            //call it on the main queue to refresh the screen immediately!!
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionVC.collectionView reloadData];
                if(self.freshStart){
                    //need to scroll back to the top every time a new request is sent.
                    if(self.urls.count>0){
                        [self.collectionVC.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
                        self.freshStart=NO;
                    }
                }
                //[self.collectionView reloadData];
            });
        }
    }];
    
}


-(void)setup
{
    [self navigationBar];
    [self.view addSubview:_navigationBar];
    [self collectionVC];
    self.defaultImage=[UIImage imageNamed:@"apple image.jpg"];
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.queryString=@"";
    
//    self.names=[[NSMutableArray alloc] init];
//    self.urls=[[NSMutableArray alloc] init];
//    self.images=[[NSMutableArray alloc] init];
//    self.locationAddress=[[NSMutableArray alloc] init];
//    self.locationLatitude=[[NSMutableArray alloc] init];
//    self.locationLongitude = [[NSMutableArray alloc] init];
//    self.categories = [[NSMutableArray alloc] init];
//    self.phoneNumber = [[NSMutableArray alloc] init];
//    self.review = [[NSMutableArray alloc] init];
//    self.reviewCount = [[NSMutableArray alloc] init];
//    self.ratingImagesURL = [[NSMutableArray alloc] init];
//    self.ratingImages = [[NSMutableArray alloc] init];
//    self.isClosed= [[NSMutableArray alloc] init];
    
    self.names=[[NSMutableDictionary alloc] init];
    self.urls=[[NSMutableDictionary alloc] init];
    self.images=[[NSMutableDictionary alloc] init];
    self.locationAddress=[[NSMutableDictionary alloc] init];
    self.locationLatitude=[[NSMutableDictionary alloc] init];
    self.locationLongitude = [[NSMutableDictionary alloc] init];
    self.categories = [[NSMutableDictionary alloc] init];
    self.phoneNumber = [[NSMutableDictionary alloc] init];
    self.review = [[NSMutableDictionary alloc] init];
    self.reviewCount = [[NSMutableDictionary alloc] init];
    self.ratingImagesURL = [[NSMutableDictionary alloc] init];
    self.ratingImages = [[NSMutableDictionary alloc] init];
    self.isClosed= [[NSMutableDictionary alloc] init];
    self.reviewerImageURL=[[NSMutableDictionary alloc] init];
//    self.reviewerImage=[[NSMutableDictionary alloc] init];
    self.namesLoaded=[[NSMutableSet alloc] init];
    
    self.offset=0;
    //[self clear];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"calling category controller view did load");
    [self setup];
}

-(NSString *)getCurrentDateTime
{
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@" MMM/dd/yyyy 'at' HH':'mm':'ss"];
    return [dateFormatter stringFromDate:date];
}


//-(void)setBackgroundColor:(UIColor*)color
//{
//    UIColor *newColor = [UIColor colorWithRed:(arc4random()%256)/256.0 green:(arc4random()%256)/256.0 blue:(arc4random()%256)/256.0 alpha:1.0];
//    //NSLog(@"color: %@",newColor);
//    self.view.backgroundColor = newColor;
//}
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
