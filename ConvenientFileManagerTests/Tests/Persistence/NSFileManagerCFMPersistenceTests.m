//
//  NSFileManagerCFMPersistenceTests.m
//  ConvenientFileManager
//
//  Created by Home on 27/02/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSFileManager+CFMPersistence.h"
#import "NSFileManager+CFMDocuments.h"
#import "NSFileManager+CFMCache.h"

@interface NSFileManagerCFMPersistenceTests : XCTestCase

@property (nonatomic, strong) NSData *dataToBeSaved;
@property (nonatomic, strong) NSString *absolutePath;
@property (nonatomic, strong) NSString *absolutePathWithAdditionalDirectory;

@end

@implementation NSFileManagerCFMPersistenceTests

#pragma mark - TestSuiteLifecycle

- (void)setUp
{
    [super setUp];
    
    self.dataToBeSaved = [@"Test string to be converted into data" dataUsingEncoding:NSUTF8StringEncoding];
    self.absolutePath = [NSFileManager cfm_documentsDirectoryPathForResourceWithPath:@"test.mp4"];
    self.absolutePathWithAdditionalDirectory = [NSFileManager cfm_cacheDirectoryPathForResourceWithPath:@"test/test.mp4"];
}

- (void)tearDown
{
    self.dataToBeSaved = nil;
    self.absolutePath = nil;
    
    if ([NSFileManager cfm_fileExistsAtPath:self.absolutePath])
    {
        [NSFileManager cfm_deleteDataAtPath:self.absolutePath];
    }
    
    if ([NSFileManager cfm_fileExistsAtPath:self.absolutePathWithAdditionalDirectory])
    {
        [NSFileManager cfm_deleteDataAtPath:self.absolutePathWithAdditionalDirectory];
    }
    
    [super tearDown];
}

#pragma mark - URL

- (void)test_fileURLForPath_url
{
    NSURL *expectedURL = [NSURL fileURLWithPath:self.absolutePath];
    
    NSURL *returnedURL = [NSFileManager cfm_fileURLForPath:self.absolutePath];
    
    XCTAssertEqualObjects(returnedURL, expectedURL, @"URLs returned do not match: %@ and %@", returnedURL, expectedURL);
}

#pragma mark - Saving

- (void)test_saveData_fileOnDisk
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toPath:self.absolutePath];
    
    NSData *dataThatWasSaved = [NSFileManager cfm_retrieveDataAtPath:self.absolutePath];
    
    XCTAssertEqualObjects(self.dataToBeSaved, dataThatWasSaved, @"Data returned do not match: %@ and %@", self.dataToBeSaved, dataThatWasSaved);
}

- (void)test_saveData_successfulSaveReturnValue
{
    BOOL saved = [NSFileManager cfm_saveData:self.dataToBeSaved toPath:self.absolutePath];
    
    XCTAssertTrue(saved, @"Successful save of data should return TRUE");
}

- (void)test_saveData_failedSaveNilDataReturnValue
{
    BOOL saved = [NSFileManager cfm_saveData:nil toPath:self.absolutePath];
    
    XCTAssertFalse(saved, @"Failed save of data should return FALSE");
}

- (void)test_saveData_failedSaveNilResourceReturnValue
{
    BOOL saved = [NSFileManager cfm_saveData:self.dataToBeSaved toPath:nil];
    
    XCTAssertFalse(saved, @"Failed save of data should return FALSE");
}

- (void)test_saveData_fileOnDiskWithDirectoryCreation
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toPath:self.absolutePathWithAdditionalDirectory];
    
    NSData *dataThatWasSaved = [NSFileManager cfm_retrieveDataAtPath:self.absolutePathWithAdditionalDirectory];
    
    XCTAssertEqualObjects(self.dataToBeSaved, dataThatWasSaved, @"Data returned do not match: %@ and %@", self.dataToBeSaved, dataThatWasSaved);
}

@end
