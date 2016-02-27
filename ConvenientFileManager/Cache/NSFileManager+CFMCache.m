//
//  NSFileManager+CFMCache.m
//  ConvenientFileManager
//
//  Created by William Boles on 10/01/2014.
//  Copyright © 2015 Boles. All rights reserved.
//

#import "NSFileManager+CFMCache.h"

#import "NSFileManager+CFMPersistence.h"

@implementation NSFileManager (CFMCache)

#pragma mark - Cache

+ (NSString *)cfm_cacheDirectoryPath
{
    NSURL *directoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory
                                                                  inDomains:NSUserDomainMask] lastObject];
    
    return [directoryURL path];
}

+ (NSString *)cfm_cacheDirectoryPathForResourceWithPath:(NSString *)relativePath
{
    NSString *cacheDirectory = [NSFileManager cfm_cacheDirectoryPath];
    
    return [cacheDirectory stringByAppendingPathComponent:relativePath];
}

#pragma mark - Saving

+ (BOOL)cfm_saveData:(NSData *)data toCacheDirectoryPath:(NSString *)relativePath
{
    BOOL saved = NO;
    
    if (relativePath.length > 0)
    {
        NSString *cacheDirectory = [NSFileManager cfm_cacheDirectoryPath];
        NSString *absolutePath = [cacheDirectory stringByAppendingPathComponent:relativePath];
        
        saved = [NSFileManager cfm_saveData:data
                                     toPath:absolutePath];
    }
    
    return saved;
}

#pragma mark - Retrieval

+ (NSData *)cfm_retrieveDataFromCacheDirectoryWithPath:(NSString *)relativePath
{
    NSData *data = nil;
    
    if (relativePath.length > 0)
    {
        NSString *cacheDirectory = [NSFileManager cfm_cacheDirectoryPath];
        NSString *absolutePath = [cacheDirectory stringByAppendingPathComponent:relativePath];
        
        data = [NSFileManager cfm_retrieveDataAtPath:absolutePath];
    }
    
    return data;
}

#pragma mark - Exists

+ (BOOL)cfm_fileExistsInCacheDirectory:(NSString *)relativePath
{
    BOOL fileExists = NO;
    
    if (relativePath.length > 0)
    {
        NSString *cacheDirectory = [NSFileManager cfm_cacheDirectoryPath];
        NSString *absolutePath = [cacheDirectory stringByAppendingPathComponent:relativePath];
        
        fileExists = [NSFileManager cfm_fileExistsAtPath:absolutePath];
    }
    
    return fileExists;
}

#pragma mark - Deletion

+ (BOOL)cfm_deleteDataFromCacheDirectoryWithPath:(NSString *)relativePath
{
    BOOL deletion = NO;
    
    if (relativePath.length > 0)
    {
        NSString *cacheDirectory = [NSFileManager cfm_cacheDirectoryPath];
        NSString *absolutePath = [cacheDirectory stringByAppendingPathComponent:relativePath];
        
        deletion = [NSFileManager cfm_deleteDataAtPath:absolutePath];
    }
    
    return deletion;
}

@end
