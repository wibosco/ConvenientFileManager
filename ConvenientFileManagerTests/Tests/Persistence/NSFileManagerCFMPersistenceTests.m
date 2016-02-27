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
@property (nonatomic, strong) NSString *absolutePathWithoutFile;
@property (nonatomic, strong) NSString *absoluteSourcePath;
@property (nonatomic, strong) NSString *absoluteDestinationPath;

@end

@implementation NSFileManagerCFMPersistenceTests

#pragma mark - TestSuiteLifecycle

- (void)setUp
{
    [super setUp];
    
    self.dataToBeSaved = [@"Test string to be converted into data" dataUsingEncoding:NSUTF8StringEncoding];
    self.absolutePath = [NSFileManager cfm_documentsDirectoryPathForResourceWithPath:@"test.mp4"];
    self.absolutePathWithAdditionalDirectory = [NSFileManager cfm_cacheDirectoryPathForResourceWithPath:@"test/test/test.mp4"];
    self.absolutePathWithoutFile = [NSFileManager cfm_cacheDirectoryPathForResourceWithPath:@"test/testcache"];
    self.absoluteSourcePath = [NSFileManager cfm_cacheDirectoryPathForResourceWithPath:@"test/source"];
    self.absoluteDestinationPath = [NSFileManager cfm_cacheDirectoryPathForResourceWithPath:@"test/destination"];
    
    [NSFileManager cfm_saveData:self.dataToBeSaved
                         toPath:self.absoluteSourcePath];
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
    
    if ([NSFileManager cfm_fileExistsAtPath:self.absolutePathWithoutFile])
    {
        [NSFileManager cfm_deleteDataAtPath:self.absolutePathWithoutFile];
    }
    
    if ([NSFileManager cfm_fileExistsAtPath:self.absoluteDestinationPath])
    {
        [NSFileManager cfm_deleteDataAtPath:self.absoluteDestinationPath];
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

- (void)test_saveData_failedSaveNilPathReturnValue
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

#pragma mark - Directory

- (void)test_createDirectoryAtPath_directoryCreatedWithFile
{
    [NSFileManager cfm_createDirectoryAtPath:self.absolutePathWithAdditionalDirectory];
    
    BOOL fileExists = [NSFileManager cfm_fileExistsAtPath:self.absolutePathWithAdditionalDirectory];
    
    XCTAssertTrue(fileExists, @"File should exist within a custom directory");
}

- (void)test_createDirectoryAtPath_directoryCreatedWithoutFile
{
    [NSFileManager cfm_createDirectoryAtPath:self.absolutePathWithoutFile];
    
    BOOL fileExists = [NSFileManager cfm_fileExistsAtPath:self.absolutePathWithoutFile];
    
    XCTAssertTrue(fileExists, @"Directory should be created");
}

- (void)test_createDirectoryAtPath_returnValue
{
    BOOL directoryCreated = [NSFileManager cfm_createDirectoryAtPath:self.absolutePathWithAdditionalDirectory];
    
    XCTAssertTrue(directoryCreated, @"TRUE should be returned when custom directory is created");
}

- (void)test_createDirectoryAtPath_failedCreationNilPathReturnValue
{
    BOOL directoryCreated = [NSFileManager cfm_createDirectoryAtPath:nil];
    
    XCTAssertFalse(directoryCreated, @"FALSE should be returned when not path is provided");
}

#pragma mark - FileExists

- (void)test_fileExistsAtPath_trueReturnValue
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toPath:self.absolutePath];
    
    BOOL fileExists = [NSFileManager cfm_fileExistsAtPath:self.absolutePath];
    
    XCTAssertTrue(fileExists, @"File does exist and should be returned as TRUE");
}

- (void)test_fileExistsAtPath_falseReturnValueForFileThatDoesNotExist
{
    NSString *resourceThatDoesNotExist = @"unknown.jpg";
    
    BOOL fileExists = [NSFileManager cfm_fileExistsAtPath:resourceThatDoesNotExist];
    
    XCTAssertFalse(fileExists, @"File does not exist and should be returned as FALSE");
}

- (void)test_fileExistsAtPath_falseReturnValueForNilParameter
{
    BOOL fileExists = [NSFileManager cfm_fileExistsAtPath:nil];
    
    XCTAssertFalse(fileExists, @"Nil parameter and should be returned as FALSE");
}

#pragma mark - FileExistsAsync

- (void)test_fileExistsAtPathAsync_trueReturnValue
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toPath:self.absolutePath];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    
    [NSFileManager cfm_fileExistsAtPath:self.absolutePath
                             completion:^(BOOL fileExists)
     {
         XCTAssertTrue(fileExists, @"File does exist and should be returned as TRUE");
         [expectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:1.0
                                 handler:nil];
}

- (void)test_fileExistsAtPathAsync_falseReturnValueForFileThatDoesNotExist
{
    NSString *resourceThatDoesNotExist = @"unknown.jpg";
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    
    [NSFileManager cfm_fileExistsAtPath:resourceThatDoesNotExist
                             completion:^(BOOL fileExists)
     {
         XCTAssertFalse(fileExists, @"File does not exist and should be returned as FALSE");
         [expectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:1.0
                                 handler:nil];
}

- (void)test_fileExistsAtPathAsync_falseReturnValueForNilParameter
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    
    [NSFileManager cfm_fileExistsAtPath:nil
                             completion:^(BOOL fileExists)
     {
         XCTAssertFalse(fileExists, @"Nil parameter and should be returned as FALSE");
         [expectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:1.0
                                 handler:nil];
}

- (void)test_fileExistsAtPathAsync_returnedOnCallerThread
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toPath:self.absolutePath];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    
    NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
    
    [NSFileManager cfm_fileExistsAtPath:self.absolutePath
                             completion:^(BOOL fileExists)
     {
         XCTAssertEqualObjects(currentQueue, [NSOperationQueue currentQueue], @"Should be returned on the celler thread");
         [expectation fulfill];
     }];
    
    [self waitForExpectationsWithTimeout:1.0
                                 handler:nil];

}

#pragma mark - Deletion

- (void)test_deleteDataFromDocumentsDirectoryWithPath_deletesSavedFile
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toPath:self.absolutePath];
    
    [NSFileManager cfm_deleteDataAtPath:self.absolutePath];
    
    BOOL fileExists = [NSFileManager cfm_fileExistsAtPath:self.absolutePath];
    
    XCTAssertFalse(fileExists, @"File should not exist as file should have been deleted, this call should be returned as FALSE");
}

- (void)test_deleteDataFromDocumentsDirectoryWithPath_deletesSavedFileReturnValue
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toPath:self.absolutePath];
    
    BOOL deletion = [NSFileManager cfm_deleteDataAtPath:self.absolutePath];
    
    XCTAssertTrue(deletion, @"File should not exist as file should have been deleted, this call should be returned as FALSE");
}

- (void)test_deleteDataFromDocumentsDirectoryWithPath_falseReturnValueForFileThatDoesNotExist
{
    NSString *resourceThatDoesNotExist = @"unknown.jpg";
    
    BOOL deletion = [NSFileManager cfm_deleteDataAtPath:resourceThatDoesNotExist];
    
    XCTAssertFalse(deletion, @"Deletion should return FALSE as the resource does not exist");
}

- (void)test_deleteDataFromDocumentsDirectoryWithPath_falseReturnValueForNilParameter
{
    BOOL deletion = [NSFileManager cfm_deleteDataAtPath:nil];
    
    XCTAssertFalse(deletion, @"Deletion should return FALSE as the resource is nil");
}

- (void)test_deleteDataFromDocumentsDirectoryWithPath_deletesSavedFileWithFolder
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toPath:self.absolutePathWithAdditionalDirectory];
    
    [NSFileManager cfm_deleteDataAtPath:self.absolutePathWithAdditionalDirectory];
    
    BOOL fileExists = [NSFileManager cfm_deleteDataAtPath:self.absolutePathWithAdditionalDirectory];
    
    XCTAssertFalse(fileExists, @"File should not exist as file should have been deleted, this call should be returned as FALSE");
}

#pragma mark - Move

- (void)test_moveFileFromSourcePath_fileMoved
{
    [NSFileManager cfm_moveFileFromSourcePath:self.absoluteSourcePath
                            toDestinationPath:self.absoluteDestinationPath];
    
    BOOL fileMoved = [NSFileManager cfm_fileExistsAtPath:self.absoluteDestinationPath];
    
    XCTAssertTrue(fileMoved, @"File has not been moved");
}

- (void)test_moveFileFromSourcePath_trueReturnValueWhenFileMoved
{
    BOOL fileMoved = [NSFileManager cfm_moveFileFromSourcePath:self.absoluteSourcePath
                                             toDestinationPath:self.absoluteDestinationPath];
    
    XCTAssertTrue(fileMoved, @"File has not been moved");
}

- (void)test_moveFileFromSourcePath_falseReturnValueWhenNilSource
{
    BOOL fileMoved = [NSFileManager cfm_moveFileFromSourcePath:nil
                                             toDestinationPath:self.absoluteDestinationPath];
    
    XCTAssertFalse(fileMoved, @"Source isn't set so file shouldn't have been moved");
}

- (void)test_moveFileFromSourcePath_falseReturnValueWhenNilDestination
{
    BOOL fileMoved = [NSFileManager cfm_moveFileFromSourcePath:self.absoluteSourcePath
                                             toDestinationPath:nil];
    
    XCTAssertFalse(fileMoved, @"Source isn't set so file shouldn't have been moved");
}

@end
