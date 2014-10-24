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
@property (nonatomic) NSURL* boughtDealsURL;

@property (nonatomic) NSPersistentStoreCoordinator* persistentStoreCoordinator;
@property (nonatomic) NSManagedObjectModel* managedObjectModel;

@property (nonatomic) UIManagedDocument* myDealsManagedDocument;
@property (nonatomic) UIManagedDocument* boughtDealsManagedDocument;

@property (nonatomic) NSManagedObjectContext*  myDealsContext;
@property (nonatomic) NSManagedObjectContext* boughtDealsContext;
@property (nonatomic) NSString* filename;


@end

@implementation DataModalUtils


#pragma mark - setup methods
//wrong:
-(NSManagedObjectContext*)myDealsContext
{
    if(!_myDealsContext){
        if(self.myDealsManagedDocument.documentState==UIDocumentStateNormal){
            _myDealsContext=self.myDealsManagedDocument.managedObjectContext;
//            if(![_myDealsContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:self.myDealsURL options:options error:NULL]){
//                NSLog(@"persistent store add error!");
//            }
        }
        
    }
    return _myDealsContext;
}

-(NSManagedObjectContext*)getMyDealsContextWithFilename:(NSString*)filename
{
    
    if(!_myDealsContext){
        _myDealsContext = [self getMyDealsDocumentWithFileName:filename].managedObjectContext;
        //NSDictionary *options = @{ NSSQLitePragmasOption : @{@"journal_mode" : @"DELETE"} };
//        if([_myDealsContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self getMyDealsSubURLWithFilename:filename] options:options error:NULL]){
//            NSLog(@"ERROR: journal mode not set correctly");
//        }
//        else{
//            NSLog(@"journal mode set");
//        }

    }
    return _myDealsContext;
}
-(NSManagedObjectContext*)boughtDealsContext
{
    if(!_boughtDealsContext){
        if(self.boughtDealsManagedDocument.documentState==UIDocumentStateNormal){
            _boughtDealsContext=self.boughtDealsManagedDocument.managedObjectContext;
        }
    }
    return _boughtDealsContext;
}

//wrong
-(UIManagedDocument*)getMyDealsDocument
{
    //NSLog(@"filepath url is %@",filePath);
    UIManagedDocument* doc=doc = [[UIManagedDocument alloc] initWithFileURL:self.myDealsURL];
    if([[NSFileManager defaultManager] fileExistsAtPath:self.myDealsURL.path]){
        NSLog(@"doc state is %@",doc);
        if(doc.documentState!=UIDocumentStateNormal){
            [doc openWithCompletionHandler:^(BOOL success) {
                if(!success){
                    NSLog(@"document open NOT successful");
                }
                else{
                    NSLog(@"document opened successful");
                }
                //NSLog(@"document at path %@ is opened",doc);
            }];
        }
    }
    else{
        [[NSFileManager defaultManager] createDirectoryAtPath:self.myDealsURL.path withIntermediateDirectories:YES attributes:nil error:NULL];
        [doc saveToURL:self.myDealsURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if(success){
                NSLog(@"document at path %@ is created",self.myDealsURL);
            }
            else{
                NSLog(@"!!!ERROR: couldnot save to path %@",self.myDealsURL);
            }
        }];
    }
    return doc;
}

/*
 UIDocumentSaveForCreating will create the newFileName(directory) and create persistent store under this dir.
 if there newFileName already exists, then the create will fail.
 Solution, test file does NOT exist at the location, then create all the intermediate dir right before its parent dir.
 
 */
-(UIManagedDocument*)getMyDealsDocumentWithFileName:(NSString*)filename
{
    NSURL* filePath = [self.myDealsURL URLByAppendingPathComponent:filename isDirectory:NO];
    //NSLog(@"filepath url is %@",filePath);
    
    if(!_myDealsManagedDocument){
        _myDealsManagedDocument= [[UIManagedDocument alloc] initWithFileURL:filePath];
    }
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath.path isDirectory:NO]){
        [[NSFileManager defaultManager] createDirectoryAtPath:self.myDealsURL.path withIntermediateDirectories:YES attributes:nil error:NULL];
        [_myDealsManagedDocument saveToURL:filePath forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if(success){
                NSLog(@"document at path %@ is created",filePath);
            }
            else{
                NSLog(@"!!!ERROR: couldnot save to path %@",filePath);
            }
            
        }];
    }
    if(_myDealsManagedDocument.documentState!=UIDocumentStateNormal){
        [_myDealsManagedDocument openWithCompletionHandler:^(BOOL success) {
            if(!success){
                NSLog(@"documents file not opened successful");
            }
            //NSLog(@"document at path %@ is opened",doc);
        }];

    }
    
    return _myDealsManagedDocument;
}
-(UIManagedDocument*)boughtDealsManagedDocument
{
    if(!_boughtDealsManagedDocument){
        _boughtDealsManagedDocument = [[UIManagedDocument alloc] initWithFileURL:self.boughtDealsURL];
    }
    return _boughtDealsManagedDocument;
}

-(NSURL*)documentsURL
{
    if(!_documentsURL){
        NSFileManager* fileManager = [NSFileManager defaultManager];
        _documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
//        if (![fileManager fileExistsAtPath:url.path])
//            [fileManager createDirectoryAtPath:url.path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    //NSLog(@"documents url is %@",_documentsURL);
    return _documentsURL;
}
-(NSURL*)myDealsURL
{
    if(!_myDealsURL){
        NSString* myDealDir=@"Deals/MyDeals";
        NSURL* docDir=self.documentsURL;
        _myDealsURL = [docDir URLByAppendingPathComponent:myDealDir isDirectory:YES];
        if (![[NSFileManager defaultManager] fileExistsAtPath:_myDealsURL.path]){
            //[[NSFileManager defaultManager] createDirectoryAtPath:myDealURL.path withIntermediateDirectories:YES attributes:nil error:NULL];
            nil;
        }
    }
    //NSLog(@"deals url is %@",_myDealsURL);
    return _myDealsURL;
}
-(NSURL*)getMyDealsSubURLWithFilename:(NSString*)filename
{
    return [self.myDealsURL URLByAppendingPathComponent:filename];
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
//- (NSManagedObjectContext *)managedObjectContext
//{
//    if (__managedObjectContext != nil) {
//        return __managedObjectContext;
//    }
//    
//    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
//    if (coordinator != nil) {
//        __managedObjectContext = [[NSManagedObjectContext alloc] init];
//        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
//    }
//    return __managedObjectContext;
//}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
// the momd file is under xiaojiaoyi.app folder
- (NSManagedObjectModel *)managedObjectModel
{
    if(!_managedObjectModel){
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
//-(NSPersistentStoreCoordinator*)getPersistentStoreCoordinatorWith
//- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
//{
//    if (_persistentStoreCoordinator != nil) {
//        return _persistentStoreCoordinator;
//    }
//    
//    //NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"xiaojiaoyi.sqlite"];
//    
//    NSError *error = nil;
//    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
//    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
//    
//    return _persistentStoreCoordinator;
//}


@end
