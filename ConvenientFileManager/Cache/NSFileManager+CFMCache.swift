//
//  NSFileManager+CFMCache.swift
//  ConvenientFileManager
//
//  Created by William Boles on 29/03/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

/**
 A collection of helper functions for common operations in the cache directory.
 */
public extension NSFileManager {
    
    //MARK: Cache
    
    /**
     Path of cache directory.
     
     - returns: String instance.
     */
    @objc(cfm_cacheDirectoryPath)
    public class func cacheDirectoryPath() -> String {
        return (NSFileManager.cacheDirectoryURL().path)!
    }
    
    /**
     URL of cache directory.
     
     - returns: URL instance.
     */
    @objc(cfm_cacheDirectoryURL)
    public class func cacheDirectoryURL() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.CachesDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last!
    }
    
    /**
     Path of resource in cache directory.
     
     - parameter relativePath: relative path that will be combined cache path.
     
     - returns: Combined path.
     */
    @objc(cfm_cacheDirectoryPathForResourceWithPath:)
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
    
    /**
     Save data to path in cache directory.
     
     - parameter data: data to be saved.
     - parameter relativePath: relative path that will be combined cache path.
     
     - returns: Bool if save was successful.
     */
    @objc(cfm_saveData:toCacheDirectoryPath:)
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
    
    /**
     Retrieve data to path in cache directory.
     
     - parameter relativePath: relative path that will be combined cache path.
     
     - returns: NSData that was retrieved.
     */
    @objc(cfm_retrieveDataFromCacheDirectoryWithPath:)
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
    
    /**
     Determines if a file exists at path in the cache directory
     
     - parameter relativePath: relative path that will be combined cache path.
     
     - returns: Bool - true if file exists, false if file doesn't exist.
     */
    @objc(cfm_fileExistsInCacheDirectory:)
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
    
    /**
     Delete data from path in cache directory.
     
     - parameter relativePath: relative path that will be combined cache path.
     
     - returns: Bool - true if deletion was successful, false otherwise.
     */
    @objc(cfm_deleteDataFromCacheDirectoryWithPath:)
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