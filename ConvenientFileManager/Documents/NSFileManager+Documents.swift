//
//  NSFileManager+Documents.swift
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
    @objc(cfm_documentsDirectoryPathForResourceWithPath:)
    public class func documentsDirectoryPathForResourceWithPath(_ relativePath: String) -> String {
        let documentsDirectoryPathForResource: String
        
        if relativePath.characters.count > 0 {
            let documentsDirectory = FileManager.documentsDirectoryURL()
            let absoluteURL = documentsDirectory.appendingPathComponent(relativePath)
            
            documentsDirectoryPathForResource = absoluteURL.path
        } else {
            documentsDirectoryPathForResource = FileManager.documentsDirectoryPath()
        }
        
        return documentsDirectoryPathForResource
    }
    
    //MARK: Saving
    
    /**
     Save data to path in documents directory.
     
     - Parameter data: data to be saved.
     - Parameter relativePath: relative path that will be combined documents path.
     
     - Returns: Bool if save was successful.
     */
    @objc(cfm_saveData:toDocumentsDirectoryPath:)
    public class func saveDataToDocumentsDirectory(_ data: Data, relativePath: String) -> Bool {
        var saved = false
        
        if relativePath.characters.count > 0 && data.count > 0{
            let documentsDirectory = FileManager.documentsDirectoryURL()
            let absolutePath = documentsDirectory.appendingPathComponent(relativePath).path
            
            saved = FileManager.saveData(data, absolutePath: absolutePath)
        }
        
        return saved
    }
    
    //MARK: Retrieval
    
    /**
     Retrieve data to path in documents directory.
     
     - Parameter relativePath: relative path that will be combined documents path.
     
     - Returns: NSData that was retrieved or nil if it's not found.
     */
    @objc(cfm_retrieveDataFromDocumentsDirectoryWithPath:)
    public class func retrieveDataFromDocumentsDirectory(_ relativePath: String) -> Data? {
        var data: Data?
        
        if relativePath.characters.count > 0 {
            let documentsDirectory = FileManager.documentsDirectoryURL()
            let absolutePath = documentsDirectory.appendingPathComponent(relativePath).path
            
            data = FileManager.retrieveDataAtPath(absolutePath)
        }
        
        return data
    }
    
    //MARK: Exists
    
    /**
     Determines if a file exists at path in the documents directory
     
     - Parameter relativePath: relative path that will be combined documents path.
     
     - Returns: Bool - true if file exists, false if file doesn't exist.
     */
    @objc(cfm_fileExistsInDocumentsDirectory:)
    public class func fileExistsInDocumentsDirectory(_ relativePath: String) -> Bool {
        var fileExists = false
        
        if relativePath.characters.count > 0 {
            let documentsDirectory = FileManager.documentsDirectoryURL()
            let absolutePath = documentsDirectory.appendingPathComponent(relativePath).path
            
            fileExists = FileManager.fileExistsAtPath(absolutePath)
        }
        
        return fileExists
    }
    
    //MARK: Deletion
    
    /**
     Delete data from path in documents directory.
     
     - Parameter relativePath: relative path that will be combined documents path.
     
     - Returns: Bool - true if deletion was successful, false otherwise.
     */
    @objc(cfm_deleteDataFromDocumentsDirectoryWithPath:)
    public class func deleteDataFromDocumentsDirectory(_ relativePath: String) -> Bool {
        var deleted = false
        
        if relativePath.characters.count > 0 {
            let documentsDirectory = FileManager.documentsDirectoryURL()
            let absolutePath = documentsDirectory.appendingPathComponent(relativePath).path
            
            deleted = FileManager.deleteDataAtPath(absolutePath)
        }
        
        return deleted
    }
}
