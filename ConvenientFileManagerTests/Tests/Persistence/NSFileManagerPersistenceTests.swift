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
    
    var dataToBeSaved: NSData = {
        let dataToSaved = "Test string to be converted into data".dataUsingEncoding(NSUTF8StringEncoding)
        
        return dataToSaved!
    }()
    
    var emptyData: NSData = {
        let emptyData = "".dataUsingEncoding(NSUTF8StringEncoding)
        
        return emptyData!
    }()
    
    var testFolder: String = {
        let testFolder = "test"
        
        return testFolder
    }()
    
    lazy var absolutePath: String = {
        let absolutePath = NSFileManager.documentsDirectoryPathForResourceWithPath("test.mp4")
        
        return absolutePath
    }()
    
    lazy var absolutePathWithSpaceInFilename: String = {
        let absolutePathWithSpaceInFilename = NSFileManager.documentsDirectoryPathForResourceWithPath("test 98.mp4")
        
        return absolutePathWithSpaceInFilename
    }()
    
    lazy var absolutePathWithAdditionalDirectory: String = {
        let absolutePathWithAdditionalDirectory = NSFileManager.cacheDirectoryPathForResourceWithPath("\(self.testFolder)/test/test.mp4")
        
        return absolutePathWithAdditionalDirectory
    }()
    
    lazy var absolutePathWithoutFile: String = {
        let absolutePathWithoutFile = NSFileManager.cacheDirectoryPathForResourceWithPath("\(self.testFolder)/testcache")
        
        return absolutePathWithoutFile
    }()
    
    lazy var absoluteSourcePath: String = {
        let absoluteSourcePath = NSFileManager.cacheDirectoryPathForResourceWithPath("\(self.testFolder)/source.png")
        
        return absoluteSourcePath
    }()
    
    lazy var absoluteSourcePathWithSpaceInFilename: String = {
        let absoluteSourcePathWithSpaceInFilename = NSFileManager.cacheDirectoryPathForResourceWithPath("\(self.testFolder)/source 98.png")
        
        return absoluteSourcePathWithSpaceInFilename
    }()
    
    lazy var absoluteDestinationPath: String = {
        let absoluteDestinationPath = NSFileManager.cacheDirectoryPathForResourceWithPath("\(self.testFolder)/destination.png")
        
        return absoluteDestinationPath
    }()
    
    lazy var absoluteDestinationPathWithSpaceInFilename: String = {
        let absoluteDestinationPathWithSpaceInFilename = NSFileManager.cacheDirectoryPathForResourceWithPath("\(self.testFolder)/destination 879.png")
        
        return absoluteDestinationPathWithSpaceInFilename
    }()
    
    //MARK: TestSuiteLifecycle
    
    override func setUp() {
        super.setUp()
        
        NSFileManager.saveData(self.dataToBeSaved, absolutePath: self.absoluteSourcePath)
        NSFileManager.saveData(self.dataToBeSaved, absolutePath: self.absoluteSourcePathWithSpaceInFilename)
    }
    
    override func tearDown() {
        
        if NSFileManager.fileExistsAtPath(self.absolutePath) {
           NSFileManager.deleteDataAtPath(self.absolutePath)
        }
        
        if NSFileManager.fileExistsAtPath(self.absolutePathWithSpaceInFilename) {
            NSFileManager.deleteDataAtPath(self.absolutePathWithSpaceInFilename)
        }
        
        if NSFileManager.fileExistsAtPath(self.absolutePathWithAdditionalDirectory) {
            NSFileManager.deleteDataAtPath(self.absolutePathWithAdditionalDirectory)
        }
        
        if NSFileManager.fileExistsAtPath(self.absolutePathWithoutFile) {
            NSFileManager.deleteDataAtPath(self.absolutePathWithoutFile)
        }
        
        if NSFileManager.fileExistsAtPath(self.absoluteDestinationPath) {
            NSFileManager.deleteDataAtPath(self.absoluteDestinationPath)
        }
        
        if NSFileManager.fileExistsAtPath(self.absoluteSourcePath) {
            NSFileManager.deleteDataAtPath(self.absoluteSourcePath)
        }
        
        if NSFileManager.fileExistsAtPath(self.absoluteDestinationPathWithSpaceInFilename) {
            NSFileManager.deleteDataAtPath(self.absoluteDestinationPathWithSpaceInFilename)
        }
        
        if NSFileManager.fileExistsAtPath(self.absoluteSourcePathWithSpaceInFilename) {
            NSFileManager.deleteDataAtPath(self.absoluteSourcePathWithSpaceInFilename)
        }
        
        let documentsTestFolder = NSFileManager.documentsDirectoryPathForResourceWithPath(self.testFolder)
        
        if NSFileManager.fileExistsAtPath(documentsTestFolder) {
            NSFileManager.deleteDataAtPath(documentsTestFolder)
        }
        
        let cacheTestFolder = NSFileManager.cacheDirectoryPathForResourceWithPath(self.testFolder)
        
        if NSFileManager.fileExistsAtPath(cacheTestFolder) {
            NSFileManager.deleteDataAtPath(cacheTestFolder)
        }
        
        super.tearDown()
    }

    //MARK: URL
    
    func test_fileURLForPath_url() {
        let expectedURL = NSURL(fileURLWithPath: self.absolutePath)
        let returnedURL = NSFileManager.fileURLForPath(self.absolutePath)
        
        XCTAssertEqual(returnedURL, expectedURL, "URLs returned do not match: \(returnedURL) and \(expectedURL)")
    }
    
    //MARK Saving
    
    func test_saveData_fileOnDisk() {
        NSFileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePath)
        
        let dataThatWasSaved = NSFileManager.retrieveDataAtPath(self.absolutePath)
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasSaved)")
    }
    
    func test_saveData_fileOnDiskWithSpaceInFilename() {
        NSFileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePathWithSpaceInFilename)
        
        let dataThatWasSaved = NSFileManager.retrieveDataAtPath(self.absolutePathWithSpaceInFilename)
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasSaved)")
    }
    
    func test_saveData_successfulSaveReturnValue() {
        let saved = NSFileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePath)
        
        XCTAssertTrue(saved, "Successful save of data should return TRUE")
    }
    
    func test_saveData_failedSaveEmptyDataReturnValue() {
        let saved = NSFileManager.saveData(self.emptyData, absolutePath: self.absolutePath)
        
        XCTAssertFalse(saved, "Failed save of data should return FALSE")
    }

    func test_saveData_failedSaveEmptyPathReturnValue() {
        let saved = NSFileManager.saveData(self.dataToBeSaved, absolutePath: "")
        
        XCTAssertFalse(saved, "Failed save of data should return FALSE")
    }
    
    func test_saveData_fileOnDiskWithDirectoryCreation() {
        NSFileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePathWithAdditionalDirectory)
        
        let dataThatWasSaved = NSFileManager.retrieveDataAtPath(self.absolutePathWithAdditionalDirectory)
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasSaved)")
    }
    
    //MARK: Directory
    
    func test_createDirectoryAtPath_directoryCreatedWithFile() {
        NSFileManager.createDirectoryAtPath(self.absolutePathWithAdditionalDirectory)
        
        let fileExists = NSFileManager.fileExistsAtPath(self.absolutePathWithAdditionalDirectory)
        
        XCTAssertTrue(fileExists, "File should exist within a custom directory")
    }
    
    func test_createDirectoryAtPath_directoryCreatedWithoutFile() {
        NSFileManager.createDirectoryAtPath(self.absolutePathWithoutFile)
        
        let fileExists = NSFileManager.fileExistsAtPath(self.absolutePathWithoutFile)
        
        XCTAssertTrue(fileExists, "Directory should be created")
    }
    
    func test_createDirectoryAtPath_returnValue() {
        let directoryCreated = NSFileManager.createDirectoryAtPath(self.absolutePathWithAdditionalDirectory)
        
        XCTAssertTrue(directoryCreated, "TRUE should be returned when custom directory is created")
    }
    
    func test_createDirectoryAtPath_failedCreationNilPathReturnValue() {
        let directoryCreated = NSFileManager.createDirectoryAtPath("")
        
        XCTAssertFalse(directoryCreated, "FALSE should be returned when not path is provided")
    }

    //MARK: FileExists
    
    func test_fileExistsAtPath_trueReturnValue() {
        NSFileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePath)
        
        let fileExists = NSFileManager.fileExistsAtPath(self.absolutePath)
        
        XCTAssertTrue(fileExists, "File does exist and should be returned as TRUE")
    }
    
    func test_fileExistsAtPath_trueReturnValueWithSpaceInFilename() {
        NSFileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePathWithoutFile)
        
        let fileExists = NSFileManager.fileExistsAtPath(self.absolutePathWithoutFile)
        
        XCTAssertTrue(fileExists, "File does exist and should be returned as TRUE")
    }

    func test_fileExistsAtPath_falseReturnValueForFileThatDoesNotExist() {
        let resourceThatDoesNotExist = "unknown.jpg"
        
        let fileExists = NSFileManager.fileExistsAtPath(resourceThatDoesNotExist)
        
        XCTAssertFalse(fileExists, "File does not exist and should be returned as FALSE")
    }
    
    func test_fileExistsAtPath_falseReturnValueForEmptyParameter() {
        let fileExists = NSFileManager.fileExistsAtPath("")
        
        XCTAssertFalse(fileExists, "Empty parameter and should be returned as FALSE")
    }
    
    //MARK FileExistsAsync
    
    func test_fileExistsAtPathAsync_trueReturnValue() {
        NSFileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePath)
        
        let expectation = self.expectationWithDescription("Handler called")
        
        NSFileManager.fileExistsAtPath(self.absolutePath) { (fileExists) in
            XCTAssertTrue(fileExists, "File does exist and should be returned as TRUE")
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(1.0, handler: nil)
    }

    func test_fileExistsAtPathAsync_falseReturnValueForFileThatDoesNotExist() {
        let resourceThatDoesNotExist = "unknown.jpg"
        
        let expectation = self.expectationWithDescription("Handler called")
        
        NSFileManager.fileExistsAtPath(resourceThatDoesNotExist) { (fileExists) in
            XCTAssertFalse(fileExists, "File does not exist and should be returned as FALSE")
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(1.0, handler: nil)
    }
    
    func test_fileExistsAtPathAsync_falseReturnValueForEmptyParameter() {
        let expectation = self.expectationWithDescription("Handler called")
        
        NSFileManager.fileExistsAtPath("") { (fileExists) in
            XCTAssertFalse(fileExists, "Empty parameter and should be returned as FALSE")
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(1.0, handler: nil)
    }
    
    func test_fileExistsAtPathAsync_returnedOnCallerThread() {
        NSFileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePath)
        
        let expectation = self.expectationWithDescription("Handler called")
        
        let currentQueue = NSOperationQueue.currentQueue()
        
        NSFileManager.fileExistsAtPath(self.absolutePath) { (fileExists) in
            XCTAssertEqual(currentQueue, NSOperationQueue.currentQueue(), "Should be returned on the celler thread")
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(1.0, handler: nil)
    }
    
    //MARK: Deletion
    
    func test_deleteDataFromDocumentsDirectoryWithPath_deletesSavedFile() {
        NSFileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePath)
        
        NSFileManager.deleteDataAtPath(self.absolutePath)
        
        let fileExists = NSFileManager.fileExistsAtPath(self.absolutePath)
        
        XCTAssertFalse(fileExists, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
    
    func test_deleteDataFromDocumentsDirectoryWithPath_deletesSavedFileReturnValue() {
        NSFileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePath)
        
        let deleted = NSFileManager.deleteDataAtPath(self.absolutePath)
        
        XCTAssertTrue(deleted, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
    
    func test_deleteDataFromDocumentsDirectoryWithPath_falseReturnValueForFileThatDoesNotExist() {
        let resourceThatDoesNotExist = "unknown.jpg"
        
        let deleted = NSFileManager.deleteDataAtPath(resourceThatDoesNotExist)
        
        XCTAssertFalse(deleted, "Deletion should return FALSE as the resource does not exist")
    }
    
    func test_deleteDataFromDocumentsDirectoryWithPath_falseReturnValueForEmptyParameter() {
        let deleted = NSFileManager.deleteDataAtPath("")
        
        XCTAssertFalse(deleted, "Deletion should return FALSE as the resource is nil")
    }
    
    func test_deleteDataFromDocumentsDirectoryWithPath_deletesSavedFileWithFolder() {
        NSFileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePathWithAdditionalDirectory)
        
        NSFileManager.deleteDataAtPath(self.absolutePathWithAdditionalDirectory)
        
        let fileExists = NSFileManager.deleteDataAtPath(self.absolutePathWithAdditionalDirectory)
        
        XCTAssertFalse(fileExists, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
    
    //MARK: Move
    
    func test_moveFileFromSourcePath_fileMoved() {
        NSFileManager.moveFile(self.absoluteSourcePath, destinationAbsolutePath: self.absoluteDestinationPath)
        
        let fileMoved = NSFileManager.fileExistsAtPath(self.absoluteDestinationPath)
        
        XCTAssertTrue(fileMoved, "File has not been moved")
    }
    
    func test_moveFileFromSourcePath_fileMovedWithSpaceInSourcePathFileName() {
        NSFileManager.moveFile(self.absoluteSourcePathWithSpaceInFilename, destinationAbsolutePath: self.absoluteDestinationPath)
        
        let fileMoved = NSFileManager.fileExistsAtPath(self.absoluteDestinationPath)
        
        XCTAssertTrue(fileMoved, "File has not been moved")
    }
    
    func test_moveFileFromSourcePath_fileMovedWithSpaceInDestinationPathFileName() {
        NSFileManager.moveFile(self.absoluteSourcePath, destinationAbsolutePath: self.absoluteDestinationPathWithSpaceInFilename)
        
        let fileMoved = NSFileManager.fileExistsAtPath(self.absoluteDestinationPathWithSpaceInFilename)
        
        XCTAssertTrue(fileMoved, "File has not been moved")
    }
    
    func test_moveFileFromSourcePath_trueReturnValueWhenFileMoved() {
        let fileMoved = NSFileManager.moveFile(self.absoluteSourcePath, destinationAbsolutePath: self.absoluteDestinationPath)
        
        XCTAssertTrue(fileMoved, "File has not been moved")
    }

    func test_moveFileFromSourcePath_falseReturnValueWhenEmptySource() {
        let fileMoved = NSFileManager.moveFile("", destinationAbsolutePath: self.absoluteDestinationPath)
        
        XCTAssertFalse(fileMoved, "Source is empty so file shouldn't have been moved")
    }
    
    func test_moveFileFromSourcePath_falseReturnValueWhenEmptyDestination() {
        let fileMoved = NSFileManager.moveFile(self.absoluteSourcePath, destinationAbsolutePath: "")
        
        XCTAssertFalse(fileMoved, "Destination is empty so file shouldn't have been moved")
    }
 
}
