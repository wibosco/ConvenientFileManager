//
//  FileManager+Persistence.swift
//  ConvenientFileManager
//
//  Created by William Boles on 29/03/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

import Foundation

/// A collection of helper functions for common operations when dealing with the file manager.
public extension FileManager {
    
    // MARK: - Retrieving
    
    /**
     Retrieve data to path in document directory.
     
     - Parameter absolutePath: absolute path that will be used to retrieve the data that it's location.
     
     - Returns: NSData that was retrieved or nil.
     */
    @objc(cfm_retrieveDataAtAbsolutePath:)
    public class func retrieveData(absolutePath: String) -> Data? {
        guard absolutePath.characters.count > 0 else {
            return nil
        }
        
        do {
            return try Data(contentsOf: URL(fileURLWithPath: absolutePath))
        } catch {
            print("Error when attempting to retrieve data from: \(absolutePath). The error was: \(error)")
            return nil
        }
    }
    
    // MARK: - Write
    
    /**
     Write/Save data to path on filesystem.
     
     If the directory doesn't exist it will be created.
     
     - Parameter data: data to be saved.
     - Parameter absolutePath: absolute path that the data will be saved to.
     
     - Returns: BOOL if save was successful.
     */
    @objc(cfm_writeData:toAbsolutePath:)
    @discardableResult
    public class func write(data: Data, absolutePath: String) -> Bool {
        guard data.count > 0 && absolutePath.characters.count > 0 else {
            return false
        }
        
        let absoluteURL = self.fileURL(absolutePath: absolutePath)
        let directoryPath = absoluteURL.deletingLastPathComponent().path
        
        var createdDirectory = true
        
        if !FileManager.default.fileExists(atPath: directoryPath) {
            createdDirectory = FileManager.createDirectory(absoluteDirectoryPath: directoryPath)
        }
        
        if createdDirectory {
            do {
                try data.write(to: absoluteURL, options: .atomic)
                return true
            } catch {
                print("Error when saving data at location: \(absolutePath). The error was: \(error)")
                return false
            }
        } else {
            return false
        }
    }
    
    /**
     Creates directory on filesystem.
     
     If the directory doesn't exist it will be created.
     
     - Parameter absoluteDirectoryPath: absolute path/directory-structure that will be created.
     
     - Returns: Bool - true if creation was successful, false otherwise.
     */
    @objc(cfm_createDirectoryAtAbsoluteDirectoryPath:)
    @discardableResult
    public class func createDirectory(absoluteDirectoryPath: String) -> Bool {
        guard absoluteDirectoryPath.characters.count > 0 else {
            return false
        }
        
        let absoluteDirectoryURL = self.fileURL(absolutePath: absoluteDirectoryPath)
        
        do {
            try FileManager.default.createDirectory(at: absoluteDirectoryURL, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch {
            print("Error when creating a directory at location: \(absoluteDirectoryPath). The error was: \(error)")
            return false
        }
    }
    
    // MARK: - Exists
    
    /**
     Determines if a file exists at path.
     
     - Parameter absolutePath: absolute path to the file.
     
     - Returns: Bool - YES if file exists, NO if file doesn't exist.
     */
    @objc(cfm_fileExistsAtAbsolutePath:)
    public class func fileExists(absolutePath: String) -> Bool {
        return FileManager.default.fileExists(atPath: absolutePath)
    }
   
    /**
     Determines asynchronously  if a file exists at path.
     
     - Parameter absolutePath: absolute path to the file.
     - Parameter completion: a block that will be executed upon determining if a file exists or not.
     */
    @objc(cfm_fileExistsAtAbsolutePath:completion:)
    public class func fileExists(absolutePath: String, completion:((_ fileExists: Bool) -> Void)?) {
        //Used to return the call on the same thread
        let callBackQueue = OperationQueue.current
        
        DispatchQueue.global(qos: .background).async {
            let fileExists = FileManager.fileExists(absolutePath: absolutePath)
            
            callBackQueue?.addOperation({
                if completion != nil {
                    completion!(fileExists)
                }
            })
        }
    }
    
    // MARK: - Deletion
    
    /**
     Delete data from path.
     
     - Parameter absolutePath: absolute path to the file.
     
     - Returns: Bool - true if deletion was successful, false otherwise.
     */
    @objc(cfm_deleteDataAtAbsolutePath:)
    @discardableResult
    public class func deleteData(absolutePath: String) -> Bool {
        guard absolutePath.characters.count > 0 else {
            return false
        }
        
        let absoluteURL = self.fileURL(absolutePath: absolutePath)
        
        do {
            try FileManager.default.removeItem(at: absoluteURL)
            return true
        } catch {
            print("Error when deleting data at location: \(absolutePath). The error was: \(error)")
            return false
        }
    }
    
    // MARK: - URL
    
    /**
     URL of resource in directory.
     
     - Parameter absolutePath: absolute path that will be combined cache path.
     
     - Returns: Combined URL.
     */
    @objc(cfm_fileURLForAbsolutePath:)
    public class func fileURL(absolutePath: String) -> URL {
        return URL(fileURLWithPath: absolutePath)
    }
    
    // MARK: - Move
    
    /**
     Moves a file from a source location to a destination location.
     
     - Parameter sourceAbsolutePath: current absolute path of file to be moved.
     - Parameter destinationAbsolutePath: future absolute path that file will be moved to.
     
     - Returns: Bool - true if move was successful, false otherwise.
     */
    @objc(cfm_moveFileFromSourceAbsolutePath:toDestinationAbsolutePath:)
    @discardableResult
    public class func moveFile(sourceAbsolutePath: String, destinationAbsolutePath: String) -> Bool {
        guard sourceAbsolutePath.characters.count > 0 && destinationAbsolutePath.characters.count > 0 else {
            return false
        }
        
        let destinationAbsoluteURL = self.fileURL(absolutePath: destinationAbsolutePath)
        let destinationAbsoluteDirectoryPath = destinationAbsoluteURL.deletingLastPathComponent().path
        
        var createdDirectory = true
        
        if  FileManager.default.fileExists(atPath: destinationAbsoluteDirectoryPath) {
            createdDirectory = FileManager.createDirectory(absoluteDirectoryPath: destinationAbsoluteDirectoryPath)
        }
        
        if createdDirectory {
            let sourceAbsoluteURL = self.fileURL(absolutePath: sourceAbsolutePath)
            
            do {
                try FileManager.default.moveItem(at: sourceAbsoluteURL, to: destinationAbsoluteURL)
                return true
            } catch {
                print("Error when moving file from: \(sourceAbsolutePath) to \(destinationAbsolutePath). The error was: \(error)")
                return false
            }
        } else {
            return false
        }
    }
}
