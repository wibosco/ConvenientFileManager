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

+ (BOOL)cfm_saveData:(NSData *)data toPath:(NSString *)path
{
    BOOL success = NO;
    
    if ([data length] > 0 &&
        [path length] > 0)
    {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL createdDirectory = YES;
        
        NSString *folderPath = [path stringByDeletingLastPathComponent];
        
        if (folderPath.length > 0)
        {
            if (![fileManager fileExistsAtPath:folderPath])
            {
                NSError *error = nil;
                
                createdDirectory = [fileManager createDirectoryAtPath:folderPath
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:&error];
                
                if(error)
                {
                    NSLog(@"Error when creating a directory at location: %@", folderPath);
                }
            }
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

#pragma mark - Exists

+ (BOOL)cfm_fileExistsAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
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
    NSError *error = nil;
    
    BOOL success = [[NSFileManager defaultManager] moveItemAtPath:sourcePath
                                                           toPath:destinationPath
                                                            error:&error];
    
    if (error)
    {
        NSLog(@"Error when attempting to move data on disk: %@", [error userInfo]);
    }
    
    return success;
}

@end
