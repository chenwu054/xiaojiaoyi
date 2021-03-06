//
//  DataModalUtils.m
//  xiaojiaoyi
//
//  Created by chen on 10/22/14.
//  Copyright (c) 2014 com.practice. All rights reserved.
//

#import "DataModalUtils.h"
#import "Deal.h"
#import "User.h"
#import "OAuthToken.h"

@interface DataModalUtils ()
@property (nonatomic) NSURL* documentsURL;
@property (nonatomic) NSURL* myDealsURL;
@property (nonatomic) NSString* myDealsRelativeURL;
//@property (nonatomic) NSURL* boughtDealsURL;
//@property (nonatomic) NSURL* soundTrackMyDealsURL;
//@property (nonatomic) NSURL* soundTrackBoughtDealsURL;
//@property (nonatomic) NSString* soundTrackMyDealsRelativeURL;
//@property (nonatomic) NSString* soundTrackBoughtDealsRelativeURL;
//
//
//@property (nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;
//@property (nonatomic) NSManagedObjectModel* managedObjectModel;
//
////@property (nonatomic) UIManagedDocument* myDealsManagedDocument;
//@property (nonatomic) UIManagedDocument* boughtDealsManagedDocument;

@property (nonatomic) NSManagedObjectContext*  myDealsContext;
//@property (nonatomic) NSManagedObjectContext* boughtDealsContext;
//@property (nonatomic) NSString* filename;
//
//
@property (nonatomic) NSMutableDictionary* managedDocumentDictionary;
@property (nonatomic) NSMutableDictionary* managedContextDictionary;


@end

@implementation DataModalUtils
static DataModalUtils* singleton;
static NSString* defaultUserId=@"user123";
@synthesize userId=_userId;


#pragma mark - setup methods


+(DataModalUtils*)sharedInstance
{
    if(!singleton){
        singleton = [[DataModalUtils alloc] init];
    }
    return singleton;
}
-(void)updateUserId:(NSString*)userId;
{
    if(!userId || [userId isEqualToString:@""])
        return;
    
    self.userId=userId;
    
}
-(void)setUserId:(NSString *)userId
{
    _userId=userId;
    [self coredataSetup];
}
-(NSString*)userId
{
    if(!_userId){
        _userId=defaultUserId;//default userID;
    }
    return _userId;
}
-(void)coredataSetup
{
    self.myDealsContext=[self getMyDealsContextWithUserId:_userId];
    
}

-(NSManagedObjectContext*)getMyDealsContextWithUserId:(NSString*)userId
{
    NSString*newUserId = userId;
    if(!newUserId){
        newUserId=defaultUserId;
    }
    NSManagedObjectContext * context= self.managedContextDictionary[newUserId];
    if(!context){
        context=[self getMyDealsDocumentWithUserId:newUserId].managedObjectContext;
        [self.managedContextDictionary setObject:context forKey:newUserId];
    }
    return context;
}

-(BOOL)validateDeal:(Deal*)deal
{
    if(!deal.user_id_created)
        return false;
    if(!deal.deal_id)
        return false;
    if(!deal.title || !deal.price || !(deal.sound_url||deal.describe))
        return false;
    
    return true;
}

-(void)updateMyDeal:(Deal*)deal withNewDeal:(Deal*)newDeal
{
    if(!deal.managedObjectContext){
        NSLog(@"deal update has NO context");
    }
    [deal setValue:newDeal.title forKey:@"title"];
    [deal setValue:newDeal.price forKey:@"price"];
    [deal setValue:newDeal.shipping forKey:@"shipping"];
    [deal setValue:newDeal.describe forKey:@"describe"];
    [deal setValue:newDeal.create_date forKey:@"create_date"];
    [deal setValue:newDeal.expire_date forKey:@"expire_date"];
    [deal setValue:newDeal.exchange forKey:@"exchange"];
    [deal setValue:newDeal.sound_url forKey:@"sound_url"];
    [deal setValue:newDeal.condition forKey:@"condition"];
    [deal setValue:newDeal.insured forKey:@"insured"];
    [deal setValue:newDeal.latitude forKey:@"latitude"];
    [deal setValue:newDeal.longitude forKey:@"longitude"];
    [deal setValue:newDeal.user_id_bought forKey:@"user_id_bought"];
    [deal setValue:newDeal.user_id_created forKey:@"user_id_created"];
    
    [deal.managedObjectContext save:NULL];
}
-(void)insertMyDeal:(Deal*)deal
{
    [self insertMyDeal:deal toUserId:self.userId];
    
}
-(void)insertMyDeal:(Deal*)deal toUserId:(NSString*)userId
{
    NSManagedObjectContext* context = self.managedContextDictionary[userId];
    if(!context)
        return;
    
    [context insertObject:deal];
}
//wrong
-(void)insertMyDeal:(Deal*)deal withAutoDealIdToUserId:(NSString *)userId
{
    Deal* newDeal = [NSEntityDescription insertNewObjectForEntityForName:@"Deal" inManagedObjectContext:self.managedContextDictionary[userId]];
    newDeal.title=deal.title;
    newDeal.price=deal.price;
    newDeal.exchange=deal.exchange;
    newDeal.shipping=deal.shipping;
    newDeal.create_date=deal.create_date;
    newDeal.expire_date=deal.expire_date;
    newDeal.insured=deal.insured;
    newDeal.condition=deal.condition;
    newDeal.sound_url=deal.sound_url;
    newDeal.describe=deal.describe;
    newDeal.latitude=deal.latitude;
    newDeal.longitude=deal.longitude;
    newDeal.user_id_created=deal.user_id_created;
    newDeal.user_id_bought=deal.user_id_bought;
    
    //newDeal.deal_id=[NSNumber numberWithInteger:dealId++];
    
}
-(NSArray*)queryForDealsWithUserId:(NSString*)userId predicate:(NSPredicate*)predicate andSortDescriptors:(NSArray*)descriptors
{
    self.userId=userId;
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSEntityDescription* entityDescribe = [NSEntityDescription entityForName:@"Deal" inManagedObjectContext:self.myDealsContext];
    [request setEntity:entityDescribe];
    //    request.fetchBatchSize=5;
    request.fetchLimit=20;
    request.predicate=predicate;
    request.sortDescriptors=descriptors;
    NSError* error;
    NSArray* deals = [self.myDealsContext executeFetchRequest:request error:&error];
    return deals;
}

-(void)deleteMyDeal:(Deal*)deal FromUserId:(NSString*)userId
{
    NSManagedObjectContext* context = self.managedContextDictionary[userId];
    if(!context)
        return;
    
    [context deleteObject:deal];
}
/*
 UIDocumentSaveForCreating will create the newFileName(directory) and create persistent store under this dir.
 if there newFileName already exists, then the create will fail.
 Solution, test file does NOT exist at the location, then create all the intermediate dir right before its parent dir.
 */
-(UIManagedDocument*)getMyDealsDocumentWithUserId:(NSString*)userId
{
    NSURL* filePath = [self.myDealsURL URLByAppendingPathComponent:userId isDirectory:NO];
    UIManagedDocument* doc = self.managedDocumentDictionary[userId];
    
    //NSLog(@"T");
    if(!doc){
        doc= [[UIManagedDocument alloc] initWithFileURL:filePath];
        doc.persistentStoreOptions=@{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
        
        //add to the dictionary
        [self.managedDocumentDictionary setObject:doc forKey:userId];
    }
    NSURL* storageContentURL=[filePath URLByAppendingPathComponent:@"StoreContent"];
    BOOL isDir = NO;
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath.path isDirectory:&isDir] || ![[NSFileManager defaultManager] fileExistsAtPath:storageContentURL.path]){
        //first time creation
        [[NSFileManager defaultManager] createDirectoryAtPath:self.myDealsURL.path withIntermediateDirectories:YES attributes:nil error:NULL];
        [doc saveToURL:filePath forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if(success){
                NSLog(@"new CoreData document at path %@ is created",filePath);
            }
            else{
                NSLog(@"!!!ERROR: couldnot save to path %@",filePath);
            }
            
        }];
    }
    
    //if not opened, should add error handling for other states!
    if(doc.documentState==UIDocumentStateClosed){
        [doc openWithCompletionHandler:^(BOOL success) {
            if(!success){
                NSLog(@"!!!ERROR: documents file open failed");
            }
            //NSLog(@"document at path %@ is opened",doc);
        }];
    }
    else if(doc.documentState==UIDocumentStateEditingDisabled){
        NSLog(@"managed document disabled, try later");
    }
    
//    NSDictionary* options = doc.persistentStoreOptions;
//    for(NSString* k in options){
//        NSLog(@"k=%@, v = %@",k,options[k]);
//    }
    return doc;
}

-(BOOL)deleteMyDealStoredDataWithDealId:(NSString*)dealId
{
    NSURL* url =[[self.documentsURL URLByAppendingPathComponent:[self myDealsDataRelativeURL]] URLByAppendingPathComponent:dealId];
    
    BOOL isDir = YES;
    if([[NSFileManager defaultManager] fileExistsAtPath:url.path isDirectory:&isDir]){
        return [[NSFileManager defaultManager] removeItemAtURL:url error:NULL];
    }
    else
        return YES;
    
}

-(void)contextChanged:(NSNotification*)notification
{
    NSLog(@"context changed");
}
-(void)contextSaved:(NSNotification*)notification
{
    NSLog(@"context saved");
    
}
//-(void)addNotificationForUserId:(NSString*)userId
//{
//    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center addObserver:self selector:@selector(contextChanged:) name:NSManagedObjectContextObjectsDidChangeNotification object:self.myDealsContext];
//    
//    [center addObserver:self selector:@selector(contextSaved:) name:NSManagedObjectContextDidSaveNotification object:self.myDealsContext];
//}
//-(void)deleteNotificationForUserId:(NSString*)userId
//{
//    NSNotificationCenter* center=[NSNotificationCenter defaultCenter];
//    [center removeObserver:self];
//}

#pragma mark - sound track methods
//-(void)writeMyDealsSoundTrack:(NSData*)data forFilename:(NSString*)filename
//{
//    NSURL* myDealSoundTrackURL = [self.soundTrackMyDealsURL URLByAppendingPathComponent:filename];
//    BOOL success = [data writeToURL:myDealSoundTrackURL atomically:YES];
//    if(!success){
//        NSLog(@"sound track write to url failed");
//    }
//}
//-(NSData*)readMyDealsSoundTrack:(NSData*)date forFilename:(NSString*)filename
//{
//    NSURL* myDealSoundTrackURL=[self.soundTrackMyDealsURL URLByAppendingPathComponent:filename];
//    NSData* data=[NSData dataWithContentsOfFile:myDealSoundTrackURL.path];
//    return  data;
//}

#pragma mark - url methods
-(NSString*)myDealsDataRelativeURL
{
    //NSURL* dataURL = [self.myDealsRelativeURL URLByAppendingPathComponent:@"data" isDirectory:YES];
    NSString* dataURL = [NSString stringWithFormat:@"%@/data", self.myDealsRelativeURL];
    return dataURL;
}
-(NSURL*)myDealsURL
{
    if(!_myDealsURL){
        
//        NSString* myDealDir=@"Deals/MyDeals";
//        NSURL* docDir=self.documentsURL;
        _myDealsURL = [[self documentsURL] URLByAppendingPathComponent:[self myDealsRelativeURL] isDirectory:YES];//[docDir URLByAppendingPathComponent:myDealDir isDirectory:YES];
    }
    return _myDealsURL;
}

-(NSString*)myDealsRelativeURL
{
    if(!_myDealsRelativeURL){
        _myDealsRelativeURL = @"Deals/MyDeals";
    }
    return _myDealsRelativeURL;
}
//-(NSURL*)createDataURLWithFilename:(NSString*)filename
//{
//    NSURL* url=[self myDealsDataURL];
//    return [url URLByAppendingPathComponent:filename];
//}
-(NSString*)createRelativeDataURLWithFilename:(NSString*)filename
{
    NSString* url=[self myDealsRelativeURL];
    
    return [NSString stringWithFormat:@"%@/%@",url,filename];
}
-(void)deleteDirAtURL:(NSURL*)dir
{
    BOOL success = [[NSFileManager defaultManager] removeItemAtURL:dir error:NULL];
    if(!success){
        NSLog(@"!!!ERROR: DataModelUtils delete dir failed!");
    }
    
}

//-(NSURL*)soundTrackMyDealsURL
//{
//    if(!_soundTrackMyDealsURL){
//        _soundTrackMyDealsURL=[self.documentsURL URLByAppendingPathComponent:@"SoundTrack/MyDeals"];
//    }
//    return _soundTrackMyDealsURL;
//}
//-(NSURL*)soundTrackBoughtDealsURL
//{
//    if(!_soundTrackBoughtDealsURL){
//        _soundTrackBoughtDealsURL=[self.documentsURL URLByAppendingPathComponent:@"SoundTrack/BoughtDeals"];
//    }
//    return _soundTrackBoughtDealsURL;
//}
//
//-(NSString*)soundTrackMyDealsRelativeURL
//{
//    if(!_soundTrackMyDealsRelativeURL){
//        _soundTrackMyDealsRelativeURL=@"SoundTrack/MyDeals";
//    }
//    return _soundTrackMyDealsRelativeURL;
//}
//-(NSString*)soundTrackBoughtDealsRelativeURL
//{
//    if(!_soundTrackBoughtDealsRelativeURL){
//        _soundTrackBoughtDealsRelativeURL=@"SoundTrack/BoughtDeals";
//    }
//    return _soundTrackBoughtDealsRelativeURL;
//}

-(NSURL*)documentsURL
{
    if(!_documentsURL){
        NSFileManager* fileManager = [NSFileManager defaultManager];
        _documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    }
    return _documentsURL;
}



-(NSURL*)getMyDealsSubURLWithFilename:(NSString*)filename
{
    return [self.myDealsURL URLByAppendingPathComponent:filename];
}

//-(UIManagedDocument*)boughtDealsManagedDocument
//{
//    if(!_boughtDealsManagedDocument){
//        _boughtDealsManagedDocument = [[UIManagedDocument alloc] initWithFileURL:self.boughtDealsURL];
//    }
//    return _boughtDealsManagedDocument;
//}
//-(NSManagedObjectContext*)boughtDealsContext
//{
//    if(!_boughtDealsContext){
//        if(self.boughtDealsManagedDocument.documentState==UIDocumentStateNormal){
//            _boughtDealsContext=self.boughtDealsManagedDocument.managedObjectContext;
//        }
//    }
//    return _boughtDealsContext;
//}

#pragma mark - setters and getters
-(NSMutableDictionary*)managedContextDictionary
{
    if(!_managedContextDictionary){
        _managedContextDictionary=[[NSMutableDictionary alloc] init];
    }
    return _managedContextDictionary;
}
-(NSMutableDictionary*) managedDocumentDictionary
{
    if(!_managedDocumentDictionary){
        _managedDocumentDictionary=[[NSMutableDictionary alloc] init];
        
    }
    return _managedDocumentDictionary;
}

@end
