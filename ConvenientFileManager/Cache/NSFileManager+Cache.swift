//
//  NSFileManager+CFMCache.swift
//  ConvenientFileManager
//
//  Created by William Boles on 29/03/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

 /// A collection of helper functions for common operations in the cache directory.
public extension FileManager {
    
    //MARK: Cache
    
    /**
     Path of cache directory.
     
     - Returns: String instance.
     */
    @objc(cfm_cacheDirectoryPath)
    public class func cacheDirectoryPath() -> String {
        return (FileManager.cacheDirectoryURL().path)
    }
    
    /**
     URL of cache directory.
     
     - Returns: URL instance.
     */
    @objc(cfm_cacheDirectoryURL)
    public class func cacheDirectoryURL() -> URL {
        return FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last!
    }
    
    /**
     Path of resource in cache directory.
     
     - Parameter relativePath: relative path that will be combined cache path.
     
     - Returns: Combined path.
     */
    @objc(cfm_cacheDirectoryPathForResourceWithPath:)
    public class func cacheDirectoryPathForResourceWithPath(_ relativePath: String) -> String {
        let cacheDirectoryPathForResource: String
        
        if relativePath.characters.count > 0 {
            let cacheDirectory = FileManager.cacheDirectoryURL()
            let absoluteURL = cacheDirectory.appendingPathComponent(relativePath)
            
            cacheDirectoryPathForResource = absoluteURL.path
        } else {
            cacheDirectoryPathForResource = FileManager.cacheDirectoryPath()
        }
        
        return cacheDirectoryPathForResource
    }
    
    //MARK: Saving
    
    /**
     Save data to path in cache directory.
     
     - Parameter data: data to be saved.
     - Parameter relativePath: relative path that will be combined cache path.
     
     - Returns: Bool if save was successful.
     */
    @objc(cfm_saveData:toCacheDirectoryPath:)
    @discardableResult
    public class func saveDataToCacheDirectory(_ data: Data, relativePath: String) -> Bool{
        var saved = false
        
        if relativePath.characters.count > 0 && data.count > 0 {
            let cacheDirectory = FileManager.cacheDirectoryURL()
            let absolutePath = cacheDirectory.appendingPathComponent(relativePath).path
            
            saved = FileManager.saveData(data, absolutePath: absolutePath)
        }
        
        return saved
    }
    
    //MARK: Retrieval
    
    /**
     Retrieve data to path in cache directory.
     
     - Parameter relativePath: relative path that will be combined cache path.
     
     - Returns: NSData that was retrieved.
     */
    @objc(cfm_retrieveDataFromCacheDirectoryWithPath:)
    public class func retrieveDataFromCacheDirectory(_ relativePath: String) -> Data? {
        var data: Data?
        
        if relativePath.characters.count > 0 {
            let cacheDirectory = FileManager.cacheDirectoryURL()
            
            let absolutePath = cacheDirectory.appendingPathComponent(relativePath).path
            
            data = FileManager.retrieveDataAtPath(absolutePath)
        }
        
        return data
    }
    
    //MARK: Exists
    
    /**
     Determines if a file exists at path in the cache directory
     
     - Parameter relativePath: relative path that will be combined cache path.
     
     - Returns: Bool - true if file exists, false if file doesn't exist.
     */
    @objc(cfm_fileExistsInCacheDirectory:)
    public class func fileExistsInCacheDirectory(_ relativePath: String) -> Bool {
        var fileExists = false
        
        if relativePath.characters.count > 0 {
            let cacheDirectory = FileManager.cacheDirectoryURL()
            
            let absolutePath = cacheDirectory.appendingPathComponent(relativePath).path
            
            fileExists = FileManager.fileExistsAtPath(absolutePath)
        }
        
        return fileExists
    }
    
    //MARK: Deletion 
    
    /**
     Delete data from path in cache directory.
     
     - Parameter relativePath: relative path that will be combined cache path.
     
     - Returns: Bool - true if deletion was successful, false otherwise.
     */
    @objc(cfm_deleteDataFromCacheDirectoryWithPath:)
    @discardableResult
    public class func deleteDataFromCacheDirectory(_ relativePath: String) -> Bool {
        var deleted = false
        
        if relativePath.characters.count > 0 {
            let cacheDirectory = FileManager.cacheDirectoryURL()
            
            let absolutePath = cacheDirectory.appendingPathComponent(relativePath).path
            
            deleted = FileManager.deleteDataAtPath(absolutePath)
        }
        
        return deleted
    }
}
