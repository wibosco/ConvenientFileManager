//
//  File.swift
//  ConvenientFileManager
//
//  Created by William Boles on 29/03/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

/// A collection of helper functions for common operations when dealing with the file manager.
public extension FileManager {
    
    //MARK: Retrieving
    
    /**
     Retrieve data to path in document directory.
     
     - Parameter absolutePath: absolute path that will be used to retrieve the data that it's location.
     
     - Returns: NSData that was retrieved or nil.
     */
    @objc(cfm_retrieveDataAtPath:)
    public class func retrieveDataAtPath(_ absolutePath: String) -> Data? {
        var data: Data?
        
        if absolutePath.characters.count > 0 {
            data = try? Data(contentsOf: URL(fileURLWithPath: absolutePath))
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
    @discardableResult
    public class func saveData(_ data: Data, absolutePath: String) -> Bool {
        var success = true
        
        if data.count > 0 && absolutePath.characters.count > 0 {
            let absoluteURL = self.fileURLForPath(absolutePath)
            let directoryPath = absoluteURL.deletingLastPathComponent().path
            
            var createdDirectory = true
            
            if !FileManager.default.fileExists(atPath: directoryPath) {
                createdDirectory = FileManager.createDirectoryAtPath(directoryPath)
            }
            
            if createdDirectory {
                do {
                    try data.write(to: absoluteURL, options: NSData.WritingOptions.atomic)
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
        
        return success
    }
    
    /**
     Creates directory on filesystem.
     
     If the directory doesn't exist it will be created.
     
     - Parameter absolutePath: absolute path/directory-structure that will be created.
     
     - Returns: Bool - true if creation was successful, false otherwise.
     */
    @objc(cfm_createDirectoryAtPath:)
    @discardableResult
    public class func createDirectoryAtPath(_ absoluteDirectoryPath: String) -> Bool {
        var createdDirectory = true
        
        if absoluteDirectoryPath.characters.count > 0 {
            let absoluteDirectoryURL = self.fileURLForPath(absoluteDirectoryPath)
            
            do {
                try FileManager.default.createDirectory(at: absoluteDirectoryURL, withIntermediateDirectories: true, attributes: nil)
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
    public class func fileExistsAtPath(_ absolutePath: String) -> Bool {
        return FileManager.default.fileExists(atPath: absolutePath)
    }
   
    /**
     Determines asynchronously  if a file exists at path.
     
     - Parameter absolutePath: absolute path to the file.
     - Parameter completion: a block that will be executed upon determining if a file exists or not.
     */
    @objc(cfm_fileExistsAtPath:completion:)
    public class func fileExistsAtPath(_ absolutePath: String, completion:((_ fileExists: Bool) -> Void)?) {
        //Used to return the call on the same thread
        let callBackQueue = OperationQueue.current
        
        DispatchQueue.global(qos: .background).async {
            let fileExists = FileManager.fileExistsAtPath(absolutePath)
            
            callBackQueue?.addOperation({
                if completion != nil {
                    completion!(fileExists)
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
    @discardableResult
    public class func deleteDataAtPath(_ absolutePath: String) -> Bool {
        var deleted = true
        
        if absolutePath.characters.count > 0 {
            let absoluteURL = self.fileURLForPath(absolutePath)
            
            do {
                try FileManager.default.removeItem(at: absoluteURL)
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
    public class func fileURLForPath(_ absolutePath: String) -> URL {
        return URL(fileURLWithPath: absolutePath)
    }
    
    //MARK: Move
    
    /**
     Moves a file from a source location to a destination location.
     
     - Parameter sourceAbsolutePath: current absolute path of file to be moved.
     - Parameter destinationAbsolutePath: future absolute path that file will be moved to.
     
     - Returns: Bool - true if move was successful, false otherwise.
     */
    @objc(cfm_moveFileFromSourcePath:toDestinationPath:)
    @discardableResult
    public class func moveFile(_ sourceAbsolutePath: String, destinationAbsolutePath: String) -> Bool {
        var moved = true
        
        if sourceAbsolutePath.characters.count > 0 && destinationAbsolutePath.characters.count > 0 {
            let destinationAbsoluteURL = self.fileURLForPath(destinationAbsolutePath)
            let destinationAbsoluteDirectoryPath = destinationAbsoluteURL.deletingLastPathComponent().path
            
            var createdDirectory = true
            
            if  FileManager.default.fileExists(atPath: destinationAbsoluteDirectoryPath) {
                createdDirectory = FileManager.createDirectoryAtPath(destinationAbsoluteDirectoryPath)
            }
            
            if createdDirectory {
                let sourceAbsoluteURL = self.fileURLForPath(sourceAbsolutePath)
                
                do {
                    try FileManager.default.moveItem(at: sourceAbsoluteURL, to: destinationAbsoluteURL)
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
        
        return moved
    }
}
