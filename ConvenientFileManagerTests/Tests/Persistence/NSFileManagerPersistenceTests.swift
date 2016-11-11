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
        let absolutePath = FileManager.documentsDirectoryPathForResourceWithPath("test.mp4")
        
        return absolutePath
    }()
    
    lazy var absolutePathWithSpaceInFilename: String = {
        let absolutePathWithSpaceInFilename = FileManager.documentsDirectoryPathForResourceWithPath("test 98.mp4")
        
        return absolutePathWithSpaceInFilename
    }()
    
    lazy var absolutePathWithAdditionalDirectory: String = {
        let absolutePathWithAdditionalDirectory = FileManager.cacheDirectoryPathForResourceWithPath("\(self.testFolder)/test/test.mp4")
        
        return absolutePathWithAdditionalDirectory
    }()
    
    lazy var absolutePathWithoutFile: String = {
        let absolutePathWithoutFile = FileManager.cacheDirectoryPathForResourceWithPath("\(self.testFolder)/testcache")
        
        return absolutePathWithoutFile
    }()
    
    lazy var absoluteSourcePath: String = {
        let absoluteSourcePath = FileManager.cacheDirectoryPathForResourceWithPath("\(self.testFolder)/source.png")
        
        return absoluteSourcePath
    }()
    
    lazy var absoluteSourcePathWithSpaceInFilename: String = {
        let absoluteSourcePathWithSpaceInFilename = FileManager.cacheDirectoryPathForResourceWithPath("\(self.testFolder)/source 98.png")
        
        return absoluteSourcePathWithSpaceInFilename
    }()
    
    lazy var absoluteDestinationPath: String = {
        let absoluteDestinationPath = FileManager.cacheDirectoryPathForResourceWithPath("\(self.testFolder)/destination.png")
        
        return absoluteDestinationPath
    }()
    
    lazy var absoluteDestinationPathWithSpaceInFilename: String = {
        let absoluteDestinationPathWithSpaceInFilename = FileManager.cacheDirectoryPathForResourceWithPath("\(self.testFolder)/destination 879.png")
        
        return absoluteDestinationPathWithSpaceInFilename
    }()
    
    //MARK: TestSuiteLifecycle
    
    override func setUp() {
        super.setUp()
        
        FileManager.saveData(self.dataToBeSaved, absolutePath: self.absoluteSourcePath)
        FileManager.saveData(self.dataToBeSaved, absolutePath: self.absoluteSourcePathWithSpaceInFilename)
    }
    
    override func tearDown() {
        
        if FileManager.fileExistsAtPath(self.absolutePath) {
           FileManager.deleteDataAtPath(self.absolutePath)
        }
        
        if FileManager.fileExistsAtPath(self.absolutePathWithSpaceInFilename) {
            FileManager.deleteDataAtPath(self.absolutePathWithSpaceInFilename)
        }
        
        if FileManager.fileExistsAtPath(self.absolutePathWithAdditionalDirectory) {
            FileManager.deleteDataAtPath(self.absolutePathWithAdditionalDirectory)
        }
        
        if FileManager.fileExistsAtPath(self.absolutePathWithoutFile) {
            FileManager.deleteDataAtPath(self.absolutePathWithoutFile)
        }
        
        if FileManager.fileExistsAtPath(self.absoluteDestinationPath) {
            FileManager.deleteDataAtPath(self.absoluteDestinationPath)
        }
        
        if FileManager.fileExistsAtPath(self.absoluteSourcePath) {
            FileManager.deleteDataAtPath(self.absoluteSourcePath)
        }
        
        if FileManager.fileExistsAtPath(self.absoluteDestinationPathWithSpaceInFilename) {
            FileManager.deleteDataAtPath(self.absoluteDestinationPathWithSpaceInFilename)
        }
        
        if FileManager.fileExistsAtPath(self.absoluteSourcePathWithSpaceInFilename) {
            FileManager.deleteDataAtPath(self.absoluteSourcePathWithSpaceInFilename)
        }
        
        let documentsTestFolder = FileManager.documentsDirectoryPathForResourceWithPath(self.testFolder)
        
        if FileManager.fileExistsAtPath(documentsTestFolder) {
            FileManager.deleteDataAtPath(documentsTestFolder)
        }
        
        let cacheTestFolder = FileManager.cacheDirectoryPathForResourceWithPath(self.testFolder)
        
        if FileManager.fileExistsAtPath(cacheTestFolder) {
            FileManager.deleteDataAtPath(cacheTestFolder)
        }
        
        super.tearDown()
    }

    //MARK: URL
    
    func test_fileURLForPath_url() {
        let expectedURL = URL(fileURLWithPath: self.absolutePath)
        let returnedURL = FileManager.fileURLForPath(self.absolutePath)
        
        XCTAssertEqual(returnedURL, expectedURL, "URLs returned do not match: \(returnedURL) and \(expectedURL)")
    }
    
    //MARK Saving
    
    func test_saveData_fileOnDisk() {
        FileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePath)
        
        let dataThatWasSaved = FileManager.retrieveDataAtPath(self.absolutePath)
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasSaved)")
    }
    
    func test_saveData_fileOnDiskWithSpaceInFilename() {
        FileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePathWithSpaceInFilename)
        
        let dataThatWasSaved = FileManager.retrieveDataAtPath(self.absolutePathWithSpaceInFilename)
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasSaved)")
    }
    
    func test_saveData_successfulSaveReturnValue() {
        let saved = FileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePath)
        
        XCTAssertTrue(saved, "Successful save of data should return TRUE")
    }
    
    func test_saveData_failedSaveEmptyDataReturnValue() {
        let saved = FileManager.saveData(self.emptyData, absolutePath: self.absolutePath)
        
        XCTAssertFalse(saved, "Failed save of data should return FALSE")
    }

    func test_saveData_failedSaveEmptyPathReturnValue() {
        let saved = FileManager.saveData(self.dataToBeSaved, absolutePath: "")
        
        XCTAssertFalse(saved, "Failed save of data should return FALSE")
    }
    
    func test_saveData_fileOnDiskWithDirectoryCreation() {
        FileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePathWithAdditionalDirectory)
        
        let dataThatWasSaved = FileManager.retrieveDataAtPath(self.absolutePathWithAdditionalDirectory)
        
        XCTAssertEqual(self.dataToBeSaved, dataThatWasSaved, "Data returned do not match: \(self.dataToBeSaved) and \(dataThatWasSaved)")
    }
    
    //MARK: Directory
    
    func test_createDirectoryAtPath_directoryCreatedWithFile() {
        FileManager.createDirectoryAtPath(self.absolutePathWithAdditionalDirectory)
        
        let fileExists = FileManager.fileExistsAtPath( self.absolutePathWithAdditionalDirectory)
        
        XCTAssertTrue(fileExists, "File should exist within a custom directory")
    }
    
    func test_createDirectoryAtPath_directoryCreatedWithoutFile() {
        FileManager.createDirectoryAtPath(self.absolutePathWithoutFile)
        
        let fileExists = FileManager.fileExistsAtPath( self.absolutePathWithoutFile)
        
        XCTAssertTrue(fileExists, "Directory should be created")
    }
    
    func test_createDirectoryAtPath_returnValue() {
        let directoryCreated = FileManager.createDirectoryAtPath(self.absolutePathWithAdditionalDirectory)
        
        XCTAssertTrue(directoryCreated, "TRUE should be returned when custom directory is created")
    }
    
    func test_createDirectoryAtPath_failedCreationNilPathReturnValue() {
        let directoryCreated = FileManager.createDirectoryAtPath("")
        
        XCTAssertFalse(directoryCreated, "FALSE should be returned when not path is provided")
    }

    //MARK: FileExists
    
    func test_fileExistsAtPath_trueReturnValue() {
        FileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePath)
        
        let fileExists = FileManager.fileExistsAtPath( self.absolutePath)
        
        XCTAssertTrue(fileExists, "File does exist and should be returned as TRUE")
    }
    
    func test_fileExistsAtPath_trueReturnValueWithSpaceInFilename() {
        FileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePathWithoutFile)
        
        let fileExists = FileManager.fileExistsAtPath( self.absolutePathWithoutFile)
        
        XCTAssertTrue(fileExists, "File does exist and should be returned as TRUE")
    }

    func test_fileExistsAtPath_falseReturnValueForFileThatDoesNotExist() {
        let resourceThatDoesNotExist = "unknown.jpg"
        
        let fileExists = FileManager.fileExistsAtPath( resourceThatDoesNotExist)
        
        XCTAssertFalse(fileExists, "File does not exist and should be returned as FALSE")
    }
    
    func test_fileExistsAtPath_falseReturnValueForEmptyParameter() {
        let fileExists = FileManager.fileExistsAtPath( "")
        
        XCTAssertFalse(fileExists, "Empty parameter and should be returned as FALSE")
    }
    
    //MARK FileExistsAsync
    
    func test_fileExistsAtPathAsync_trueReturnValue() {
        FileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePath)
        
        let expectation = self.expectation(description: "Handler called")
        
        FileManager.fileExistsAtPath(self.absolutePath) { (fileExists) in
            XCTAssertTrue(fileExists, "File does exist and should be returned as TRUE")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }

    func test_fileExistsAtPathAsync_falseReturnValueForFileThatDoesNotExist() {
        let resourceThatDoesNotExist = "unknown.jpg"
        
        let expectation = self.expectation(description: "Handler called")
        
        FileManager.fileExistsAtPath(resourceThatDoesNotExist) { (fileExists) in
            XCTAssertFalse(fileExists, "File does not exist and should be returned as FALSE")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_fileExistsAtPathAsync_falseReturnValueForEmptyParameter() {
        let expectation = self.expectation(description: "Handler called")
        
        FileManager.fileExistsAtPath("") { (fileExists) in
            XCTAssertFalse(fileExists, "Empty parameter and should be returned as FALSE")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func test_fileExistsAtPathAsync_returnedOnCallerThread() {
        FileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePath)
        
        let expectation = self.expectation(description: "Handler called")
        
        let currentQueue = OperationQueue.current
        
        FileManager.fileExistsAtPath(self.absolutePath) { (fileExists) in
            XCTAssertEqual(currentQueue, OperationQueue.current, "Should be returned on the celler thread")
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    //MARK: Deletion
    
    func test_deleteDataFromDocumentsDirectoryWithPath_deletesSavedFile() {
        FileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePath)
        
        FileManager.deleteDataAtPath(self.absolutePath)
        
        let fileExists = FileManager.fileExistsAtPath( self.absolutePath)
        
        XCTAssertFalse(fileExists, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
    
    func test_deleteDataFromDocumentsDirectoryWithPath_deletesSavedFileReturnValue() {
        FileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePath)
        
        let deleted = FileManager.deleteDataAtPath(self.absolutePath)
        
        XCTAssertTrue(deleted, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
    
    func test_deleteDataFromDocumentsDirectoryWithPath_falseReturnValueForFileThatDoesNotExist() {
        let resourceThatDoesNotExist = "unknown.jpg"
        
        let deleted = FileManager.deleteDataAtPath(resourceThatDoesNotExist)
        
        XCTAssertFalse(deleted, "Deletion should return FALSE as the resource does not exist")
    }
    
    func test_deleteDataFromDocumentsDirectoryWithPath_falseReturnValueForEmptyParameter() {
        let deleted = FileManager.deleteDataAtPath("")
        
        XCTAssertFalse(deleted, "Deletion should return FALSE as the resource is nil")
    }
    
    func test_deleteDataFromDocumentsDirectoryWithPath_deletesSavedFileWithFolder() {
        FileManager.saveData(self.dataToBeSaved, absolutePath: self.absolutePathWithAdditionalDirectory)
        
        FileManager.deleteDataAtPath(self.absolutePathWithAdditionalDirectory)
        
        let fileExists = FileManager.deleteDataAtPath(self.absolutePathWithAdditionalDirectory)
        
        XCTAssertFalse(fileExists, "File should not exist as file should have been deleted, this call should be returned as FALSE")
    }
    
    //MARK: Move
    
    func test_moveFileFromSourcePath_fileMoved() {
        FileManager.moveFile(self.absoluteSourcePath, destinationAbsolutePath: self.absoluteDestinationPath)
        
        let fileMoved = FileManager.fileExistsAtPath( self.absoluteDestinationPath)
        
        XCTAssertTrue(fileMoved, "File has not been moved")
    }
    
    func test_moveFileFromSourcePath_fileMovedWithSpaceInSourcePathFileName() {
        FileManager.moveFile(self.absoluteSourcePathWithSpaceInFilename, destinationAbsolutePath: self.absoluteDestinationPath)
        
        let fileMoved = FileManager.fileExistsAtPath( self.absoluteDestinationPath)
        
        XCTAssertTrue(fileMoved, "File has not been moved")
    }
    
    func test_moveFileFromSourcePath_fileMovedWithSpaceInDestinationPathFileName() {
        FileManager.moveFile(self.absoluteSourcePath, destinationAbsolutePath: self.absoluteDestinationPathWithSpaceInFilename)
        
        let fileMoved = FileManager.fileExistsAtPath( self.absoluteDestinationPathWithSpaceInFilename)
        
        XCTAssertTrue(fileMoved, "File has not been moved")
    }
    
    func test_moveFileFromSourcePath_trueReturnValueWhenFileMoved() {
        let fileMoved = FileManager.moveFile(self.absoluteSourcePath, destinationAbsolutePath: self.absoluteDestinationPath)
        
        XCTAssertTrue(fileMoved, "File has not been moved")
    }

    func test_moveFileFromSourcePath_falseReturnValueWhenEmptySource() {
        let fileMoved = FileManager.moveFile("", destinationAbsolutePath: self.absoluteDestinationPath)
        
        XCTAssertFalse(fileMoved, "Source is empty so file shouldn't have been moved")
    }
    
    func test_moveFileFromSourcePath_falseReturnValueWhenEmptyDestination() {
        let fileMoved = FileManager.moveFile(self.absoluteSourcePath, destinationAbsolutePath: "")
        
        XCTAssertFalse(fileMoved, "Destination is empty so file shouldn't have been moved")
    }
 
}
