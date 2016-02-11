//
//  NSFileManager+CFMDocuments.m
//  ConvenientFileManager
//
//  Created by William Boles on 10/01/2014.
//  Copyright © 2015 Boles. All rights reserved.
//

#import "NSFileManager+CFMDocuments.h"

#import "NSFileManager+CFMPersistence.h"

@implementation NSFileManager (CFMDocuments)

#pragma mark - Documents

+ (NSString *)cfm_documentsDirectoryPath
{
    NSURL *directoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                  inDomains:NSUserDomainMask] lastObject];
    
    return [directoryURL path];
}

+ (NSString *)cfm_documentsDirectoryPathForResourceWithPath:(NSString *)relativePath
{
    NSString *cacheDirectory = [NSFileManager cfm_documentsDirectoryPath];
    
    return [cacheDirectory stringByAppendingPathComponent:relativePath];
}

#pragma mark - Saving

+ (BOOL)cfm_saveData:(NSData *)data toDocumentsDirectoryPath:(NSString *)relativePath
{
    NSString *documentsDirectory = [NSFileManager cfm_documentsDirectoryPath];
    NSString *absolutePath = [documentsDirectory stringByAppendingPathComponent:relativePath];
    
    return [NSFileManager cfm_saveData:data
                                toPath:absolutePath];
}

#pragma mark - Retrieval

+ (NSData *)cfm_retrieveDataFromDocumentsDirectoryWithPath:(NSString *)relativePath
{
    NSString *documentsDirectory = [NSFileManager cfm_documentsDirectoryPath];
    NSString *absolutePath = [documentsDirectory stringByAppendingPathComponent:relativePath];
    
    return [NSData dataWithContentsOfFile:absolutePath];
}

#pragma mark - Exists

+ (BOOL)cfm_fileExistsInDocumentsDirectory:(NSString *)relativePath
{
    NSString *documentsDirectory = [NSFileManager cfm_documentsDirectoryPath];
    NSString *absolutePath = [documentsDirectory stringByAppendingPathComponent:relativePath];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:absolutePath];
}

#pragma mark - Deletion

+ (BOOL)cfm_deleteDataFromDocumentDirectoryWithPath:(NSString *)relativePath
{
    NSString *documentsDirectory = [NSFileManager cfm_documentsDirectoryPath];
    NSString *absolutePath = [documentsDirectory stringByAppendingPathComponent:relativePath];
    
    return [NSFileManager cfm_deleteDataAtPath:absolutePath];
}

@end
