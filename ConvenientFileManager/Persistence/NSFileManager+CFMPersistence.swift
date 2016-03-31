//
//  File.swift
//  ConvenientFileManager
//
//  Created by William Boles on 29/03/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

/**
 A collection of helper functions for common operations when dealing with the file manager.
 */
public extension NSFileManager {
    
    //MARK: Retrieving
    
    /**
     Retrieve data to path in document directory.
     
     - parameter absolutePath: absolute path that will be used to retrieve the data that it's location.
     
     - returns: NSData that was retrieved or nil.
     */
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
     
     - parameter data: data to be saved.
     - parameter absolutePath: absolute path that the data will be saved to.
     
     - returns: BOOL if save was successful.
     */
    public class func saveData(data: NSData, absolutePath: String) -> Bool {
        var success = true
        
        if data.length > 0 && absolutePath.characters.count > 0 {
            let absoluteURL = NSURL(string: absolutePath)

            if let directoryPath = absoluteURL?.URLByDeletingLastPathComponent?.path {
                 var createdDirectory = true
                
                if !NSFileManager.defaultManager().fileExistsAtPath(directoryPath) {
                    createdDirectory = NSFileManager.createDirectoryAtPath(directoryPath)
                }
                
                if createdDirectory {
                    do {
                        try data.writeToFile(absolutePath, options: NSDataWritingOptions.DataWritingAtomic)
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
     
     - parameter absolutePath: absolute path/directory-structure that will be created.
     
     - returns: Bool - true if creation was successful, false otherwise.
     */
    public class func createDirectoryAtPath(absoluteDirectoryPath: String) -> Bool {
        var createdDirectory = true
        
        if absoluteDirectoryPath.characters.count > 0 {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(absoluteDirectoryPath, withIntermediateDirectories: true, attributes: nil)
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
     
     - parameter absolutePath: absolute path to the file.
     
     - returns: Bool - YES if file exists, NO if file doesn't exist.
     */
    public class func fileExistsAtPath(absolutePath: String) -> Bool {
        return NSFileManager.defaultManager().fileExistsAtPath(absolutePath)
    }
   
    /**
     Determines asynchronously  if a file exists at path.
     
     - parameter absolutePath: absolute path to the file.
     - parameter completion: a block that will be executed upon determining if a file exists or not.
     */
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
     
     - parameter absolutePath: absolute path to the file.
     
     - returns: Bool - true if deletion was successful, false otherwise.
     */
    public class func deleteDataAtPath(absolutePath: String) -> Bool {
        var deleted = true
        
        if absolutePath.characters.count > 0 {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(absolutePath)
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
     
     - parameter absolutePath: absolute path that will be combined cache path.
     
     - returns: Combined URL.
     */
    public class func fileURLForPath(absolutePath: String) -> NSURL {
        return NSURL(fileURLWithPath: absolutePath)
    }
    
    //MARK: Move
    
    /**
     Moves a file from a source location to a destination location.
     
     - parameter sourcePath: current absolute path of file to be moved.
     - parameter destinationPath: future absolute path that file will be moved to.
     
     - returns: Bool - true if move was successful, false otherwise.
     */
    public class func moveFile(sourceAbsolutePath: String, destinationAbsolutePath: String) -> Bool {
        var moved = true
        
        if sourceAbsolutePath.characters.count > 0 && destinationAbsolutePath.characters.count > 0 {
            let destinationAbsoluteURL = NSURL(string: destinationAbsolutePath)
            
            if let destinationAbsoluteDirectoryPath = destinationAbsoluteURL?.URLByDeletingLastPathComponent?.path {
                
                var createdDirectory = true
                
                if  NSFileManager.defaultManager().fileExistsAtPath(destinationAbsoluteDirectoryPath) {
                    createdDirectory = NSFileManager.createDirectoryAtPath(destinationAbsoluteDirectoryPath)
                }
                
                if createdDirectory {
                    do {
                        try NSFileManager.defaultManager().moveItemAtPath(sourceAbsolutePath, toPath: destinationAbsolutePath)
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