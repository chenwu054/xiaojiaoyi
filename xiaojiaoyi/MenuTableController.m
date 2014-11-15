//
//  MenuTableController.m
//  xiaojiaoyi
//
//  Created by chen on 9/13/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "MenuTableController.h"

#define BUTTON_CORNER_RADIUS 10.0f
@interface MenuTableController ()

@property (nonatomic) NSArray *category;
@property (nonatomic) NSArray *subtitles;
@property (nonatomic) NSArray *imageURLs;
@property (nonatomic) NSDictionary* categoryMapping;
@property (nonatomic) NSArray* quickDealCategory;
@property (nonatomic) NSArray* quickDealSubtitles;

@property (nonatomic) NSArray* yelpCategory;
@property (nonatomic) NSArray* yelpSubtitles;

@end

@implementation MenuTableController

#pragma mark - table view methods
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return section==0?self.quickDealCategory.count:self.yelpCategory.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section==0){
        return @"QuickDeal";
    }
    else{
        return @"Yelp";
    }
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell" forIndexPath:indexPath];
    //cell.textLabel.text=_category[row];
    
    if(indexPath.section==0){
        cell.textLabel.text=self.quickDealCategory[indexPath.row];
        cell.detailTextLabel.text=self.quickDealSubtitles[indexPath.row];
    }
    else{
        cell.textLabel.text=self.yelpCategory[indexPath.row];
        cell.detailTextLabel.text=self.yelpSubtitles[indexPath.row];
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"table view did select at %ld,%ld",indexPath.section,indexPath.row);
}

#pragma mark - search bar methods
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _searchStr = searchBar.text;
    NSLog(@"search string is: %@",_searchStr);
    [_searchBar resignFirstResponder];
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    _searchBar.text = nil;
    [_searchBar resignFirstResponder];
}

#pragma mark - gesture recognizer methods
-(void) tap:(UITapGestureRecognizer *)gesture
{
    
    NSLog(@"tap clicked");
    if([_searchBar isFirstResponder])
        [_searchBar resignFirstResponder];
    else
        NSLog(@"not first responder");
}

#pragma mark - button methods
-(void) buttonSetup
{
    [_buyButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_sellButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _sellButton.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    _buyButton.layer.cornerRadius = BUTTON_CORNER_RADIUS;
    [self buttonClicked:_buyButton];
    
}
-(void) buttonClicked:(id)sender
{
    if([sender isKindOfClass:[UIButton class]]){
        UIButton * button = (UIButton*)sender;
        if(button == _buyButton){
            _buyButton.backgroundColor = [UIColor whiteColor];
            _sellButton.backgroundColor = [UIColor grayColor];
            _isBuy=YES;
        }
        else if(button == _sellButton){
            _buyButton.backgroundColor=[UIColor grayColor];
            _sellButton.backgroundColor=[UIColor whiteColor];
            _isBuy=NO;
            
        }
        else{
            NSLog(@"error: button is neither buttons");
        }
    }
    else
        NSLog(@"error: sender if not button class");
}

#pragma mark - controller lifecycle 

-(void)categorySetup{
    
    self.quickDealCategory =[[NSArray alloc] initWithObjects:@"Arts & Crafts",@"Books, Mags, Music & Video",@"Electronics",@"Accessories and Jewelry",@"Clothing & Shoes",@"Home & Garden",@"Sporting Goods", nil];
    
    self.quickDealSymbol = [[NSArray alloc] initWithObjects:@"artsandcrafts",@"media",@"electronics",@"accessories,jewelry",@"menscloth,womenscloth",@"homeandgarden",@"sportgoods", nil];
    
    self.quickDealSubtitles=[[NSArray alloc] initWithObjects:@"costumes,embroidery,framing...",
                             @"bookstores,music,video game stores...",
                             @"computers,iPhones,laptops,tablets...",
                             @"bracelets,ear rings,necklaces,rings...",
                             @"kids,men,women,shoes,sports...",
                             @"appliances,home decor,mattresses,rugs...",
                             @"bikes,outdoor gear,sports wear...",nil];
    
    self.yelpCategory=[[NSArray alloc] initWithObjects:@"Active Life",@"Arts & Entertainment",@"Automotive",@"Beauty & Spas",@"Health & Medical",@"Services",@"Hotels & Travel",@"Nightlife",@"Pets",@"Restaurants", nil];
    
    self.yelpSymbol=[[NSArray alloc] initWithObjects:@"active",@"arts",@"auto",@"beautysvc",@"health",@"eventservices",@"hotelstravel",@"nightlife",@"pets",@"restaurants", nil];
    self.yelpSubtitles=[[NSArray alloc] initWithObjects:@"amusement parks,beaches,fishing,hiking...",
                        @"casinos,cinema,museums,opera & ballet...",
                        @"auto repair,car dealers,car wash,gas & service...",
                        @"cosmetics,hair salons,piercing,tanning...",
                        @"dentists,hospitals,massage therapy...",
                        @"bartenders,caterers,wedding planning...",
                        @"airports,hotels,resorts,tours,transportation...",
                        @"bars,comedy clubs,piano bars...",
                        @"pet adoption,pet services,veterinarians...",
                        @"American,Chinese,Mexican,sushi,vegetarian...",
                        nil];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self categorySetup];
    
    // Do any additional setup after loading the view.
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton =YES;

    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapGR];
    [self.tableView addGestureRecognizer:tapGR];
    [_bkg addGestureRecognizer:tapGR];
    //_tableView.delegate = self;
    _tableView.dataSource = self;
    [self buttonSetup];
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
