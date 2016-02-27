//
//  ConvenientFileManagerTests.m
//  ConvenientFileManagerTests
//
//  Created by Home on 27/02/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSFileManager+CFMCache.h"

@interface NSFileManagerCFMCacheTests : XCTestCase

@property (nonatomic, strong) NSData *dataToBeSaved;
@property (nonatomic, strong) NSString *resource;
@property (nonatomic, strong) NSString *resourceWithFolder;

@end

@implementation NSFileManagerCFMCacheTests

#pragma mark - TestSuiteLifecycle

- (void)setUp
{
    [super setUp];
    
    self.dataToBeSaved = [@"Test string to be converted into data" dataUsingEncoding:NSUTF8StringEncoding];
    self.resource = @"test.mp4";
    self.resourceWithFolder = @"test/test.mp4";
}

- (void)tearDown
{
    self.dataToBeSaved = nil;
    self.resource = nil;
    self.resourceWithFolder = nil;
    
    if ([NSFileManager cfm_fileExistsInCacheDirectory:self.resource])
    {
        [NSFileManager cfm_deleteDataFromCacheDirectoryWithPath:self.resource];
    }
    
    if ([NSFileManager cfm_fileExistsInCacheDirectory:self.resourceWithFolder])
    {
        [NSFileManager cfm_deleteDataFromCacheDirectoryWithPath:self.resourceWithFolder];
    }
    
    [super tearDown];
}

#pragma mark - Path

- (void)test_cacheDirectoryPath_fullPathToCacheDirectory
{
    NSURL *directoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory
                                                                  inDomains:NSUserDomainMask] lastObject];
    
    NSString *expectedCacheDirectoryPath = [directoryURL path];
    
    NSString *returnedCacheDirectoryPath = [NSFileManager cfm_cacheDirectoryPath];
    
    XCTAssertEqualObjects(returnedCacheDirectoryPath, expectedCacheDirectoryPath, @"Paths returned do not match: %@ and %@", returnedCacheDirectoryPath, expectedCacheDirectoryPath);
}

- (void)test_cacheDirectoryPathForResourceWithPath_fullPathToResource
{
    NSURL *directoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory
                                                                  inDomains:NSUserDomainMask] lastObject];
    
    NSString *expectedCacheDirectoryPath = [NSString stringWithFormat:@"%@/%@", [directoryURL path], self.resource];
    
    NSString *returnedCacheDirectoryPath = [NSFileManager cfm_cacheDirectoryPathForResourceWithPath:self.resource];
    
    XCTAssertEqualObjects(returnedCacheDirectoryPath, expectedCacheDirectoryPath, @"Paths returned do not match: %@ and %@", returnedCacheDirectoryPath, expectedCacheDirectoryPath);
}

- (void)test_cacheDirectoryPathForResourceWithPath_fullPathToResourceWithFolder
{
    NSURL *directoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory
                                                                  inDomains:NSUserDomainMask] lastObject];
    
    NSString *expectedCacheDirectoryPath = [NSString stringWithFormat:@"%@/%@", [directoryURL path], self.resourceWithFolder];
    
    NSString *returnedCacheDirectoryPath = [NSFileManager cfm_cacheDirectoryPathForResourceWithPath:self.resourceWithFolder];
    
    XCTAssertEqualObjects(returnedCacheDirectoryPath, expectedCacheDirectoryPath, @"Paths returned do not match: %@ and %@", returnedCacheDirectoryPath, expectedCacheDirectoryPath);
}

- (void)test_cacheDirectoryPathForResourceWithPath_nilResource
{
    NSURL *directoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory
                                                                  inDomains:NSUserDomainMask] lastObject];
    
    NSString *expectedCacheDirectoryPath = [directoryURL path];
    
    NSString *returnedCacheDirectoryPath = [NSFileManager cfm_cacheDirectoryPathForResourceWithPath:nil];
    
    XCTAssertEqualObjects(returnedCacheDirectoryPath, expectedCacheDirectoryPath, @"Paths returned do not match: %@ and %@", returnedCacheDirectoryPath, expectedCacheDirectoryPath);
}

#pragma mark - Saving

- (void)test_saveData_fileOnDisk
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toCacheDirectoryPath:self.resource];
    
    NSData *dataThatWasSaved = [NSFileManager cfm_retrieveDataFromCacheDirectoryWithPath:self.resource];
    
    XCTAssertEqualObjects(self.dataToBeSaved, dataThatWasSaved, @"Data returned do not match: %@ and %@", self.dataToBeSaved, dataThatWasSaved);
}

- (void)test_saveData_successfulSaveReturnValue
{
    BOOL saved = [NSFileManager cfm_saveData:self.dataToBeSaved toCacheDirectoryPath:self.resource];
    
    XCTAssertTrue(saved, @"Successful save of data should return TRUE");
}

- (void)test_saveData_failedSaveNilDataReturnValue
{
    BOOL saved = [NSFileManager cfm_saveData:nil toCacheDirectoryPath:self.resource];
    
    XCTAssertFalse(saved, @"Failed save of data should return FALSE");
}

- (void)test_saveData_failedSaveNilResourceReturnValue
{
    BOOL saved = [NSFileManager cfm_saveData:self.dataToBeSaved toCacheDirectoryPath:nil];
    
    XCTAssertFalse(saved, @"Failed save of data should return FALSE");
}

- (void)test_saveData_fileOnDiskWithFolder
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toCacheDirectoryPath:self.resourceWithFolder];
    
    NSData *dataThatWasSaved = [NSFileManager cfm_retrieveDataFromCacheDirectoryWithPath:self.resourceWithFolder];
    
    XCTAssertEqualObjects(self.dataToBeSaved, dataThatWasSaved, @"Data returned do not match: %@ and %@", self.dataToBeSaved, dataThatWasSaved);
}

#pragma mark - Retrieval

- (void)test_retrieveDataFromCacheDirectoryWithPath_dataReturned
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toCacheDirectoryPath:self.resource];
    
    NSData *dataThatWasRetrieved = [NSFileManager cfm_retrieveDataFromCacheDirectoryWithPath:self.resource];
    
    XCTAssertEqualObjects(self.dataToBeSaved, dataThatWasRetrieved, @"Data returned do not match: %@ and %@", self.dataToBeSaved, dataThatWasRetrieved);
}

- (void)test_retrieveDataFromCacheDirectoryWithPath_dataReturnedWithFolder
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toCacheDirectoryPath:self.resourceWithFolder];
    
    NSData *dataThatWasRetrieved = [NSFileManager cfm_retrieveDataFromCacheDirectoryWithPath:self.resourceWithFolder];
    
    XCTAssertEqualObjects(self.dataToBeSaved, dataThatWasRetrieved, @"Data returned do not match: %@ and %@", self.dataToBeSaved, dataThatWasRetrieved);
}

- (void)test_retrieveDataFromCacheDirectoryWithPath_nilDataWithNilResource
{
    NSData *dataThatWasRetrieved = [NSFileManager cfm_retrieveDataFromCacheDirectoryWithPath:nil];
    
    XCTAssertNil(dataThatWasRetrieved, @"Data should be nil for a nil path parameter");
}

#pragma mark - FileExists

- (void)test_fileExistsInCacheDirectory_trueReturnValue
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toCacheDirectoryPath:self.resource];
    
    BOOL fileExists = [NSFileManager cfm_fileExistsInCacheDirectory:self.resource];
    
    XCTAssertTrue(fileExists, @"File does exist and should be returned as TRUE");
}

- (void)test_fileExistsInCacheDirectory_falseReturnValueForFileThatDoesNotExist
{
    NSString *resourceThatDoesNotExist = @"unknown.jpg";
    
    BOOL fileExists = [NSFileManager cfm_fileExistsInCacheDirectory:resourceThatDoesNotExist];
    
    XCTAssertFalse(fileExists, @"File does not exist and should be returned as FALSE");
}

- (void)test_fileExistsInCacheDirectory_falseReturnValueForNilParameter
{
    BOOL fileExists = [NSFileManager cfm_fileExistsInCacheDirectory:nil];
    
    XCTAssertFalse(fileExists, @"Nil parameter and should be returned as FALSE");
}

#pragma mark - Deleting

- (void)test_deleteDataFromCacheDirectoryWithPath_deletesSavedFile
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toCacheDirectoryPath:self.resource];
    
    [NSFileManager cfm_deleteDataFromCacheDirectoryWithPath:self.resource];
    
    BOOL fileExists = [NSFileManager cfm_fileExistsInCacheDirectory:self.resource];
    
    XCTAssertFalse(fileExists, @"File should not exist as file should have been deleted, this call should be returned as FALSE");
}

- (void)test_deleteDataFromCacheDirectoryWithPath_deletesSavedFileReturnValue
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toCacheDirectoryPath:self.resource];
    
    BOOL deletion = [NSFileManager cfm_deleteDataFromCacheDirectoryWithPath:self.resource];
    
    XCTAssertTrue(deletion, @"File should not exist as file should have been deleted, this call should be returned as FALSE");
}

- (void)test_deleteDataFromCacheDirectoryWithPath_falseReturnValueForFileThatDoesNotExist
{
    NSString *resourceThatDoesNotExist = @"unknown.jpg";
    
    BOOL deletion = [NSFileManager cfm_deleteDataFromCacheDirectoryWithPath:resourceThatDoesNotExist];
    
    XCTAssertFalse(deletion, @"Deletion should return FALSE as the resource does not exist");
}

- (void)test_deleteDataFromCacheDirectoryWithPath_falseReturnValueForNilParameter
{
    BOOL deletion = [NSFileManager cfm_deleteDataFromCacheDirectoryWithPath:nil];
    
    XCTAssertFalse(deletion, @"Deletion should return FALSE as the resource is nil");
}

- (void)test_deleteDataFromCacheDirectoryWithPath_deletesSavedFileWithFolder
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toCacheDirectoryPath:self.resourceWithFolder];
    
    [NSFileManager cfm_deleteDataFromCacheDirectoryWithPath:self.resourceWithFolder];
    
    BOOL fileExists = [NSFileManager cfm_fileExistsInCacheDirectory:self.resourceWithFolder];
    
    XCTAssertFalse(fileExists, @"File should not exist as file should have been deleted, this call should be returned as FALSE");
}

@end
