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

+ (NSString *)cfm_documentsDirectoryPathForResourceWithPath:(NSString *)path
{
    NSString *cacheDirectory = [NSFileManager cfm_documentsDirectoryPath];
    
    return [cacheDirectory stringByAppendingPathComponent:path];
}

#pragma mark - Saving

+ (BOOL)cfm_saveData:(NSData *)data toDocumentsDirectoryPath:(NSString *)path
{
    NSString *documentsDirectory = [NSFileManager cfm_documentsDirectoryPath];
    NSString *extendedPath = [documentsDirectory stringByAppendingPathComponent:path];
    
    return [NSFileManager cfm_saveData:data
                                toPath:extendedPath];
}

#pragma mark - Retrieval

+ (NSData *)cfm_retrieveDataFromDocumentsDirectoryWithPath:(NSString *)path
{
    NSString *documentsDirectory = [NSFileManager cfm_documentsDirectoryPath];
    NSString *extendedPath = [documentsDirectory stringByAppendingPathComponent:path];
    
    return [NSData dataWithContentsOfFile:extendedPath];
}

#pragma mark - Exists

+ (BOOL)cfm_fileExistsInDocumentsDirectory:(NSString *)path
{
    NSString *documentsDirectory = [NSFileManager cfm_documentsDirectoryPath];
    NSString *extendedPath = [documentsDirectory stringByAppendingPathComponent:path];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:extendedPath];
}

#pragma mark - Deletion

+ (BOOL)cfm_deleteDataFromDocumentDirectoryWithPath:(NSString *)path
{
    NSString *documentsDirectory = [NSFileManager cfm_documentsDirectoryPath];
    NSString *extendedPath = [documentsDirectory stringByAppendingPathComponent:path];
    
    return [NSFileManager cfm_deleteDataAtPath:extendedPath];
}

@end
