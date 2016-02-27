//
//  NSFileManager+CFMPersistence.m
//  ConvenientFileManager
//
//  Created by William Boles on 10/01/2014.
//  Copyright © 2015 Boles. All rights reserved.
//

#import "NSFileManager+CFMPersistence.h"

@implementation NSFileManager (CFMPersistence)

#pragma mark - Retrieving

+ (NSData *)cfm_retrieveDataAtPath:(NSString *)absolutePath
{
    NSData *data = nil;
    
    if (absolutePath.length > 0)
    {
        data = [NSData dataWithContentsOfFile:absolutePath];
    }
    
    return data;
}

#pragma mark - Saving

+ (BOOL)cfm_saveData:(NSData *)data
              toPath:(NSString *)absolutePath
{
    BOOL success = NO;
    
    if (data.length > 0 &&
        absolutePath.length > 0)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL createdDirectory = YES;
        
        NSString *folderPath = [absolutePath stringByDeletingLastPathComponent];
        
        if (![fileManager fileExistsAtPath:folderPath])
        {
            createdDirectory = [NSFileManager cfm_createDirectoryAtPath:folderPath];
        }
        
        if (createdDirectory)
        {
            NSError *error = nil;
            
            success = [data writeToFile:absolutePath
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

+ (BOOL)cfm_createDirectoryAtPath:(NSString *)absolutePath
{
    BOOL createdDirectory = NO;
    
    if (absolutePath.length > 0)
    {
        NSError *error = nil;
        
        createdDirectory = [[NSFileManager defaultManager] createDirectoryAtPath:absolutePath
                                                     withIntermediateDirectories:YES
                                                                      attributes:nil
                                                                           error:&error];
        
        if(error)
        {
            NSLog(@"Error when creating a directory at location: %@", absolutePath);
        }
    }
    
    return createdDirectory;
}

#pragma mark - Exists

+ (BOOL)cfm_fileExistsAtPath:(NSString *)absolutePath
{
    return [[NSFileManager defaultManager] fileExistsAtPath:absolutePath];
}

+ (void)cfm_fileExistsAtPath:(NSString *)absolutePath
                  completion:(void (^)(BOOL fileExists))completion
{
    //Used to return the call on the same thread
    NSOperationQueue *callBackQueue = [NSOperationQueue currentQueue];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^
                   {
                       BOOL fileExists = [NSFileManager cfm_fileExistsAtPath:absolutePath];
                       
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

+ (BOOL)cfm_deleteDataAtPath:(NSString *)absolutePath
{
    BOOL deletion = NO;
    
    if (absolutePath.length > 0)
    {
        NSError *error = nil;
        
        deletion = [[NSFileManager defaultManager] removeItemAtPath:absolutePath
                                                              error:&error];
        
        if (error)
        {
            NSLog(@"Error when attempting to delete data from disk: %@", [error userInfo]);
        }
    }
    
    return deletion;
}

#pragma mark - URL

+ (NSURL *)cfm_fileURLForPath:(NSString *)absolutePath
{
    return [NSURL fileURLWithPath:absolutePath];
}

#pragma mark - Move

+ (BOOL)cfm_moveFileFromSourcePath:(NSString *)sourcePath
                 toDestinationPath:(NSString *)destinationPath
{
    BOOL success = NO;
    
    if (sourcePath.length > 0 &&
        destinationPath.length > 0)
    {
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
    }
    
    return success;
}

@end
