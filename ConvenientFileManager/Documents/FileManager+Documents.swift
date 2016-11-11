//
//  FileManager+Documents.swift
//  ConvenientFileManager
//
//  Created by William Boles on 29/03/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

 /// A collection of helper functions for common operations in the documents directory.
public extension FileManager {

    //MARK: Documents
    
    /**
     Path of documents directory.
     
     - Returns: String instance.
     */
    @objc(cfm_documentsDirectoryPath)
    public class func documentsDirectoryPath() -> String {
        return (FileManager.documentsDirectoryURL().path)
    }
    
    /**
     URL of documents directory.
     
     - Returns: URL instance.
     */
    @objc(cfm_documentsDirectoryURL)
    public class func documentsDirectoryURL() -> URL {
        return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
    }
    
    /**
     Path of resource in documents directory.
     
     - Parameter relativePath: relative path that will be combined documents path.
     
     - Returns: Combined path.
     */
    @objc(cfm_documentsDirectoryPathForResourceWithRelativePath:)
    public class func documentsDirectoryPathForResource(relativePath: String) -> String {
        guard relativePath.characters.count > 0 else {
            return FileManager.documentsDirectoryPath()
        }
        
        let documentsDirectory = FileManager.documentsDirectoryURL()
        let absoluteURL = documentsDirectory.appendingPathComponent(relativePath)
        
        return absoluteURL.path
    }
    
    //MARK: Saving
    
    /**
     Save data to path in documents directory.
     
     - Parameter data: data to be saved.
     - Parameter relativePath: relative path that will be combined documents path.
     
     - Returns: Bool if save was successful.
     */
    @objc(cfm_saveData:toDocumentsDirectoryRelativePath:)
    @discardableResult
    public class func saveDataToDocumentsDirectory(data: Data, relativePath: String) -> Bool {
        guard relativePath.characters.count > 0 && data.count > 0 else {
            return false
        }
        
        let documentsDirectory = FileManager.documentsDirectoryURL()
        let absolutePath = documentsDirectory.appendingPathComponent(relativePath).path
        
        return FileManager.saveData(data: data, absolutePath: absolutePath)
    }
    
    //MARK: Retrieval
    
    /**
     Retrieve data to path in documents directory.
     
     - Parameter relativePath: relative path that will be combined documents path.
     
     - Returns: NSData that was retrieved or nil if it's not found.
     */
    @objc(cfm_retrieveDataFromDocumentsDirectoryWithRelativePath:)
    public class func retrieveDataFromDocumentsDirectory(relativePath: String) -> Data? {
        guard relativePath.characters.count > 0 else {
            return nil
        }
        
        let documentsDirectory = FileManager.documentsDirectoryURL()
        let absolutePath = documentsDirectory.appendingPathComponent(relativePath).path
        
        return FileManager.retrieveData(absolutePath: absolutePath)
    }
    
    //MARK: Exists
    
    /**
     Determines if a file exists at path in the documents directory
     
     - Parameter relativePath: relative path that will be combined documents path.
     
     - Returns: Bool - true if file exists, false if file doesn't exist.
     */
    @objc(cfm_fileExistsInDocumentsDirectoryWithRelativePath:)
    public class func fileExistsInDocumentsDirectory(relativePath: String) -> Bool {
        guard relativePath.characters.count > 0 else {
            return false
        }
        
        let documentsDirectory = FileManager.documentsDirectoryURL()
        let absolutePath = documentsDirectory.appendingPathComponent(relativePath).path
        
        return FileManager.fileExists(absolutePath: absolutePath)
    }
    
    //MARK: Deletion
    
    /**
     Delete data from path in documents directory.
     
     - Parameter relativePath: relative path that will be combined documents path.
     
     - Returns: Bool - true if deletion was successful, false otherwise.
     */
    @objc(cfm_deleteDataFromDocumentsDirectoryWithRelativePath:)
    @discardableResult
    public class func deleteDataFromDocumentsDirectory(relativePath: String) -> Bool {
        guard relativePath.characters.count > 0 else {
            return false
        }
        
        let documentsDirectory = FileManager.documentsDirectoryURL()
        let absolutePath = documentsDirectory.appendingPathComponent(relativePath).path
        
        return FileManager.deleteData(absolutePath: absolutePath)
    }
}
