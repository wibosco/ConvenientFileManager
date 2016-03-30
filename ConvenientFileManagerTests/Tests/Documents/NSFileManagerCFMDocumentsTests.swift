//
//  NSFileManagerCFMDocumentsTests.swift
//  ConvenientFileManager
//
//  Created by William Boles on 30/03/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest

class NSFileManagerCFMDocumentsTests: XCTestCase {

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
    
    lazy var documentsDirectoryURL: NSURL = {
        let documentsDirectoryURL = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last
        
        return documentsDirectoryURL!
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
        
        let documentsTestFolder = NSFileManager.documentsDirectoryPathForResourceWithPath(self.testFolder)
        
        if NSFileManager.fileExistsAtPath(documentsTestFolder) {
            NSFileManager.deleteDataAtPath(documentsTestFolder)
        }
        
        super.tearDown()
    }
    
    //MARK: Path
    
    func test_documentsDirectoryPath_fullPathToDocumentsDirectory() {
        let expectedDocumentsDirectoryPath = self.documentsDirectoryURL.path
        
        let returnedDocumentsDirectoryPath = NSFileManager.documentsDirectoryPath()
        
        XCTAssertEqual(returnedDocumentsDirectoryPath, expectedDocumentsDirectoryPath, "Paths returned do not match: \(returnedDocumentsDirectoryPath) and \(expectedDocumentsDirectoryPath)")
    }
    
    func test_documentsDirectoryPathForResourceWithPath_fullPathToResource() {
        let expectedDocumentsDirectoryPath = (self.documentsDirectoryURL.path)! + "/" + self.resource
        let returnedDocumentsDirectoryPath = NSFileManager.documentsDirectoryPathForResourceWithPath(self.resource)
        
        XCTAssertEqual(returnedDocumentsDirectoryPath, expectedDocumentsDirectoryPath, "Paths returned do not match: \(returnedDocumentsDirectoryPath) and \(expectedDocumentsDirectoryPath)")
    }
    
    func test_documentsDirectoryPathForResourceWithPath_fullPathToResourceWithFolder() {
        let expectedDocumentsDirectoryPath = (self.documentsDirectoryURL.path)! + "/" + self.resourceWithFolder
        let returnedDocumentsDirectoryPath = NSFileManager.documentsDirectoryPathForResourceWithPath(self.resourceWithFolder)
        
        XCTAssertEqual(returnedDocumentsDirectoryPath, expectedDocumentsDirectoryPath, "Paths returned do not match: \(returnedDocumentsDirectoryPath) and \(expectedDocumentsDirectoryPath)")
    }
    
    func test_documentsDirectoryPathForResourceWithPath_emptyResource() {
        let expectedDocumentsDirectoryPath = (self.documentsDirectoryURL.path)!
        let returnedDocumentsDirectoryPath = NSFileManager.documentsDirectoryPathForResourceWithPath("")
        
        XCTAssertEqual(returnedDocumentsDirectoryPath, expectedDocumentsDirectoryPath, "Paths returned do not match: \(returnedDocumentsDirectoryPath) and \(expectedDocumentsDirectoryPath)")
    }
    
    //MARK: Saving
    
    func test_saveData_fileOnDisk() {
        NSFileManager.saveDataToDocumentsDirectory(self.dataToBeSaved, relativePath: self.resource)
        
        let dataThatWasSaved = NSFileManager.retrieveDataFromDocumentsDirectory(self.resource)
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasSaved)")
    }
    
    func test_saveData_successfulSaveReturnValue() {
        let saved = NSFileManager.saveDataToDocumentsDirectory(self.dataToBeSaved, relativePath: self.resource)
        
        XCTAssertTrue(saved, "Successful save of data should return TRUE")
    }
    
    func test_saveData_failedSaveEmptyDataReturnValue() {
        let saved = NSFileManager.saveDataToDocumentsDirectory(self.emptyData, relativePath: self.resource)
        
        XCTAssertFalse(saved, "Failed save of data should return FALSE");
    }
    
    func test_saveData_failedSaveNilResourceReturnValue() {
        let saved = NSFileManager.saveDataToDocumentsDirectory(self.dataToBeSaved, relativePath: "")
        
        XCTAssertFalse(saved, "Failed save of data should return FALSE");
    }
    
    func test_saveData_fileOnDiskWithFolder() {
        NSFileManager.saveDataToDocumentsDirectory(self.dataToBeSaved, relativePath: self.resourceWithFolder)
        
        let dataThatWasSaved = NSFileManager.retrieveDataFromDocumentsDirectory(self.resourceWithFolder)!
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasSaved)");
    }
    
    //MARK: Retrieval
    
    func test_retrieveDataFromDocumentsDirectoryWithPath_dataReturned() {
        NSFileManager.saveDataToDocumentsDirectory(self.dataToBeSaved, relativePath: self.resource)
        
        let dataThatWasRetrieved = NSFileManager.retrieveDataFromDocumentsDirectory(self.resource)!
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasRetrieved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasRetrieved)");
    }
    
    func test_retrieveDataFromDocumentsDirectoryWithPath_dataReturnedWithFolder() {
        NSFileManager.saveDataToDocumentsDirectory(self.dataToBeSaved, relativePath: self.resourceWithFolder)
        
        let dataThatWasRetrieved = NSFileManager.retrieveDataFromDocumentsDirectory(self.resourceWithFolder)!
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasRetrieved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasRetrieved)");
    }
    
    func test_retrieveDataFromDocumentsDirectoryWithPath_emptyDataWithNilResource() {
        let dataThatWasRetrieved = NSFileManager.retrieveDataFromDocumentsDirectory("")
        
        XCTAssertNil(dataThatWasRetrieved, "Data should be nil for an empty path parameter")
    }
    
    //MARK: FileExists
    
    func test_fileExistsInDocumentsDirectory_falseReturnValueForFileThatDoesNotExist() {
        let resourceThatDoesNotExist = "unknown.jpg"
        
        let fileExists = NSFileManager.fileExistsInDocumentsDirectory(resourceThatDoesNotExist)
        
        XCTAssertFalse(fileExists, "File does not exist and should be returned as FALSE")
    }
    
    func test_fileExistsInDocumentsDirectory_falseReturnValueForEmptyParameter() {
        let fileExists = NSFileManager.fileExistsInDocumentsDirectory("")
        
        XCTAssertFalse(fileExists, "Empty parameter and should be returned as FALSE")
    }
    
    //MARK: Deleting
    
    func test_deleteDataFromDocumentsDirectoryWithPath_deletesSavedFile() {
        NSFileManager.saveDataToDocumentsDirectory(self.dataToBeSaved, relativePath: self.resource)
        
        NSFileManager.deleteDataFromDocumentsDirectory(self.resource)
        
        let fileExists = NSFileManager.fileExistsInDocumentsDirectory(self.resource)
        
        XCTAssertFalse(fileExists, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
    
    func test_deleteDataFromDocumentsDirectoryWithPath_deletesSavedFileReturnValue() {
        NSFileManager.saveDataToDocumentsDirectory(self.dataToBeSaved, relativePath: self.resource)
        
        let deleted = NSFileManager.deleteDataFromDocumentsDirectory(self.resource)
        
        XCTAssertTrue(deleted, "File should not exist as file should have been deleted, this call should be returned as TRUE")
    }
    
    func test_deleteDataFromDocumentsDirectoryWithPath_falseReturnValueForFileThatDoesNotExist() {
        let resourceThatDoesNotExist = "unknown.jpg"
        
        let deleted = NSFileManager.deleteDataFromDocumentsDirectory(resourceThatDoesNotExist)
        
        XCTAssertFalse(deleted, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
    
    func test_deleteDataFromDocumentsDirectoryWithPath_falseReturnValueForEmptyParameter() {
        let deleted = NSFileManager.deleteDataFromDocumentsDirectory("")
        
        XCTAssertFalse(deleted, "Deletion should return FALSE as the resource is empty")
    }
    
    func test_deleteDataFromDocumentsDirectoryWithPath_deletesSavedFileWithFolder() {
        NSFileManager.saveDataToDocumentsDirectory(self.dataToBeSaved, relativePath: self.resourceWithFolder)
        
        NSFileManager.deleteDataFromDocumentsDirectory(self.resourceWithFolder)
        
        let fileExists = NSFileManager.fileExistsInDocumentsDirectory(self.resourceWithFolder)
        
        XCTAssertFalse(fileExists, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
}
