//
//  File.swift
//  ConvenientFileManager
//
//  Created by William Boles on 29/03/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

/// A collection of helper functions for common operations when dealing with the file manager.
public extension NSFileManager {
    
    //MARK: Retrieving
    
    /**
     Retrieve data to path in document directory.
     
     - Parameter absolutePath: absolute path that will be used to retrieve the data that it's location.
     
     - Returns: NSData that was retrieved or nil.
     */
    @objc(cfm_retrieveDataAtPath:)
    public class func retrieveDataAtPath(absolutePath: String) -> NSData? {
        var data: NSData?
        
        if absolutePath.characters.count > 0 {
            data = NSData(contentsOfFile: absolutePath)
        }
        
        return data
    }
    
    //MARK: Saving
    
    /**
     Save data to path on filesystem.
     
     If the directory doesn't exist it will be created.
     
     - Parameter data: data to be saved.
     - Parameter absolutePath: absolute path that the data will be saved to.
     
     - Returns: BOOL if save was successful.
     */
    @objc(cfm_saveData:toPath:)
    public class func saveData(data: NSData, absolutePath: String) -> Bool {
        var success = true
        
        if data.length > 0 && absolutePath.characters.count > 0 {
            let absoluteURL = self.fileURLForPath(absolutePath)

            if let directoryPath = absoluteURL.URLByDeletingLastPathComponent?.path {
                 var createdDirectory = true
                
                if !NSFileManager.defaultManager().fileExistsAtPath(directoryPath) {
                    createdDirectory = NSFileManager.createDirectoryAtPath(directoryPath)
                }
                
                if createdDirectory {
                    do {
                        try data.writeToURL(absoluteURL, options: NSDataWritingOptions.DataWritingAtomic)
                    } catch let error as NSError {
                        success = false
                        print("Error when saving data at location: \(absolutePath). The error was: \(error.description)")
                    }
                } else {
                    success = false
                }
            } else {
                success = false
            }
        } else {
            success = false
        }
        
        return success
    }
    
    /**
     Creates directory on filesystem.
     
     If the directory doesn't exist it will be created.
     
     - Parameter absolutePath: absolute path/directory-structure that will be created.
     
     - Returns: Bool - true if creation was successful, false otherwise.
     */
    @objc(cfm_createDirectoryAtPath:)
    public class func createDirectoryAtPath(absoluteDirectoryPath: String) -> Bool {
        var createdDirectory = true
        
        if absoluteDirectoryPath.characters.count > 0 {
            let absoluteDirectoryURL = self.fileURLForPath(absoluteDirectoryPath)
            
            do {
                try NSFileManager.defaultManager().createDirectoryAtURL(absoluteDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                createdDirectory = false
                print("Error when creating a directory at location: \(absoluteDirectoryPath). The error was: \(error.description)")
            }
        } else {
            createdDirectory = false
        }
        
        return createdDirectory
    }
    
    //MARK: Exists
    
    /**
     Determines if a file exists at path.
     
     - Parameter absolutePath: absolute path to the file.
     
     - Returns: Bool - YES if file exists, NO if file doesn't exist.
     */
    @objc(cfm_fileExistsAtPath:)
    public class func fileExistsAtPath(absolutePath: String) -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(absolutePath)
    }
   
    /**
     Determines asynchronously  if a file exists at path.
     
     - Parameter absolutePath: absolute path to the file.
     - Parameter completion: a block that will be executed upon determining if a file exists or not.
     */
    @objc(cfm_fileExistsAtPath:completion:)
    public class func fileExistsAtPath(absolutePath: String, completion:((fileExists: Bool) -> Void)?) {
        //Used to return the call on the same thread
        let callBackQueue = NSOperationQueue.currentQueue()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let fileExists = NSFileManager.fileExistsAtPath(absolutePath)
            
            callBackQueue?.addOperationWithBlock({
                if completion != nil {
                    completion!(fileExists: fileExists)
                }
            })
        }
    }
    
    //MARK: Deletion
    
    /**
     Delete data from path.
     
     - Parameter absolutePath: absolute path to the file.
     
     - Returns: Bool - true if deletion was successful, false otherwise.
     */
    @objc(cfm_deleteDataAtPath:)
    public class func deleteDataAtPath(absolutePath: String) -> Bool {
        var deleted = true
        
        if absolutePath.characters.count > 0 {
            let absoluteURL = self.fileURLForPath(absolutePath)
            
            do {
                try NSFileManager.defaultManager().removeItemAtURL(absoluteURL)
            } catch let error as NSError {
                deleted = false
                print("Error when deleting data at location: \(absolutePath). The error was: \(error.description)")
            }
        } else {
            deleted = false
        }
        
        return deleted
    }
    
    //MARK: URL
    
    /**
     URL of resource in directory.
     
     - Parameter absolutePath: absolute path that will be combined cache path.
     
     - Returns: Combined URL.
     */
    @objc(cfm_fileURLForPath:)
    public class func fileURLForPath(absolutePath: String) -> NSURL {
        return NSURL(fileURLWithPath: absolutePath)
    }
    
    //MARK: Move
    
    /**
     Moves a file from a source location to a destination location.
     
     - Parameter sourceAbsolutePath: current absolute path of file to be moved.
     - Parameter destinationAbsolutePath: future absolute path that file will be moved to.
     
     - Returns: Bool - true if move was successful, false otherwise.
     */
    @objc(cfm_moveFileFromSourcePath:toDestinationPath:)
    public class func moveFile(sourceAbsolutePath: String, destinationAbsolutePath: String) -> Bool {
        var moved = true
        
        if sourceAbsolutePath.characters.count > 0 && destinationAbsolutePath.characters.count > 0 {
            let destinationAbsoluteURL = self.fileURLForPath(destinationAbsolutePath)
            
            if let destinationAbsoluteDirectoryPath = destinationAbsoluteURL.URLByDeletingLastPathComponent?.path {
                
                var createdDirectory = true
                
                if  NSFileManager.defaultManager().fileExistsAtPath(destinationAbsoluteDirectoryPath) {
                    createdDirectory = NSFileManager.createDirectoryAtPath(destinationAbsoluteDirectoryPath)
                }
                
                if createdDirectory {
                    let sourceAbsoluteURL = self.fileURLForPath(sourceAbsolutePath)
                    
                    do {
                        try NSFileManager.defaultManager().moveItemAtURL(sourceAbsoluteURL, toURL: destinationAbsoluteURL)
                    } catch let error as NSError {
                        moved = false
                        print("Error when moving file from: \(sourceAbsolutePath) to \(destinationAbsolutePath). The error was: \(error.description)")
                    }
                } else {
                    moved = false
                }
            } else {
                moved = false
            }
        } else {
            moved = false
        }
        
        return moved
    }
}