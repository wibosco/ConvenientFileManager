//
//  NSFileManager+CFMCache.swift
//  ConvenientFileManager
//
//  Created by William Boles on 29/03/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

public extension NSFileManager {
    
    //MARK: Cache
    
    public class func cacheDirectoryPath() -> String {
        return (NSFileManager.cacheDirectoryURL().path)!
    }
    
    public class func cacheDirectoryURL() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.CachesDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last!
    }
    
    public class func cacheDirectoryPathForResourceWithPath(relativePath: String) -> String {
        let cacheDirectoryPathForResource: String
        
        if relativePath.characters.count > 0 {
            let cacheDirectory = NSFileManager.cacheDirectoryURL()
            let absoluteURL = cacheDirectory.URLByAppendingPathComponent(relativePath)
            
            cacheDirectoryPathForResource = absoluteURL.path!
        } else {
            cacheDirectoryPathForResource = NSFileManager.cacheDirectoryPath()
        }
        
        return cacheDirectoryPathForResource
    }
    
    //MARK: Saving
    
    public class func saveDataToCacheDirectory(data: NSData, relativePath: String) -> Bool{
        var saved = false
        
        if relativePath.characters.count > 0 && data.length > 0 {
            let cacheDirectory = NSFileManager.cacheDirectoryURL()
            
            if let absolutePath = cacheDirectory.URLByAppendingPathComponent(relativePath).path {
                saved = NSFileManager.saveData(data, absolutePath: absolutePath)
            }
        }
        
        return saved
    }
    
    //MARK: Retrieval
    
    public class func retrieveDataFromCacheDirectory(relativePath: String) -> NSData? {
        var data: NSData?
        
        if relativePath.characters.count > 0 {
            let cacheDirectory = NSFileManager.cacheDirectoryURL()
            
            let absolutePath = cacheDirectory.URLByAppendingPathComponent(relativePath).path!
            
            data = NSFileManager.retrieveDataAtPath(absolutePath)
        }
        
        return data
    }
    
    //MARK: Exists
    
    public class func fileExistsInCacheDirectory(relativePath: String) -> Bool {
        var fileExists = false
        
        if relativePath.characters.count > 0 {
            let cacheDirectory = NSFileManager.cacheDirectoryURL()
            
            let absolutePath = cacheDirectory.URLByAppendingPathComponent(relativePath).path!
            
            fileExists = NSFileManager.fileExistsAtPath(absolutePath)
        }
        
        return fileExists
    }
    
    //MARK: Deletion 
    
    public class func deleteDataFromCacheDirectory(relativePath: String) -> Bool {
        var deleted = false
        
        if relativePath.characters.count > 0 {
            let cacheDirectory = NSFileManager.cacheDirectoryURL()
            
            let absolutePath = cacheDirectory.URLByAppendingPathComponent(relativePath).path!
            
            deleted = NSFileManager.deleteDataAtPath(absolutePath)
        }
        
        return deleted
    }
}