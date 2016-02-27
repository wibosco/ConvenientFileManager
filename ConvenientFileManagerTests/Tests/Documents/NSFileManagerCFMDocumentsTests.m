//
//  NSFileManagerCFMDocumentsTests.m
//  ConvenientFileManager
//
//  Created by Home on 27/02/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NSFileManager+CFMDocuments.h"

@interface NSFileManagerCFMDocumentsTests : XCTestCase

@property (nonatomic, strong) NSData *dataToBeSaved;
@property (nonatomic, strong) NSString *resource;
@property (nonatomic, strong) NSString *resourceWithFolder;

@end

@implementation NSFileManagerCFMDocumentsTests

#pragma mark - TestSuiteLifecycle

- (void)setUp
{
    [super setUp];
    
    self.dataToBeSaved = [@"Test string to be converted into data" dataUsingEncoding:NSUTF8StringEncoding];
    self.resource = @"text.mp4";
    self.resourceWithFolder = @"test/test.mp4";
}

- (void)tearDown
{
    self.dataToBeSaved = nil;
    self.resource = nil;
    self.resourceWithFolder = nil;
    
    if ([NSFileManager cfm_fileExistsInDocumentsDirectory:self.resource])
    {
        [NSFileManager cfm_deleteDataFromDocumentsDirectoryWithPath:self.resource];
    }
    
    if ([NSFileManager cfm_fileExistsInDocumentsDirectory:self.resourceWithFolder])
    {
        [NSFileManager cfm_deleteDataFromDocumentsDirectoryWithPath:self.resourceWithFolder];
    }
    
    [super tearDown];
}

#pragma mark - Path

- (void)test_DocumentsDirectoryPath_fullPathToDocumentsDirectory
{
    NSURL *directoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                  inDomains:NSUserDomainMask] lastObject];
    
    NSString *expectedDocumentsDirectoryPath = [directoryURL path];
    
    NSString *returnedDocumentsDirectoryPath = [NSFileManager cfm_documentsDirectoryPath];
    
    XCTAssertEqualObjects(returnedDocumentsDirectoryPath, expectedDocumentsDirectoryPath, @"Paths returned do not match: %@ and %@", returnedDocumentsDirectoryPath, expectedDocumentsDirectoryPath);
}

- (void)test_DocumentsDirectoryPathForResourceWithPath_fullPathToResource
{
    NSURL *directoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                  inDomains:NSUserDomainMask] lastObject];
    
    NSString *expectedDocumentsDirectoryPath = [NSString stringWithFormat:@"%@/%@", [directoryURL path], self.resource];
    
    NSString *returnedDocumentsDirectoryPath = [NSFileManager cfm_documentsDirectoryPathForResourceWithPath:self.resource];
    
    XCTAssertEqualObjects(returnedDocumentsDirectoryPath, expectedDocumentsDirectoryPath, @"Paths returned do not match: %@ and %@", returnedDocumentsDirectoryPath, expectedDocumentsDirectoryPath);
}

- (void)test_DocumentsDirectoryPathForResourceWithPath_fullPathToResourceWithFolder
{
    NSURL *directoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                  inDomains:NSUserDomainMask] lastObject];
    
    NSString *expectedDocumentsDirectoryPath = [NSString stringWithFormat:@"%@/%@", [directoryURL path], self.resourceWithFolder];
    
    NSString *returnedDocumentsDirectoryPath = [NSFileManager cfm_documentsDirectoryPathForResourceWithPath:self.resourceWithFolder];
    
    XCTAssertEqualObjects(returnedDocumentsDirectoryPath, expectedDocumentsDirectoryPath, @"Paths returned do not match: %@ and %@", returnedDocumentsDirectoryPath, expectedDocumentsDirectoryPath);
}

- (void)test_DocumentsDirectoryPathForResourceWithPath_nilResource
{
    NSURL *directoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                                  inDomains:NSUserDomainMask] lastObject];
    
    NSString *expectedDocumentsDirectoryPath = [directoryURL path];
    
    NSString *returnedDocumentsDirectoryPath = [NSFileManager cfm_documentsDirectoryPathForResourceWithPath:nil];
    
    XCTAssertEqualObjects(returnedDocumentsDirectoryPath, expectedDocumentsDirectoryPath, @"Paths returned do not match: %@ and %@", returnedDocumentsDirectoryPath, expectedDocumentsDirectoryPath);
}

#pragma mark - Saving

- (void)test_saveData_fileOnDisk
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toDocumentsDirectoryPath:self.resource];
    
    NSData *dataThatWasSaved = [NSFileManager cfm_retrieveDataFromDocumentsDirectoryWithPath:self.resource];
    
    XCTAssertEqualObjects(self.dataToBeSaved, dataThatWasSaved, @"Data returned do not match: %@ and %@", self.dataToBeSaved, dataThatWasSaved);
}

- (void)test_saveData_successfulSaveReturnValue
{
    BOOL saved = [NSFileManager cfm_saveData:self.dataToBeSaved toDocumentsDirectoryPath:self.resource];
    
    XCTAssertTrue(saved, @"Successful save of data should return TRUE");
}

- (void)test_saveData_failedSaveNilDataReturnValue
{
    BOOL saved = [NSFileManager cfm_saveData:nil toDocumentsDirectoryPath:self.resource];
    
    XCTAssertFalse(saved, @"Failed save of data should return FALSE");
}

- (void)test_saveData_failedSaveNilResourceReturnValue
{
    BOOL saved = [NSFileManager cfm_saveData:self.dataToBeSaved toDocumentsDirectoryPath:nil];
    
    XCTAssertFalse(saved, @"Failed save of data should return FALSE");
}

- (void)test_saveData_fileOnDiskWithFolder
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toDocumentsDirectoryPath:self.resourceWithFolder];
    
    NSData *dataThatWasSaved = [NSFileManager cfm_retrieveDataFromDocumentsDirectoryWithPath:self.resourceWithFolder];
    
    XCTAssertEqualObjects(self.dataToBeSaved, dataThatWasSaved, @"Data returned do not match: %@ and %@", self.dataToBeSaved, dataThatWasSaved);
}

#pragma mark - Retrieval

- (void)test_retrieveDataFromDocumentsDirectoryWithPath_dataReturned
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toDocumentsDirectoryPath:self.resource];
    
    NSData *dataThatWasRetrieved = [NSFileManager cfm_retrieveDataFromDocumentsDirectoryWithPath:self.resource];
    
    XCTAssertEqualObjects(self.dataToBeSaved, dataThatWasRetrieved, @"Data returned do not match: %@ and %@", self.dataToBeSaved, dataThatWasRetrieved);
}

- (void)test_retrieveDataFromDocumentsDirectoryWithPath_dataReturnedWithFolder
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toDocumentsDirectoryPath:self.resourceWithFolder];
    
    NSData *dataThatWasRetrieved = [NSFileManager cfm_retrieveDataFromDocumentsDirectoryWithPath:self.resourceWithFolder];
    
    XCTAssertEqualObjects(self.dataToBeSaved, dataThatWasRetrieved, @"Data returned do not match: %@ and %@", self.dataToBeSaved, dataThatWasRetrieved);
}

- (void)test_retrieveDataFromDocumentsDirectoryWithPath_nilDataWithNilResource
{
    NSData *dataThatWasRetrieved = [NSFileManager cfm_retrieveDataFromDocumentsDirectoryWithPath:nil];
    
    XCTAssertNil(dataThatWasRetrieved, @"Data should be nil for a nil path parameter");
}

#pragma mark - FileExists

- (void)test_fileExistsInDocumentsDirectory_trueReturnValue
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toDocumentsDirectoryPath:self.resource];
    
    BOOL fileExists = [NSFileManager cfm_fileExistsInDocumentsDirectory:self.resource];
    
    XCTAssertTrue(fileExists, @"File does exist and should be returned as TRUE");
}

- (void)test_fileExistsInDocumentsDirectory_falseReturnValueForFileThatDoesNotExist
{
    NSString *resourceThatDoesNotExist = @"unknown.jpg";
    
    BOOL fileExists = [NSFileManager cfm_fileExistsInDocumentsDirectory:resourceThatDoesNotExist];
    
    XCTAssertFalse(fileExists, @"File does not exist and should be returned as FALSE");
}

- (void)test_fileExistsInDocumentsDirectory_falseReturnValueForNilParameter
{
    BOOL fileExists = [NSFileManager cfm_fileExistsInDocumentsDirectory:nil];
    
    XCTAssertFalse(fileExists, @"Nil parameter and should be returned as FALSE");
}

#pragma mark - Deleting

- (void)test_deleteDataFromDocumentsDirectoryWithPath_deletesSavedFile
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toDocumentsDirectoryPath:self.resource];
    
    [NSFileManager cfm_deleteDataFromDocumentsDirectoryWithPath:self.resource];
    
    BOOL fileExists = [NSFileManager cfm_fileExistsInDocumentsDirectory:self.resource];
    
    XCTAssertFalse(fileExists, @"File should not exist as file should have been deleted, this call should be returned as FALSE");
}

- (void)test_deleteDataFromDocumentsDirectoryWithPath_deletesSavedFileReturnValue
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toDocumentsDirectoryPath:self.resource];
    
    BOOL deletion = [NSFileManager cfm_deleteDataFromDocumentsDirectoryWithPath:self.resource];
    
    XCTAssertTrue(deletion, @"File should not exist as file should have been deleted, this call should be returned as FALSE");
}

- (void)test_deleteDataFromDocumentsDirectoryWithPath_falseReturnValueForFileThatDoesNotExist
{
    NSString *resourceThatDoesNotExist = @"unknown.jpg";
    
    BOOL deletion = [NSFileManager cfm_deleteDataFromDocumentsDirectoryWithPath:resourceThatDoesNotExist];
    
    XCTAssertFalse(deletion, @"Deletion should return FALSE as the resource does not exist");
}

- (void)test_deleteDataFromDocumentsDirectoryWithPath_falseReturnValueForNilParameter
{
    BOOL deletion = [NSFileManager cfm_deleteDataFromDocumentsDirectoryWithPath:nil];
    
    XCTAssertFalse(deletion, @"Deletion should return FALSE as the resource is nil");
}

- (void)test_deleteDataFromDocumentsDirectoryWithPath_deletesSavedFileWithFolder
{
    [NSFileManager cfm_saveData:self.dataToBeSaved toDocumentsDirectoryPath:self.resourceWithFolder];
    
    [NSFileManager cfm_deleteDataFromDocumentsDirectoryWithPath:self.resourceWithFolder];
    
    BOOL fileExists = [NSFileManager cfm_fileExistsInDocumentsDirectory:self.resourceWithFolder];
    
    XCTAssertFalse(fileExists, @"File should not exist as file should have been deleted, this call should be returned as FALSE");
}

@end

