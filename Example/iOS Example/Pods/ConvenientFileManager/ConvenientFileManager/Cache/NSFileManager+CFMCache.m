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

+ (NSString *)cfm_cacheDirectoryPathForResourceWithPath:(NSString *)path
{
    NSString *cacheDirectory = [NSFileManager cfm_cacheDirectoryPath];
    
    return [cacheDirectory stringByAppendingPathComponent:path];
}

#pragma mark - Saving

+ (BOOL)cfm_saveData:(NSData *)data toCacheDirectoryPath:(NSString *)path
{
    NSString *cacheDirectory = [NSFileManager cfm_cacheDirectoryPath];
    NSString *extendedPath = [cacheDirectory stringByAppendingPathComponent:path];
    
    return [NSFileManager cfm_saveData:data
                                toPath:extendedPath];
}

#pragma mark - Retrieval

+ (NSData *)cfm_retrieveDataFromCacheDirectoryWithPath:(NSString *)path
{
    NSString *cacheDirectory = [NSFileManager cfm_cacheDirectoryPath];
    NSString *extendedPath = [cacheDirectory stringByAppendingPathComponent:path];
    
    return [NSData dataWithContentsOfFile:extendedPath];
}

#pragma mark - Exists

+ (BOOL)cfm_fileExistsInCacheDirectory:(NSString *)path
{
    NSString *cacheDirectory = [NSFileManager cfm_cacheDirectoryPath];
    NSString *extendedPath = [cacheDirectory stringByAppendingPathComponent:path];
    
    return [NSFileManager cfm_fileExistsAtPath:extendedPath];
}

#pragma mark - Deletion

+ (BOOL)cfm_deleteDataFromCacheDirectoryWithPath:(NSString *)path
{
    NSString *cacheDirectory = [NSFileManager cfm_cacheDirectoryPath];
    NSString *extendedPath = [cacheDirectory stringByAppendingPathComponent:path];
    
    return [NSFileManager cfm_deleteDataAtPath:extendedPath];
}

@end
