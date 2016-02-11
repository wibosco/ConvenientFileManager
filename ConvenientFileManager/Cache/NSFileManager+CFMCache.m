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
    NSString *cacheDirectory = [NSFileManager cfm_cacheDirectoryPath];
    NSString *absolutePath = [cacheDirectory stringByAppendingPathComponent:relativePath];
    
    return [NSFileManager cfm_saveData:data
                                toPath:absolutePath];
}

#pragma mark - Retrieval

+ (NSData *)cfm_retrieveDataFromCacheDirectoryWithPath:(NSString *)relativePath
{
    NSString *cacheDirectory = [NSFileManager cfm_cacheDirectoryPath];
    NSString *absolutePath = [cacheDirectory stringByAppendingPathComponent:relativePath];
    
    return [NSData dataWithContentsOfFile:absolutePath];
}

#pragma mark - Exists

+ (BOOL)cfm_fileExistsInCacheDirectory:(NSString *)relativePath
{
    NSString *cacheDirectory = [NSFileManager cfm_cacheDirectoryPath];
    NSString *absolutePath = [cacheDirectory stringByAppendingPathComponent:relativePath];
    
    return [NSFileManager cfm_fileExistsAtPath:absolutePath];
}

#pragma mark - Deletion

+ (BOOL)cfm_deleteDataFromCacheDirectoryWithPath:(NSString *)relativePath
{
    NSString *cacheDirectory = [NSFileManager cfm_cacheDirectoryPath];
    NSString *absolutePath = [cacheDirectory stringByAppendingPathComponent:relativePath];
    
    return [NSFileManager cfm_deleteDataAtPath:absolutePath];
}

@end
