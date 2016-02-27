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
    BOOL saved = NO;
    
    if (relativePath.length > 0)
    {
        NSString *documentsDirectory = [NSFileManager cfm_documentsDirectoryPath];
        NSString *absolutePath = [documentsDirectory stringByAppendingPathComponent:relativePath];
        
        saved = [NSFileManager cfm_saveData:data
                                     toPath:absolutePath];
    }
    
    return saved;
}

#pragma mark - Retrieval

+ (NSData *)cfm_retrieveDataFromDocumentsDirectoryWithPath:(NSString *)relativePath
{
    NSData *data = nil;
    
    if (relativePath.length > 0)
    {
        NSString *documentsDirectory = [NSFileManager cfm_documentsDirectoryPath];
        NSString *absolutePath = [documentsDirectory stringByAppendingPathComponent:relativePath];
        
        data = [NSFileManager cfm_retrieveDataAtPath:absolutePath];
    }
    
    return data;
}

#pragma mark - Exists

+ (BOOL)cfm_fileExistsInDocumentsDirectory:(NSString *)relativePath
{
    BOOL fileExists = NO;
    
    if (relativePath.length > 0)
    {
        NSString *documentsDirectory = [NSFileManager cfm_documentsDirectoryPath];
        NSString *absolutePath = [documentsDirectory stringByAppendingPathComponent:relativePath];
        
        fileExists = [[NSFileManager defaultManager] fileExistsAtPath:absolutePath];
    }
    
    return fileExists;
}

#pragma mark - Deletion

+ (BOOL)cfm_deleteDataFromDocumentsDirectoryWithPath:(NSString *)relativePath
{
    BOOL deletion = NO;
    
    if (relativePath.length > 0)
    {
        NSString *documentsDirectory = [NSFileManager cfm_documentsDirectoryPath];
        NSString *absolutePath = [documentsDirectory stringByAppendingPathComponent:relativePath];
        
        deletion = [NSFileManager cfm_deleteDataAtPath:absolutePath];
    }
    
    return deletion;
}

@end
