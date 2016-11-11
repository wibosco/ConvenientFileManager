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
    
    lazy var documentsDirectoryURL: URL = {
        let documentsDirectoryURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last
        
        return documentsDirectoryURL!
    }()
    
    //MARK: TestSuiteLifecycle
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        if FileManager.fileExists(absolutePath: self.resource) {
            FileManager.deleteData(absolutePath: self.resource)
        }
        
        if FileManager.fileExists(absolutePath: self.resourceWithFolder) {
            FileManager.deleteData(absolutePath: self.resourceWithFolder)
        }
        
        let documentsTestFolder = FileManager.documentsDirectoryPathForResource(relativePath: self.testFolder)
        
        if FileManager.fileExists(absolutePath: documentsTestFolder) {
            FileManager.deleteData(absolutePath: documentsTestFolder)
        }
        
        super.tearDown()
    }
    
    //MARK: Path
    
    func test_documentsDirectoryPath_fullPathToDocumentsDirectory() {
        let expectedDocumentsDirectoryPath = self.documentsDirectoryURL.path
        
        let returnedDocumentsDirectoryPath = FileManager.documentsDirectoryPath()
        
        XCTAssertEqual(returnedDocumentsDirectoryPath, expectedDocumentsDirectoryPath, "Paths returned do not match: \(returnedDocumentsDirectoryPath) and \(expectedDocumentsDirectoryPath)")
    }
    
    func test_documentsDirectoryPathForResourceWithPath_fullPathToResource() {
        let expectedDocumentsDirectoryPath = (self.documentsDirectoryURL.path) + "/" + self.resource
        let returnedDocumentsDirectoryPath = FileManager.documentsDirectoryPathForResource(relativePath: self.resource)
        
        XCTAssertEqual(returnedDocumentsDirectoryPath, expectedDocumentsDirectoryPath, "Paths returned do not match: \(returnedDocumentsDirectoryPath) and \(expectedDocumentsDirectoryPath)")
    }
    
    func test_documentsDirectoryPathForResourceWithPath_fullPathToResourceWithFolder() {
        let expectedDocumentsDirectoryPath = (self.documentsDirectoryURL.path) + "/" + self.resourceWithFolder
        let returnedDocumentsDirectoryPath = FileManager.documentsDirectoryPathForResource(relativePath: self.resourceWithFolder)
        
        XCTAssertEqual(returnedDocumentsDirectoryPath, expectedDocumentsDirectoryPath, "Paths returned do not match: \(returnedDocumentsDirectoryPath) and \(expectedDocumentsDirectoryPath)")
    }
    
    func test_documentsDirectoryPathForResourceWithPath_emptyResource() {
        let expectedDocumentsDirectoryPath = (self.documentsDirectoryURL.path)
        let returnedDocumentsDirectoryPath = FileManager.documentsDirectoryPathForResource(relativePath: "")
        
        XCTAssertEqual(returnedDocumentsDirectoryPath, expectedDocumentsDirectoryPath, "Paths returned do not match: \(returnedDocumentsDirectoryPath) and \(expectedDocumentsDirectoryPath)")
    }
    
    //MARK: Saving
    
    func test_saveData_fileOnDisk() {
        FileManager.saveDataToDocumentsDirectory(data: self.dataToBeSaved, relativePath: self.resource)
        
        let dataThatWasSaved = FileManager.retrieveDataFromDocumentsDirectory(relativePath: self.resource)
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasSaved)")
    }
    
    func test_saveData_successfulSaveReturnValue() {
        let saved = FileManager.saveDataToDocumentsDirectory(data: self.dataToBeSaved, relativePath: self.resource)
        
        XCTAssertTrue(saved, "Successful save of data should return TRUE")
    }
    
    func test_saveData_failedSaveEmptyDataReturnValue() {
        let saved = FileManager.saveDataToDocumentsDirectory(data: self.emptyData, relativePath: self.resource)
        
        XCTAssertFalse(saved, "Failed save of data should return FALSE");
    }
    
    func test_saveData_failedSaveNilResourceReturnValue() {
        let saved = FileManager.saveDataToDocumentsDirectory(data: self.dataToBeSaved, relativePath: "")
        
        XCTAssertFalse(saved, "Failed save of data should return FALSE");
    }
    
    func test_saveData_fileOnDiskWithFolder() {
        FileManager.saveDataToDocumentsDirectory(data: self.dataToBeSaved, relativePath: self.resourceWithFolder)
        
        let dataThatWasSaved = FileManager.retrieveDataFromDocumentsDirectory(relativePath: self.resourceWithFolder)!
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasSaved)");
    }
    
    //MARK: Retrieval
    
    func test_retrieveDataFromDocumentsDirectory_dataReturned() {
        FileManager.saveDataToDocumentsDirectory(data: self.dataToBeSaved, relativePath: self.resource)
        
        let dataThatWasRetrieved = FileManager.retrieveDataFromDocumentsDirectory(relativePath: self.resource)!
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasRetrieved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasRetrieved)");
    }
    
    func test_retrieveDataFromDocumentsDirectory_dataReturnedWithFolder() {
        FileManager.saveDataToDocumentsDirectory(data: self.dataToBeSaved, relativePath: self.resourceWithFolder)
        
        let dataThatWasRetrieved = FileManager.retrieveDataFromDocumentsDirectory(relativePath: self.resourceWithFolder)!
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasRetrieved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasRetrieved)");
    }
    
    func test_retrieveDataFromDocumentsDirectory_emptyDataWithNilResource() {
        let dataThatWasRetrieved = FileManager.retrieveDataFromDocumentsDirectory(relativePath: "")
        
        XCTAssertNil(dataThatWasRetrieved, "Data should be nil for an empty path parameter")
    }
    
    //MARK: FileExists
    
    func test_fileExistsInDocumentsDirectory_falseReturnValueForFileThatDoesNotExist() {
        let resourceThatDoesNotExist = "unknown.jpg"
        
        let fileExists = FileManager.fileExistsInDocumentsDirectory(relativePath: resourceThatDoesNotExist)
        
        XCTAssertFalse(fileExists, "File does not exist and should be returned as FALSE")
    }
    
    func test_fileExistsInDocumentsDirectory_falseReturnValueForEmptyParameter() {
        let fileExists = FileManager.fileExistsInDocumentsDirectory(relativePath: "")
        
        XCTAssertFalse(fileExists, "Empty parameter and should be returned as FALSE")
    }
    
    //MARK: Deleting
    
    func test_deleteDataFromDocumentsDirectory_deletesSavedFile() {
        FileManager.saveDataToDocumentsDirectory(data: self.dataToBeSaved, relativePath: self.resource)
        
        FileManager.deleteDataFromDocumentsDirectory(relativePath: self.resource)
        
        let fileExists = FileManager.fileExistsInDocumentsDirectory(relativePath: self.resource)
        
        XCTAssertFalse(fileExists, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
    
    func test_deleteDataFromDocumentsDirectory_deletesSavedFileReturnValue() {
        FileManager.saveDataToDocumentsDirectory(data: self.dataToBeSaved, relativePath: self.resource)
        
        let deleted = FileManager.deleteDataFromDocumentsDirectory(relativePath: self.resource)
        
        XCTAssertTrue(deleted, "File should not exist as file should have been deleted, this call should be returned as TRUE")
    }
    
    func test_deleteDataFromDocumentsDirectory_falseReturnValueForFileThatDoesNotExist() {
        let resourceThatDoesNotExist = "unknown.jpg"
        
        let deleted = FileManager.deleteDataFromDocumentsDirectory(relativePath: resourceThatDoesNotExist)
        
        XCTAssertFalse(deleted, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
    
    func test_deleteDataFromDocumentsDirectory_falseReturnValueForEmptyParameter() {
        let deleted = FileManager.deleteDataFromDocumentsDirectory(relativePath: "")
        
        XCTAssertFalse(deleted, "Deletion should return FALSE as the resource is empty")
    }
    
    func test_deleteDataFromDocumentsDirectory_deletesSavedFileWithFolder() {
        FileManager.saveDataToDocumentsDirectory(data: self.dataToBeSaved, relativePath: self.resourceWithFolder)
        
        FileManager.deleteDataFromDocumentsDirectory(relativePath: self.resourceWithFolder)
        
        let fileExists = FileManager.fileExistsInDocumentsDirectory(relativePath: self.resourceWithFolder)
        
        XCTAssertFalse(fileExists, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
}
