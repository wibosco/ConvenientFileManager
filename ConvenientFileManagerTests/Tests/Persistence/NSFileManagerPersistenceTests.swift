//
//  NSFileManagerCFMPersistenceTests.swift
//  ConvenientFileManager
//
//  Created by William Boles on 29/03/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import XCTest

class NSFileManagerCFMPersistenceTests: XCTestCase {

    //MARK: Accessor
    
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
    
    //MARK: TestSuiteLifecycle
    
    override func setUp() {
        super.setUp()
        
        FileManager.saveData(data: self.dataToBeSaved, absolutePath: self.absoluteSourcePath)
        FileManager.saveData(data: self.dataToBeSaved, absolutePath: self.absoluteSourcePathWithSpaceInFilename)
    }
    
    override func tearDown() {
        
        if FileManager.fileExists(absolutePath: self.absolutePath) {
           FileManager.deleteData(absolutePath: self.absolutePath)
        }
        
        if FileManager.fileExists(absolutePath: self.absolutePathWithSpaceInFilename) {
            FileManager.deleteData(absolutePath: self.absolutePathWithSpaceInFilename)
        }
        
        if FileManager.fileExists(absolutePath: self.absolutePathWithAdditionalDirectory) {
            FileManager.deleteData(absolutePath: self.absolutePathWithAdditionalDirectory)
        }
        
        if FileManager.fileExists(absolutePath: self.absolutePathWithoutFile) {
            FileManager.deleteData(absolutePath: self.absolutePathWithoutFile)
        }
        
        if FileManager.fileExists(absolutePath: self.absoluteDestinationPath) {
            FileManager.deleteData(absolutePath: self.absoluteDestinationPath)
        }
        
        if FileManager.fileExists(absolutePath: self.absoluteSourcePath) {
            FileManager.deleteData(absolutePath: self.absoluteSourcePath)
        }
        
        if FileManager.fileExists(absolutePath: self.absoluteDestinationPathWithSpaceInFilename) {
            FileManager.deleteData(absolutePath: self.absoluteDestinationPathWithSpaceInFilename)
        }
        
        if FileManager.fileExists(absolutePath: self.absoluteSourcePathWithSpaceInFilename) {
            FileManager.deleteData(absolutePath: self.absoluteSourcePathWithSpaceInFilename)
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

    //MARK: URL
    
    func test_fileURL_url() {
        let expectedURL = URL(fileURLWithPath: self.absolutePath)
        let returnedURL = FileManager.fileURL(absolutePath: self.absolutePath)
        
        XCTAssertEqual(returnedURL, expectedURL, "URLs returned do not match: \(returnedURL) and \(expectedURL)")
    }
    
    //MARK Saving
    
    func test_saveData_fileOnDisk() {
        FileManager.saveData(data: self.dataToBeSaved, absolutePath: self.absolutePath)
        
        let dataThatWasSaved = FileManager.retrieveData(absolutePath: self.absolutePath)
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasSaved)")
    }
    
    func test_saveData_fileOnDiskWithSpaceInFilename() {
        FileManager.saveData(data: self.dataToBeSaved, absolutePath: self.absolutePathWithSpaceInFilename)
        
        let dataThatWasSaved = FileManager.retrieveData(absolutePath: self.absolutePathWithSpaceInFilename)
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasSaved)")
    }
    
    func test_saveData_successfulSaveReturnValue() {
        let saved = FileManager.saveData(data: self.dataToBeSaved, absolutePath: self.absolutePath)
        
        XCTAssertTrue(saved, "Successful save of data should return TRUE")
    }
    
    func test_saveData_failedSaveEmptyDataReturnValue() {
        let saved = FileManager.saveData(data: self.emptyData, absolutePath: self.absolutePath)
        
        XCTAssertFalse(saved, "Failed save of data should return FALSE")
    }

    func test_saveData_failedSaveEmptyPathReturnValue() {
        let saved = FileManager.saveData(data: self.dataToBeSaved, absolutePath: "")
        
        XCTAssertFalse(saved, "Failed save of data should return FALSE")
    }
    
    func test_saveData_fileOnDiskWithDirectoryCreation() {
        FileManager.saveData(data: self.dataToBeSaved, absolutePath: self.absolutePathWithAdditionalDirectory)
        
        let dataThatWasSaved = FileManager.retrieveData(absolutePath: self.absolutePathWithAdditionalDirectory)
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasSaved)")
    }
    
    //MARK: Directory
    
    func test_createDirectory_directoryCreatedWithFile() {
        FileManager.createDirectory(absoluteDirectoryPath: self.absolutePathWithAdditionalDirectory)
        
        let fileExists = FileManager.fileExists(absolutePath:  self.absolutePathWithAdditionalDirectory)
        
        XCTAssertTrue(fileExists, "File should exist within a custom directory")
    }
    
    func test_createDirectory_directoryCreatedWithoutFile() {
        FileManager.createDirectory(absoluteDirectoryPath: self.absolutePathWithoutFile)
        
        let fileExists = FileManager.fileExists(absolutePath:  self.absolutePathWithoutFile)
        
        XCTAssertTrue(fileExists, "Directory should be created")
    }
    
    func test_createDirectory_returnValue() {
        let directoryCreated = FileManager.createDirectory(absoluteDirectoryPath: self.absolutePathWithAdditionalDirectory)
        
        XCTAssertTrue(directoryCreated, "TRUE should be returned when custom directory is created")
    }
    
    func test_createDirectory_failedCreationNilPathReturnValue() {
        let directoryCreated = FileManager.createDirectory(absoluteDirectoryPath: "")
        
        XCTAssertFalse(directoryCreated, "FALSE should be returned when not path is provided")
    }

    //MARK: FileExists
    
    func test_fileExists_trueReturnValue() {
        FileManager.saveData(data: self.dataToBeSaved, absolutePath: self.absolutePath)
        
        let fileExists = FileManager.fileExists(absolutePath:  self.absolutePath)
        
        XCTAssertTrue(fileExists, "File does exist and should be returned as TRUE")
    }
    
    func test_fileExists_trueReturnValueWithSpaceInFilename() {
        FileManager.saveData(data: self.dataToBeSaved, absolutePath: self.absolutePathWithoutFile)
        
        let fileExists = FileManager.fileExists(absolutePath:  self.absolutePathWithoutFile)
        
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
    
    //MARK FileExistsAsync
    
    func test_fileExistsAsync_trueReturnValue() {
        FileManager.saveData(data: self.dataToBeSaved, absolutePath: self.absolutePath)
        
        let expectation = self.expectation(description: "Handler called")
        
        FileManager.fileExists(absolutePath: self.absolutePath) { (fileExists) in
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
        FileManager.saveData(data: self.dataToBeSaved, absolutePath: self.absolutePath)
        
        let expectation = self.expectation(description: "Handler called")
        
        let currentQueue = OperationQueue.current
        
        FileManager.fileExists(absolutePath: self.absolutePath) { (fileExists) in
            XCTAssertEqual(currentQueue, OperationQueue.current, "Should be returned on the celler thread")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    //MARK: Deletion
    
    func test_deleteData_deletesSavedFile() {
        FileManager.saveData(data: self.dataToBeSaved, absolutePath: self.absolutePath)
        
        FileManager.deleteData(absolutePath: self.absolutePath)
        
        let fileExists = FileManager.fileExists(absolutePath:  self.absolutePath)
        
        XCTAssertFalse(fileExists, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
    
    func test_deleteData_deletesSavedFileReturnValue() {
        FileManager.saveData(data: self.dataToBeSaved, absolutePath: self.absolutePath)
        
        let deleted = FileManager.deleteData(absolutePath: self.absolutePath)
        
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
        FileManager.saveData(data: self.dataToBeSaved, absolutePath: self.absolutePathWithAdditionalDirectory)
        
        FileManager.deleteData(absolutePath: self.absolutePathWithAdditionalDirectory)
        
        let fileExists = FileManager.deleteData(absolutePath: self.absolutePathWithAdditionalDirectory)
        
        XCTAssertFalse(fileExists, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
    
    //MARK: Move
    
    func test_moveFileFromSourcePath_fileMoved() {
        FileManager.moveFile(sourceAbsolutePath: self.absoluteSourcePath, destinationAbsolutePath: self.absoluteDestinationPath)
        
        let fileMoved = FileManager.fileExists(absolutePath:  self.absoluteDestinationPath)
        
        XCTAssertTrue(fileMoved, "File has not been moved")
    }
    
    func test_moveFileFromSourcePath_fileMovedWithSpaceInSourcePathFileName() {
        FileManager.moveFile(sourceAbsolutePath: self.absoluteSourcePathWithSpaceInFilename, destinationAbsolutePath: self.absoluteDestinationPath)
        
        let fileMoved = FileManager.fileExists(absolutePath:  self.absoluteDestinationPath)
        
        XCTAssertTrue(fileMoved, "File has not been moved")
    }
    
    func test_moveFileFromSourcePath_fileMovedWithSpaceInDestinationPathFileName() {
        FileManager.moveFile(sourceAbsolutePath: self.absoluteSourcePath, destinationAbsolutePath: self.absoluteDestinationPathWithSpaceInFilename)
        
        let fileMoved = FileManager.fileExists(absolutePath:  self.absoluteDestinationPathWithSpaceInFilename)
        
        XCTAssertTrue(fileMoved, "File has not been moved")
    }
    
    func test_moveFileFromSourcePath_trueReturnValueWhenFileMoved() {
        let fileMoved = FileManager.moveFile(sourceAbsolutePath: self.absoluteSourcePath, destinationAbsolutePath: self.absoluteDestinationPath)
        
        XCTAssertTrue(fileMoved, "File has not been moved")
    }

    func test_moveFileFromSourcePath_falseReturnValueWhenEmptySource() {
        let fileMoved = FileManager.moveFile(sourceAbsolutePath: "", destinationAbsolutePath: self.absoluteDestinationPath)
        
        XCTAssertFalse(fileMoved, "Source is empty so file shouldn't have been moved")
    }
    
    func test_moveFileFromSourcePath_falseReturnValueWhenEmptyDestination() {
        let fileMoved = FileManager.moveFile(sourceAbsolutePath: self.absoluteSourcePath, destinationAbsolutePath: "")
        
        XCTAssertFalse(fileMoved, "Destination is empty so file shouldn't have been moved")
    }
 
}
