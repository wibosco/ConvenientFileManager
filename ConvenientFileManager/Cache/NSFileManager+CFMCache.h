//
//  NSFileManager+CFMCache.h
//  ConvenientFileManager
//
//  Created by William Boles on 10/01/2014.
//  Copyright © 2015 Boles. All rights reserved.
//

@import Foundation;

/**
 A collection of helper methods for common operations in the cache directory.
 */
@interface NSFileManager (CFMCache)

/**
 Path of cache directory.
 
 return NSString instance.
 */
+ (NSString *)cfm_cacheDirectoryPath;

/**
 Path of resource in cache directory.
 
 @parameter relativePath - relative path that will be combined cache path.
 
 @return Combined path.
 */
+ (NSString *)cfm_cacheDirectoryPathForResourceWithPath:(NSString *)relativePath;

/**
 Save data to path in cache directory.
 
 @parameter data - data to be saved.
 @parameter relativePath - relative path that will be combined cache path.
 
 @return BOOL if save was successful.
 */
+ (BOOL)cfm_saveData:(NSData *)data toCacheDirectoryPath:(NSString *)relativePath;

/**
 Retrieve data to path in cache directory.
 
 @parameter relativePath - relative path that will be combined cache path.
 
 @return NSData that was retrieved.
 */
+ (NSData *)cfm_retrieveDataFromCacheDirectoryWithPath:(NSString *)relativePath;

/**
 Determines if a file exists at path in the cache directory
 
 @parameter relativePath - relative path that will be combined cache path.
 
 @return BOOL - YES if file exists, NO if file doesn't exist.
 */
+ (BOOL)cfm_fileExistsInCacheDirectory:(NSString *)relativePath;

/**
 Delete data from path in cache directory.
 
 @parameter relativePath - relative path that will be combined cache path.
 
 @return BOOL if deletion was successful.
 */
+ (BOOL)cfm_deleteDataFromCacheDirectoryWithPath:(NSString *)relativePath;

@end
