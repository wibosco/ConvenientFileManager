//
//  CoreDataServices.m
//  CoreDataServices
//
//  Created by William Boles on 15/04/2014.
//  Copyright (c) 2014 Boles. All rights reserved.
//

#import "CDSServiceManager.h"

static NSString * const CDSPersistentStoreDirectoryName = @"persistent-store";
static NSString * const CDSPersistentStoreFileExtension = @"sqlite";

static CDSServiceManager *sharedInstance = nil;

@interface CDSServiceManager ()

@property (nonatomic, strong) NSURL *modelURL;
@property (nonatomic, strong, readonly) NSURL *storeDirectoryURL;
@property (nonatomic, strong, readonly) NSURL *storeURL;
@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readwrite) NSManagedObjectModel *managedObjectModel;

- (void)createPersistentStoreAndRetryOnError:(BOOL)retry;
- (void)deletePersistentStore;

@end

@implementation CDSServiceManager

#pragma mark - SharedInstance

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      sharedInstance = [[CDSServiceManager alloc] init];
                  });
    
    return sharedInstance;
}

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(saveManagedObjectContext)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
    }
    return self;
}

#pragma mark - Getters

- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel)
    {
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:self.modelURL];
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (!_persistentStoreCoordinator)
    {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
        
        [self createPersistentStoreAndRetryOnError:YES];
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    @synchronized(self)
    {
        if (!_managedObjectContext)
        {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        }
        
        return _managedObjectContext;
    }
}

#pragma mark - Setup

- (void)setupModelURLWithModelName:(NSString *)name
{
    self.modelURL = [[NSBundle mainBundle] URLForResource:name
                                            withExtension:@"momd"];
}

#pragma mark - Reset

- (void)reset
{
    [self clear];
}

#pragma mark - Clear

- (void)clear
{
    self.managedObjectContext = nil;
    
    self.persistentStoreCoordinator = nil;
    self.managedObjectModel = nil;
    
    [self deletePersistentStore];
}

- (void)deletePersistentStore
{
    [[NSFileManager defaultManager] removeItemAtURL:self.storeDirectoryURL
                                              error:nil];
}

#pragma mark - CreatePersistentStore

- (void)createPersistentStoreAndRetryOnError:(BOOL)retry
{
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:[self.storeDirectoryURL path]
                           isDirectory:NULL])
    {
        [fileManager createDirectoryAtURL:self.storeDirectoryURL
              withIntermediateDirectories:NO
                               attributes:nil
                                    error:&error];
    }
    
    if (!error)
    {
        [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                      configuration:nil
                                                                URL:self.storeURL
                                                            options:options
                                                              error:&error];
    }
    
    if (error)
    {
        [self deletePersistentStore];
        
        if (retry)
        {
            NSLog(@"Unresolved persistent store coordinator error %@, %@", error, [error userInfo]);
            [self createPersistentStoreAndRetryOnError:NO];
        }
        else
        {
            NSLog(@"Serious error with persistent-store %@, %@", error, [error userInfo]);
        }
    }
}

#pragma mark - Store

- (NSURL *)storeDirectoryURL
{
    NSURL *applicationDocumentURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                            inDomains:NSUserDomainMask] lastObject];
    
    NSURL *storeDirectoryURL = [applicationDocumentURL URLByAppendingPathComponent:CDSPersistentStoreDirectoryName];
    
    return storeDirectoryURL;
}

- (NSURL *)storeURL
{
    NSString *modelFileName = [[self.modelURL lastPathComponent] stringByDeletingPathExtension];
    NSString *storeFilePath = [NSString stringWithFormat:@"%@.%@", modelFileName, CDSPersistentStoreFileExtension];
    NSURL *storeURL = [self.storeDirectoryURL URLByAppendingPathComponent:storeFilePath];
    
    return storeURL;
}

#pragma mark - Save

- (void)saveManagedObjectContext
{
    NSError *error = nil;
    
    if (![self.managedObjectContext save:&error])
    {
        NSLog(@"Couldn't save context: %@", [error userInfo]);
    }
    else
    {
        //Force context to process pending changes as
        //cascading deletes may not be immediatly applied by coredata.
        [self.managedObjectContext processPendingChanges];
    }
}

@end
