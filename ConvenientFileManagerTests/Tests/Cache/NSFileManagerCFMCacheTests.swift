//
//  NSFileManagerCFMCacheTests.swift
//  ConvenientFileManager
//
//  Created by William Boles on 29/03/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest

class NSFileManagerCFMCacheTests: XCTestCase {
    
    //MARK: Accessors
    
    lazy var dataToBeSaved: NSData = {
        let dataToSaved = "Test string to be converted into data".dataUsingEncoding(NSUTF8StringEncoding)
        
        return dataToSaved!
    }()
    
    lazy var emptyData: NSData = {
        let emptyData = "".dataUsingEncoding(NSUTF8StringEncoding)
        
        return emptyData!
    }()
    
    var testFolder: String = {
        let testFolder = "test"
        
        return testFolder
    }()
    
    lazy var resource: String = {
        let resource = "test.mp4"
        
        return resource
    }()
    
    lazy var resourceWithFolder: String = {
        let resourceWithFolder = "\(self.testFolder)/test.mp4"
        
        return resourceWithFolder
    }()
    
    lazy var cachedDirectoryURL: NSURL = {
        let cachedDirectoryURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.CachesDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last
        
        return cachedDirectoryURL!
    }()
    
    //MARK: TestSuiteLifecycle
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        if NSFileManager.fileExistsAtPath(self.resource) {
            NSFileManager.deleteDataAtPath(self.resource)
        }
        
        if NSFileManager.fileExistsAtPath(self.resourceWithFolder) {
            NSFileManager.deleteDataAtPath(self.resourceWithFolder)
        }
        
        let cacheTestFolder = NSFileManager.cacheDirectoryPathForResourceWithPath(self.testFolder)
        
        if NSFileManager.fileExistsAtPath(cacheTestFolder) {
            NSFileManager.deleteDataAtPath(cacheTestFolder)
        }
        
        super.tearDown()
    }
    
    //MARK: Path
    
    func test_cacheDirectoryPath_fullPathToCacheDirectory() {
        let expectedCacheDirectoryPath = self.cachedDirectoryURL.path
        
        let returnedCacheDirectoryPath = NSFileManager.cacheDirectoryPath()
        
        XCTAssertEqual(returnedCacheDirectoryPath, expectedCacheDirectoryPath, "Paths returned do not match: \(returnedCacheDirectoryPath) and \(expectedCacheDirectoryPath)")
    }
    
    func test_cacheDirectoryPathForResourceWithPath_fullPathToResource() {
        let expectedCacheDirectoryPath = (self.cachedDirectoryURL.path)! + "/" + self.resource
        let returnedCacheDirectoryPath = NSFileManager.cacheDirectoryPathForResourceWithPath(self.resource)
        
        XCTAssertEqual(returnedCacheDirectoryPath, expectedCacheDirectoryPath, "Paths returned do not match: \(returnedCacheDirectoryPath) and \(expectedCacheDirectoryPath)")
    }
    
    func test_cacheDirectoryPathForResourceWithPath_fullPathToResourceWithFolder() {
        let expectedCacheDirectoryPath = (self.cachedDirectoryURL.path)! + "/" + self.resourceWithFolder
        let returnedCacheDirectoryPath = NSFileManager.cacheDirectoryPathForResourceWithPath(self.resourceWithFolder)
        
        XCTAssertEqual(returnedCacheDirectoryPath, expectedCacheDirectoryPath, "Paths returned do not match: \(returnedCacheDirectoryPath) and \(expectedCacheDirectoryPath)")
    }
    
    func test_cacheDirectoryPathForResourceWithPath_emptyResource() {
        let expectedCacheDirectoryPath = (self.cachedDirectoryURL.path)!
        let returnedCacheDirectoryPath = NSFileManager.cacheDirectoryPathForResourceWithPath("")
        
        XCTAssertEqual(returnedCacheDirectoryPath, expectedCacheDirectoryPath, "Paths returned do not match: \(returnedCacheDirectoryPath) and \(expectedCacheDirectoryPath)")
    }
    
    //MARK: Saving
    
    func test_saveData_fileOnDisk() {
        NSFileManager.saveDataToCacheDirectory(self.dataToBeSaved, relativePath: self.resource)
        
        let dataThatWasSaved = NSFileManager.retrieveDataFromCacheDirectory(self.resource)
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasSaved)")
    }
    
    func test_saveData_successfulSaveReturnValue() {
        let saved = NSFileManager.saveDataToCacheDirectory(self.dataToBeSaved, relativePath: self.resource)
        
        XCTAssertTrue(saved, "Successful save of data should return TRUE")
    }
    
    func test_saveData_failedSaveEmptyDataReturnValue() {
        let saved = NSFileManager.saveDataToCacheDirectory(self.emptyData, relativePath: self.resource)
        
        XCTAssertFalse(saved, "Failed save of data should return FALSE");
    }
   
    func test_saveData_failedSaveNilResourceReturnValue() {
        let saved = NSFileManager.saveDataToCacheDirectory(self.dataToBeSaved, relativePath: "")
        
        XCTAssertFalse(saved, "Failed save of data should return FALSE");
    }
    
    func test_saveData_fileOnDiskWithFolder() {
        NSFileManager.saveDataToCacheDirectory(self.dataToBeSaved, relativePath: self.resourceWithFolder)
        
        let dataThatWasSaved = NSFileManager.retrieveDataFromCacheDirectory(self.resourceWithFolder)!
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasSaved)");
    }
    
    //MARK: Retrieval
    
    func test_retrieveDataFromCacheDirectoryWithPath_dataReturned() {
        NSFileManager.saveDataToCacheDirectory(self.dataToBeSaved, relativePath: self.resource)
        
        let dataThatWasRetrieved = NSFileManager.retrieveDataFromCacheDirectory(self.resource)!
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasRetrieved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasRetrieved)");
    }
    
    func test_retrieveDataFromCacheDirectoryWithPath_dataReturnedWithFolder() {
        NSFileManager.saveDataToCacheDirectory(self.dataToBeSaved, relativePath: self.resourceWithFolder)
        
        let dataThatWasRetrieved = NSFileManager.retrieveDataFromCacheDirectory(self.resourceWithFolder)!
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasRetrieved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasRetrieved)");
    }
    
    func test_retrieveDataFromCacheDirectoryWithPath_emptyDataWithNilResource() {
        let dataThatWasRetrieved = NSFileManager.retrieveDataFromCacheDirectory("")
        
        XCTAssertNil(dataThatWasRetrieved, "Data should be nil for an empty path parameter")
    }
    
    //MARK: FileExists
    
    func test_fileExistsInCacheDirectory_falseReturnValueForFileThatDoesNotExist() {
        let resourceThatDoesNotExist = "unknown.jpg"
        
        let fileExists = NSFileManager.fileExistsInCacheDirectory(resourceThatDoesNotExist)
        
        XCTAssertFalse(fileExists, "File does not exist and should be returned as FALSE")
    }
    
    func test_fileExistsInCacheDirectory_falseReturnValueForEmptyParameter() {
        let fileExists = NSFileManager.fileExistsInCacheDirectory("")
        
        XCTAssertFalse(fileExists, "Empty parameter and should be returned as FALSE")
    }
    
    //MARK: Deleting 
    
    func test_deleteDataFromCacheDirectoryWithPath_deletesSavedFile() {
        NSFileManager.saveDataToCacheDirectory(self.dataToBeSaved, relativePath: self.resource)
        
        NSFileManager.deleteDataFromCacheDirectory(self.resource)
        
        let fileExists = NSFileManager.fileExistsInCacheDirectory(self.resource)
        
         XCTAssertFalse(fileExists, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
    
    func test_deleteDataFromCacheDirectoryWithPath_deletesSavedFileReturnValue() {
        NSFileManager.saveDataToCacheDirectory(self.dataToBeSaved, relativePath: self.resource)
        
       let deleted = NSFileManager.deleteDataFromCacheDirectory(self.resource)
        
        XCTAssertTrue(deleted, "File should not exist as file should have been deleted, this call should be returned as TRUE")
    }
    
    func test_deleteDataFromCacheDirectoryWithPath_falseReturnValueForFileThatDoesNotExist() {
        let resourceThatDoesNotExist = "unknown.jpg"
        
        let deleted = NSFileManager.deleteDataFromCacheDirectory(resourceThatDoesNotExist)
        
        XCTAssertFalse(deleted, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }

    func test_deleteDataFromCacheDirectoryWithPath_falseReturnValueForEmptyParameter() {
        let deleted = NSFileManager.deleteDataFromCacheDirectory("")
        
        XCTAssertFalse(deleted, "Deletion should return FALSE as the resource is empty")
    }

    func test_deleteDataFromCacheDirectoryWithPath_deletesSavedFileWithFolder() {
        NSFileManager.saveDataToCacheDirectory(self.dataToBeSaved, relativePath: self.resourceWithFolder)
        
        NSFileManager.deleteDataFromCacheDirectory(self.resourceWithFolder)
        
        let fileExists = NSFileManager.fileExistsInCacheDirectory(self.resourceWithFolder)
        
        XCTAssertFalse(fileExists, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }

}
