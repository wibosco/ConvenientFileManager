//
//  FileManagerCFMPersistenceTests.swift
//  ConvenientFileManager
//
//  Created by William Boles on 29/03/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest

class FileManagerCFMPersistenceTests: XCTestCase {

    // MARK: - Accessor
    
    var dataToBeSaved: Data = {
        let dataToSaved = "Test string to be converted into data".data(using: String.Encoding.utf8)
        
        return dataToSaved!
    }()
    
    var emptyData: Data = {
        let emptyData = "".data(using: String.Encoding.utf8)
        
        return emptyData!
    }()
    
    var testFolder: String = {
        let testFolder = "test"
        
        return testFolder
    }()
    
    lazy var absolutePath: String = {
        let absolutePath = FileManager.documentsDirectoryPathForResource(relativePath: "test.mp4")
        
        return absolutePath
    }()
    
    lazy var absolutePathWithSpaceInFilename: String = {
        let absolutePathWithSpaceInFilename = FileManager.documentsDirectoryPathForResource(relativePath: "test 98.mp4")
        
        return absolutePathWithSpaceInFilename
    }()
    
    lazy var absolutePathWithAdditionalDirectory: String = {
        let absolutePathWithAdditionalDirectory = FileManager.cacheDirectoryPathForResource(relativePath: "\(self.testFolder)/test/test.mp4")
        
        return absolutePathWithAdditionalDirectory
    }()
    
    lazy var absolutePathWithoutFile: String = {
        let absolutePathWithoutFile = FileManager.cacheDirectoryPathForResource(relativePath: "\(self.testFolder)/testcache")
        
        return absolutePathWithoutFile
    }()
    
    lazy var absoluteSourcePath: String = {
        let absoluteSourcePath = FileManager.cacheDirectoryPathForResource(relativePath: "\(self.testFolder)/source.png")
        
        return absoluteSourcePath
    }()
    
    lazy var absoluteSourcePathWithSpaceInFilename: String = {
        let absoluteSourcePathWithSpaceInFilename = FileManager.cacheDirectoryPathForResource(relativePath: "\(self.testFolder)/source 98.png")
        
        return absoluteSourcePathWithSpaceInFilename
    }()
    
    lazy var absoluteDestinationPath: String = {
        let absoluteDestinationPath = FileManager.cacheDirectoryPathForResource(relativePath: "\(self.testFolder)/destination.png")
        
        return absoluteDestinationPath
    }()
    
    lazy var absoluteDestinationPathWithSpaceInFilename: String = {
        let absoluteDestinationPathWithSpaceInFilename = FileManager.cacheDirectoryPathForResource(relativePath: "\(self.testFolder)/destination 879.png")
        
        return absoluteDestinationPathWithSpaceInFilename
    }()
    
    // MARK: - TestSuiteLifecycle
    
    override func setUp() {
        super.setUp()
        
        FileManager.write(data: dataToBeSaved, absolutePath: absoluteSourcePath)
        FileManager.write(data: dataToBeSaved, absolutePath: absoluteSourcePathWithSpaceInFilename)
    }
    
    override func tearDown() {
        
        if FileManager.fileExists(absolutePath: absolutePath) {
           FileManager.deleteData(absolutePath: absolutePath)
        }
        
        if FileManager.fileExists(absolutePath: absolutePathWithSpaceInFilename) {
            FileManager.deleteData(absolutePath: absolutePathWithSpaceInFilename)
        }
        
        if FileManager.fileExists(absolutePath: absolutePathWithAdditionalDirectory) {
            FileManager.deleteData(absolutePath: absolutePathWithAdditionalDirectory)
        }
        
        if FileManager.fileExists(absolutePath: absolutePathWithoutFile) {
            FileManager.deleteData(absolutePath: absolutePathWithoutFile)
        }
        
        if FileManager.fileExists(absolutePath: absoluteDestinationPath) {
            FileManager.deleteData(absolutePath: absoluteDestinationPath)
        }
        
        if FileManager.fileExists(absolutePath: absoluteSourcePath) {
            FileManager.deleteData(absolutePath: absoluteSourcePath)
        }
        
        if FileManager.fileExists(absolutePath: absoluteDestinationPathWithSpaceInFilename) {
            FileManager.deleteData(absolutePath: absoluteDestinationPathWithSpaceInFilename)
        }
        
        if FileManager.fileExists(absolutePath: absoluteSourcePathWithSpaceInFilename) {
            FileManager.deleteData(absolutePath: absoluteSourcePathWithSpaceInFilename)
        }
        
        let documentsTestFolder = FileManager.documentsDirectoryPathForResource(relativePath: self.testFolder)
        
        if FileManager.fileExists(absolutePath: documentsTestFolder) {
            FileManager.deleteData(absolutePath: documentsTestFolder)
        }
        
        let cacheTestFolder = FileManager.cacheDirectoryPathForResource(relativePath: self.testFolder)
        
        if FileManager.fileExists(absolutePath: cacheTestFolder) {
            FileManager.deleteData(absolutePath: cacheTestFolder)
        }
        
        super.tearDown()
    }

    // MARK: - URL
    
    func test_fileURL_url() {
        let expectedURL = URL(fileURLWithPath: absolutePath)
        let returnedURL = FileManager.fileURL(absolutePath: absolutePath)
        
        XCTAssertEqual(returnedURL, expectedURL, "URLs returned do not match: \(returnedURL) and \(expectedURL)")
    }
    
    // MARK: - Retrieval
    
    func test_retrieveData_dataReturned() {
        FileManager.write(data: dataToBeSaved, absolutePath: absolutePath)
        
        let dataThatWasRetrieved = FileManager.retrieveData(absolutePath: absolutePath)!
        
        XCTAssertEqual(dataToBeSaved, dataThatWasRetrieved, "Data returned do not match: \(dataToBeSaved) and \(dataThatWasRetrieved)");
    }
    
    func test_retrieveData_dataReturnedWithFolder() {
        FileManager.write(data: dataToBeSaved, absolutePath: absolutePathWithAdditionalDirectory)
        
        let dataThatWasRetrieved = FileManager.retrieveData(absolutePath: absolutePathWithAdditionalDirectory)!
        
        XCTAssertEqual(dataToBeSaved, dataThatWasRetrieved, "Data returned do not match: \(dataToBeSaved) and \(dataThatWasRetrieved)");
    }
    
    func test_retrieveData_emptyDataWithNilResource() {
        let dataThatWasRetrieved = FileManager.retrieveData(absolutePath: "")
        
        XCTAssertNil(dataThatWasRetrieved, "Data should be nil for an empty path parameter")
    }
    
    // MARK: - Write
    
    func test_write_fileOnDisk() {
        FileManager.write(data: dataToBeSaved, absolutePath: absolutePath)
        
        let dataThatWasSaved = FileManager.retrieveData(absolutePath: absolutePath)
        
        XCTAssertEqual(dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(dataToBeSaved) and \(String(describing: dataThatWasSaved))")
    }
    
    func test_write_fileOnDiskWithSpaceInFilename() {
        FileManager.write(data: dataToBeSaved, absolutePath: absolutePathWithSpaceInFilename)
        
        let dataThatWasSaved = FileManager.retrieveData(absolutePath: absolutePathWithSpaceInFilename)
        
        XCTAssertEqual(dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(dataToBeSaved) and \(String(describing: dataThatWasSaved))")
    }
    
    func test_write_successfulSaveReturnValue() {
        let saved = FileManager.write(data: dataToBeSaved, absolutePath: absolutePath)
        
        XCTAssertTrue(saved, "Successful save of data should return TRUE")
    }
    
    func test_write_failedSaveEmptyDataReturnValue() {
        let saved = FileManager.write(data: emptyData, absolutePath: absolutePath)
        
        XCTAssertFalse(saved, "Failed save of data should return FALSE")
    }

    func test_write_failedSaveEmptyPathReturnValue() {
        let saved = FileManager.write(data: dataToBeSaved, absolutePath: "")
        
        XCTAssertFalse(saved, "Failed save of data should return FALSE")
    }
    
    func test_write_fileOnDiskWithDirectoryCreation() {
        FileManager.write(data: dataToBeSaved, absolutePath: absolutePathWithAdditionalDirectory)
        
        let dataThatWasSaved = FileManager.retrieveData(absolutePath: absolutePathWithAdditionalDirectory)
        
        XCTAssertEqual(dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(dataToBeSaved) and \(String(describing: dataThatWasSaved))")
    }
    
    // MARK: - Directory
    
    func test_createDirectory_directoryCreatedWithFile() {
        FileManager.createDirectory(absoluteDirectoryPath: absolutePathWithAdditionalDirectory)
        
        let fileExists = FileManager.fileExists(absolutePath:  absolutePathWithAdditionalDirectory)
        
        XCTAssertTrue(fileExists, "File should exist within a custom directory")
    }
    
    func test_createDirectory_directoryCreatedWithoutFile() {
        FileManager.createDirectory(absoluteDirectoryPath: absolutePathWithoutFile)
        
        let fileExists = FileManager.fileExists(absolutePath:  absolutePathWithoutFile)
        
        XCTAssertTrue(fileExists, "Directory should be created")
    }
    
    func test_createDirectory_returnValue() {
        let directoryCreated = FileManager.createDirectory(absoluteDirectoryPath: absolutePathWithAdditionalDirectory)
        
        XCTAssertTrue(directoryCreated, "TRUE should be returned when custom directory is created")
    }
    
    func test_createDirectory_failedCreationNilPathReturnValue() {
        let directoryCreated = FileManager.createDirectory(absoluteDirectoryPath: "")
        
        XCTAssertFalse(directoryCreated, "FALSE should be returned when not path is provided")
    }

    // MARK: - FileExists
    
    func test_fileExists_trueReturnValue() {
        FileManager.write(data: dataToBeSaved, absolutePath: absolutePath)
        
        let fileExists = FileManager.fileExists(absolutePath:  absolutePath)
        
        XCTAssertTrue(fileExists, "File does exist and should be returned as TRUE")
    }
    
    func test_fileExists_trueReturnValueWithSpaceInFilename() {
        FileManager.write(data: dataToBeSaved, absolutePath: absolutePathWithoutFile)
        
        let fileExists = FileManager.fileExists(absolutePath:  absolutePathWithoutFile)
        
        XCTAssertTrue(fileExists, "File does exist and should be returned as TRUE")
    }

    func test_fileExists_falseReturnValueForFileThatDoesNotExist() {
        let resourceThatDoesNotExist = "unknown.jpg"
        
        let fileExists = FileManager.fileExists(absolutePath:  resourceThatDoesNotExist)
        
        XCTAssertFalse(fileExists, "File does not exist and should be returned as FALSE")
    }
    
    func test_fileExists_falseReturnValueForEmptyParameter() {
        let fileExists = FileManager.fileExists(absolutePath:  "")
        
        XCTAssertFalse(fileExists, "Empty parameter and should be returned as FALSE")
    }
    
    // MARK: - FileExistsAsync
    
    func test_fileExistsAsync_trueReturnValue() {
        FileManager.write(data: dataToBeSaved, absolutePath: absolutePath)
        
        let expectation = self.expectation(description: "Handler called")
        
        FileManager.fileExists(absolutePath: absolutePath) { (fileExists) in
            XCTAssertTrue(fileExists, "File does exist and should be returned as TRUE")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_fileExistsAsync_falseReturnValueForFileThatDoesNotExist() {
        let resourceThatDoesNotExist = "unknown.jpg"
        
        let expectation = self.expectation(description: "Handler called")
        
        FileManager.fileExists(absolutePath: resourceThatDoesNotExist) { (fileExists) in
            XCTAssertFalse(fileExists, "File does not exist and should be returned as FALSE")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_fileExistsAsync_falseReturnValueForEmptyParameter() {
        let expectation = self.expectation(description: "Handler called")
        
        FileManager.fileExists(absolutePath: "") { (fileExists) in
            XCTAssertFalse(fileExists, "Empty parameter and should be returned as FALSE")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_fileExistsAsync_returnedOnCallerThread() {
        FileManager.write(data: dataToBeSaved, absolutePath: absolutePath)
        
        let expectation = self.expectation(description: "Handler called")
        
        let currentQueue = OperationQueue.current
        
        FileManager.fileExists(absolutePath: absolutePath) { (fileExists) in
            XCTAssertEqual(currentQueue, OperationQueue.current, "Should be returned on the celler thread")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    // MARK: - Deletion
    
    func test_deleteData_deletesSavedFile() {
        FileManager.write(data: dataToBeSaved, absolutePath: absolutePath)
        
        FileManager.deleteData(absolutePath: absolutePath)
        
        let fileExists = FileManager.fileExists(absolutePath:  absolutePath)
        
        XCTAssertFalse(fileExists, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
    
    func test_deleteData_deletesSavedFileReturnValue() {
        FileManager.write(data: dataToBeSaved, absolutePath: absolutePath)
        
        let deleted = FileManager.deleteData(absolutePath: absolutePath)
        
        XCTAssertTrue(deleted, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
    
    func test_deleteData_falseReturnValueForFileThatDoesNotExist() {
        let resourceThatDoesNotExist = "unknown.jpg"
        
        let deleted = FileManager.deleteData(absolutePath: resourceThatDoesNotExist)
        
        XCTAssertFalse(deleted, "Deletion should return FALSE as the resource does not exist")
    }
    
    func test_deleteData_falseReturnValueForEmptyParameter() {
        let deleted = FileManager.deleteData(absolutePath: "")
        
        XCTAssertFalse(deleted, "Deletion should return FALSE as the resource is nil")
    }
    
    func test_deleteData_deletesSavedFileWithFolder() {
        FileManager.write(data: dataToBeSaved, absolutePath: absolutePathWithAdditionalDirectory)
        
        FileManager.deleteData(absolutePath: absolutePathWithAdditionalDirectory)
        
        let fileExists = FileManager.deleteData(absolutePath: absolutePathWithAdditionalDirectory)
        
        XCTAssertFalse(fileExists, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
    
    // MARK: - Move
    
    func test_moveFileFromSourcePath_fileMoved() {
        FileManager.moveFile(sourceAbsolutePath: absoluteSourcePath, destinationAbsolutePath: absoluteDestinationPath)
        
        let fileMoved = FileManager.fileExists(absolutePath:  absoluteDestinationPath)
        
        XCTAssertTrue(fileMoved, "File has not been moved")
    }
    
    func test_moveFileFromSourcePath_fileMovedWithSpaceInSourcePathFileName() {
        FileManager.moveFile(sourceAbsolutePath: absoluteSourcePathWithSpaceInFilename, destinationAbsolutePath: absoluteDestinationPath)
        
        let fileMoved = FileManager.fileExists(absolutePath:  absoluteDestinationPath)
        
        XCTAssertTrue(fileMoved, "File has not been moved")
    }
    
    func test_moveFileFromSourcePath_fileMovedWithSpaceInDestinationPathFileName() {
        FileManager.moveFile(sourceAbsolutePath: absoluteSourcePath, destinationAbsolutePath: absoluteDestinationPathWithSpaceInFilename)
        
        let fileMoved = FileManager.fileExists(absolutePath:  absoluteDestinationPathWithSpaceInFilename)
        
        XCTAssertTrue(fileMoved, "File has not been moved")
    }
    
    func test_moveFileFromSourcePath_trueReturnValueWhenFileMoved() {
        let fileMoved = FileManager.moveFile(sourceAbsolutePath: absoluteSourcePath, destinationAbsolutePath: absoluteDestinationPath)
        
        XCTAssertTrue(fileMoved, "File has not been moved")
    }

    func test_moveFileFromSourcePath_falseReturnValueWhenEmptySource() {
        let fileMoved = FileManager.moveFile(sourceAbsolutePath: "", destinationAbsolutePath: absoluteDestinationPath)
        
        XCTAssertFalse(fileMoved, "Source is empty so file shouldn't have been moved")
    }
    
    func test_moveFileFromSourcePath_falseReturnValueWhenEmptyDestination() {
        let fileMoved = FileManager.moveFile(sourceAbsolutePath: absoluteSourcePath, destinationAbsolutePath: "")
        
        XCTAssertFalse(fileMoved, "Destination is empty so file shouldn't have been moved")
    }
 
}
