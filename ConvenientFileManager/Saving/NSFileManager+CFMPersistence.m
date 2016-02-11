//
//  NSFileManager+CFMPersistence.m
//  ConvenientFileManager
//
//  Created by William Boles on 10/01/2014.
//  Copyright © 2015 Boles. All rights reserved.
//

#import "NSFileManager+CFMPersistence.h"

@implementation NSFileManager (CFMPersistence)

#pragma mark - Saving

+ (BOOL)cfm_saveData:(NSData *)data
              toPath:(NSString *)path
{
    BOOL success = NO;
    
    if (data.length > 0 &&
        path.length > 0)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL createdDirectory = YES;
        
        NSString *folderPath = [path stringByDeletingLastPathComponent];
        
        if (![fileManager fileExistsAtPath:folderPath])
        {
            createdDirectory = [NSFileManager cfm_createDirectoryAtPath:folderPath];
        }
        
        if (createdDirectory)
        {
            NSError *error = nil;
            
            success = [data writeToFile:path
                                options:NSDataWritingAtomic
                                  error:&error];
            
            if (error)
            {
                NSLog(@"Error when attempting to write data to directory: %@", [error userInfo]);
            }
        }
    }
    
    return success;
}

+ (BOOL)cfm_createDirectoryAtPath:(NSString *)path
{
    BOOL createdDirectory = NO;
    
    if (path.length > 0)
    {
        NSError *error = nil;
        
        createdDirectory = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                                     withIntermediateDirectories:YES
                                                                      attributes:nil
                                                                           error:&error];
        
        if(error)
        {
            NSLog(@"Error when creating a directory at location: %@", path);
        }
    }
    
    return createdDirectory;
}

#pragma mark - Exists

+ (BOOL)cfm_fileExistsAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (void)ufc_fileExistsAtPath:(NSString *)path
                  completion:(void (^)(BOOL fileExists))completion
{
    //Used to return the call on the same thread
    NSOperationQueue *callBackQueue = [NSOperationQueue currentQueue];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
                   {
                       BOOL fileExists = [NSFileManager cfm_fileExistsAtPath:path];
                       
                       [callBackQueue addOperationWithBlock:^
                        {
                            if (completion)
                            {
                                completion(fileExists);
                            }
                        }];
                   });
}

#pragma mark - Deletion

+ (BOOL)cfm_deleteDataAtPath:(NSString *)path
{
    NSError *error = nil;
    
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path
                                                              error:&error];
    
    if (error)
    {
        NSLog(@"Error when attempting to delete data from disk: %@", [error userInfo]);
    }
    
    return success;
}

#pragma mark - URL

+ (NSURL *)cfm_fileURLForPath:(NSString *)path
{
    return [NSURL fileURLWithPath:path];
}

#pragma mark - Move

+ (BOOL)cfm_moveFileFromSourcePath:(NSString *)sourcePath
                 toDestinationPath:(NSString *)destinationPath
{
    BOOL success = NO;
    BOOL createdDirectory = YES;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *destinationDirectoryPath = [destinationPath stringByDeletingLastPathComponent];
    
    if (![fileManager fileExistsAtPath:destinationDirectoryPath])
    {
        createdDirectory = [NSFileManager cfm_createDirectoryAtPath:destinationDirectoryPath];
    }
    
    if (createdDirectory)
    {
        NSError *error = nil;
        
        success = [fileManager moveItemAtPath:sourcePath
                                       toPath:destinationPath
                                        error:&error];
        
        if (error)
        {
            NSLog(@"Error when attempting to move data on disk: %@", [error userInfo]);
        }
    }
    
    return success;
}

@end
