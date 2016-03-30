//
//  NSFileManager+Documents.swift
//  ConvenientFileManager
//
//  Created by William Boles on 29/03/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

public extension NSFileManager {

    //MARK: Documents
    
    public class func documentsDirectoryPath() -> String {
        return (NSFileManager.documentsDirectoryURL().path)!
    }
    
    public class func documentsDirectoryURL() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last!
    }
    
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