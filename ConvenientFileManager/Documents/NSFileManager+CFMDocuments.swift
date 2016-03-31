//
//  NSFileManager+Documents.swift
//  ConvenientFileManager
//
//  Created by William Boles on 29/03/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

/**
 A collection of helper functions for common operations in the documents directory.
 */
public extension NSFileManager {

    //MARK: Documents
    
    /**
     Path of documents directory.
     
     - returns: String instance.
     */
    @objc(cfm_documentsDirectoryPath)
    public class func documentsDirectoryPath() -> String {
        return (NSFileManager.documentsDirectoryURL().path)!
    }
    
    /**
     URL of documents directory.
     
     - returns: URL instance.
     */
    @objc(cfm_documentsDirectoryURL)
    public class func documentsDirectoryURL() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last!
    }
    
    /**
     Path of resource in documents directory.
     
     - parameter relativePath: relative path that will be combined documents path.
     
     - returns: Combined path.
     */
    @objc(cfm_documentsDirectoryPathForResourceWithPath:)
    public class func documentsDirectoryPathForResourceWithPath(relativePath: String) -> String {
        let documentsDirectoryPathForResource: String
        
        if relativePath.characters.count > 0 {
            let documentsDirectory = NSFileManager.documentsDirectoryURL()
            let absoluteURL = documentsDirectory.URLByAppendingPathComponent(relativePath)
            
            documentsDirectoryPathForResource = absoluteURL.path!
        } else {
            documentsDirectoryPathForResource = NSFileManager.documentsDirectoryPath()
        }
        
        return documentsDirectoryPathForResource
    }
    
    //MARK: Saving
    
    /**
     Save data to path in documents directory.
     
     - parameter data: data to be saved.
     - parameter relativePath: relative path that will be combined documents path.
     
     - returns: Bool if save was successful.
     */
    @objc(cfm_saveData:toDocumentsDirectoryPath:)
    public class func saveDataToDocumentsDirectory(data: NSData, relativePath: String) -> Bool{
        var saved = false
        
        if relativePath.characters.count > 0 && data.length > 0{
            let documentsDirectory = NSFileManager.documentsDirectoryURL()
            
            if let absolutePath = documentsDirectory.URLByAppendingPathComponent(relativePath).path {
                saved = NSFileManager.saveData(data, absolutePath: absolutePath)
            }
        }
        
        return saved
    }
    
    //MARK: Retrieval
    
    /**
     Retrieve data to path in documents directory.
     
     - parameter relativePath: relative path that will be combined documents path.
     
     - returns: NSData that was retrieved.
     */
    @objc(cfm_retrieveDataFromDocumentsDirectoryWithPath:)
    public class func retrieveDataFromDocumentsDirectory(relativePath: String) -> NSData? {
        var data: NSData?
        
        if relativePath.characters.count > 0 {
            let documentsDirectory = NSFileManager.documentsDirectoryURL()
            let absolutePath = documentsDirectory.URLByAppendingPathComponent(relativePath).path!
            
            data = NSFileManager.retrieveDataAtPath(absolutePath)
        }
        
        return data
    }
    
    //MARK: Exists
    
    /**
     Determines if a file exists at path in the documents directory
     
     - parameter relativePath: relative path that will be combined documents path.
     
     - returns: Bool - true if file exists, false if file doesn't exist.
     */
    @objc(cfm_fileExistsInDocumentsDirectory:)
    public class func fileExistsInDocumentsDirectory(relativePath: String) -> Bool {
        var fileExists = false
        
        if relativePath.characters.count > 0 {
            let documentsDirectory = NSFileManager.documentsDirectoryURL()
            let absolutePath = documentsDirectory.URLByAppendingPathComponent(relativePath).path!
            
            fileExists = NSFileManager.fileExistsAtPath(absolutePath)
        }
        
        return fileExists
    }
    
    //MARK: Deletion
    
    /**
     Delete data from path in documents directory.
     
     - parameter relativePath: relative path that will be combined documents path.
     
     - returns: Bool - true if deletion was successful, false otherwise.
     */
    @objc(cfm_deleteDataFromDocumentsDirectoryWithPath:)
    public class func deleteDataFromDocumentsDirectory(relativePath: String) -> Bool {
        var deleted = false
        
        if relativePath.characters.count > 0 {
            let documentsDirectory = NSFileManager.documentsDirectoryURL()
            let absolutePath = documentsDirectory.URLByAppendingPathComponent(relativePath).path!
            
            deleted = NSFileManager.deleteDataAtPath(absolutePath)
        }
        
        return deleted
    }
}