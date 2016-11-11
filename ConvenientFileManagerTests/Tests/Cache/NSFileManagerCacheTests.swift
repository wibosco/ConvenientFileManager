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
    
    lazy var dataToBeSaved: Data = {
        let dataToSaved = "Test string to be converted into data".data(using: String.Encoding.utf8)
        
        return dataToSaved!
    }()
    
    lazy var emptyData: Data = {
        let emptyData = "".data(using: String.Encoding.utf8)
        
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
    
    lazy var cachedDirectoryURL: URL = {
        let cachedDirectoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last
        
        return cachedDirectoryURL!
    }()
    
    //MARK: TestSuiteLifecycle
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        if FileManager.fileExistsAtPath(self.resource) {
            FileManager.deleteDataAtPath(self.resource)
        }
        
        if FileManager.fileExistsAtPath(self.resourceWithFolder) {
            FileManager.deleteDataAtPath(self.resourceWithFolder)
        }
        
        let cacheTestFolder = FileManager.cacheDirectoryPathForResourceWithPath(self.testFolder)
        
        if FileManager.fileExistsAtPath(cacheTestFolder) {
            FileManager.deleteDataAtPath(cacheTestFolder)
        }
        
        super.tearDown()
    }
    
    //MARK: Path
    
    func test_cacheDirectoryPath_fullPathToCacheDirectory() {
        let expectedCacheDirectoryPath = self.cachedDirectoryURL.path
        
        let returnedCacheDirectoryPath = FileManager.cacheDirectoryPath()
        
        XCTAssertEqual(returnedCacheDirectoryPath, expectedCacheDirectoryPath, "Paths returned do not match: \(returnedCacheDirectoryPath) and \(expectedCacheDirectoryPath)")
    }
    
    func test_cacheDirectoryPathForResourceWithPath_fullPathToResource() {
        let expectedCacheDirectoryPath = (self.cachedDirectoryURL.path) + "/" + self.resource
        let returnedCacheDirectoryPath = FileManager.cacheDirectoryPathForResourceWithPath(self.resource)
        
        XCTAssertEqual(returnedCacheDirectoryPath, expectedCacheDirectoryPath, "Paths returned do not match: \(returnedCacheDirectoryPath) and \(expectedCacheDirectoryPath)")
    }
    
    func test_cacheDirectoryPathForResourceWithPath_fullPathToResourceWithFolder() {
        let expectedCacheDirectoryPath = (self.cachedDirectoryURL.path) + "/" + self.resourceWithFolder
        let returnedCacheDirectoryPath = FileManager.cacheDirectoryPathForResourceWithPath(self.resourceWithFolder)
        
        XCTAssertEqual(returnedCacheDirectoryPath, expectedCacheDirectoryPath, "Paths returned do not match: \(returnedCacheDirectoryPath) and \(expectedCacheDirectoryPath)")
    }
    
    func test_cacheDirectoryPathForResourceWithPath_emptyResource() {
        let expectedCacheDirectoryPath = (self.cachedDirectoryURL.path)
        let returnedCacheDirectoryPath = FileManager.cacheDirectoryPathForResourceWithPath("")
        
        XCTAssertEqual(returnedCacheDirectoryPath, expectedCacheDirectoryPath, "Paths returned do not match: \(returnedCacheDirectoryPath) and \(expectedCacheDirectoryPath)")
    }
    
    //MARK: Saving
    
    func test_saveData_fileOnDisk() {
        FileManager.saveDataToCacheDirectory(self.dataToBeSaved, relativePath: self.resource)
        
        let dataThatWasSaved = FileManager.retrieveDataFromCacheDirectory(self.resource)
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasSaved)")
    }
    
    func test_saveData_successfulSaveReturnValue() {
        let saved = FileManager.saveDataToCacheDirectory(self.dataToBeSaved, relativePath: self.resource)
        
        XCTAssertTrue(saved, "Successful save of data should return TRUE")
    }
    
    func test_saveData_failedSaveEmptyDataReturnValue() {
        let saved = FileManager.saveDataToCacheDirectory(self.emptyData, relativePath: self.resource)
        
        XCTAssertFalse(saved, "Failed save of data should return FALSE");
    }
   
    func test_saveData_failedSaveNilResourceReturnValue() {
        let saved = FileManager.saveDataToCacheDirectory(self.dataToBeSaved, relativePath: "")
        
        XCTAssertFalse(saved, "Failed save of data should return FALSE");
    }
    
    func test_saveData_fileOnDiskWithFolder() {
        FileManager.saveDataToCacheDirectory(self.dataToBeSaved, relativePath: self.resourceWithFolder)
        
        let dataThatWasSaved = FileManager.retrieveDataFromCacheDirectory(self.resourceWithFolder)!
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasSaved)");
    }
    
    //MARK: Retrieval
    
    func test_retrieveDataFromCacheDirectoryWithPath_dataReturned() {
        FileManager.saveDataToCacheDirectory(self.dataToBeSaved, relativePath: self.resource)
        
        let dataThatWasRetrieved = FileManager.retrieveDataFromCacheDirectory(self.resource)!
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasRetrieved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasRetrieved)");
    }
    
    func test_retrieveDataFromCacheDirectoryWithPath_dataReturnedWithFolder() {
        FileManager.saveDataToCacheDirectory(self.dataToBeSaved, relativePath: self.resourceWithFolder)
        
        let dataThatWasRetrieved = FileManager.retrieveDataFromCacheDirectory(self.resourceWithFolder)!
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasRetrieved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasRetrieved)");
    }
    
    func test_retrieveDataFromCacheDirectoryWithPath_emptyDataWithNilResource() {
        let dataThatWasRetrieved = FileManager.retrieveDataFromCacheDirectory("")
        
        XCTAssertNil(dataThatWasRetrieved, "Data should be nil for an empty path parameter")
    }
    
    //MARK: FileExists
    
    func test_fileExistsInCacheDirectory_falseReturnValueForFileThatDoesNotExist() {
        let resourceThatDoesNotExist = "unknown.jpg"
        
        let fileExists = FileManager.fileExistsInCacheDirectory(resourceThatDoesNotExist)
        
        XCTAssertFalse(fileExists, "File does not exist and should be returned as FALSE")
    }
    
    func test_fileExistsInCacheDirectory_falseReturnValueForEmptyParameter() {
        let fileExists = FileManager.fileExistsInCacheDirectory("")
        
        XCTAssertFalse(fileExists, "Empty parameter and should be returned as FALSE")
    }
    
    //MARK: Deleting 
    
    func test_deleteDataFromCacheDirectoryWithPath_deletesSavedFile() {
        FileManager.saveDataToCacheDirectory(self.dataToBeSaved, relativePath: self.resource)
        
        FileManager.deleteDataFromCacheDirectory(self.resource)
        
        let fileExists = FileManager.fileExistsInCacheDirectory(self.resource)
        
         XCTAssertFalse(fileExists, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
    
    func test_deleteDataFromCacheDirectoryWithPath_deletesSavedFileReturnValue() {
        FileManager.saveDataToCacheDirectory(self.dataToBeSaved, relativePath: self.resource)
        
       let deleted = FileManager.deleteDataFromCacheDirectory(self.resource)
        
        XCTAssertTrue(deleted, "File should not exist as file should have been deleted, this call should be returned as TRUE")
    }
    
    func test_deleteDataFromCacheDirectoryWithPath_falseReturnValueForFileThatDoesNotExist() {
        let resourceThatDoesNotExist = "unknown.jpg"
        
        let deleted = FileManager.deleteDataFromCacheDirectory(resourceThatDoesNotExist)
        
        XCTAssertFalse(deleted, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }

    func test_deleteDataFromCacheDirectoryWithPath_falseReturnValueForEmptyParameter() {
        let deleted = FileManager.deleteDataFromCacheDirectory("")
        
        XCTAssertFalse(deleted, "Deletion should return FALSE as the resource is empty")
    }

    func test_deleteDataFromCacheDirectoryWithPath_deletesSavedFileWithFolder() {
        FileManager.saveDataToCacheDirectory(self.dataToBeSaved, relativePath: self.resourceWithFolder)
        
        FileManager.deleteDataFromCacheDirectory(self.resourceWithFolder)
        
        let fileExists = FileManager.fileExistsInCacheDirectory(self.resourceWithFolder)
        
        XCTAssertFalse(fileExists, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }

}
