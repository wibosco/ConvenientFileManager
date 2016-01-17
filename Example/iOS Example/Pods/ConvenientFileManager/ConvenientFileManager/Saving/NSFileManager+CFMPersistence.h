//
//  NSFileManager+CFMPersistence.h
//  ConvenientFileManager
//
//  Created by William Boles on 10/01/2014.
//  Copyright © 2015 Boles. All rights reserved.
//

@import Foundation;

/**
 A collection of helper methods for common operations when dealing with the file manager.
 */
@interface NSFileManager (CFMPersistence)

/**
 Save data to path on filesystem.
 
 If the directory doesn't exist it will be created.
 
 @parameter data - data to be saved.
 @parameter path - path that the data will be saved to.
 
 @return BOOL if save was successful.
 */
+ (BOOL)cfm_saveData:(NSData *)data
              toPath:(NSString *)path;

/**
 Creates directory on filesystem.
 
 If the directory doesn't exist it will be created.
 
 @parameter path - path/directory-structure that will be created.
 
 @return BOOL if creation was successful.
 */
+ (BOOL)cfm_createDirectoryAtPath:(NSString *)path;

/**
 Determines if a file exists at path.
 
 @parameter path - path to the file.
 
 @return BOOL - YES if file exists, NO if file doesn't exist.
 */
+ (BOOL)cfm_fileExistsAtPath:(NSString *)path;

/**
 Delete data from path.
 
 @parameter path - path to the file.
 
 @return BOOL if deletion was successful.
 */
+ (BOOL)cfm_deleteDataAtPath:(NSString *)path;

/**
 URL of resource in directory.
 
 @parameter path - path that will be combined cache path.
 
 @return Combined URL.
 */
+ (NSURL *)cfm_fileURLForPath:(NSString *)path;

/**
 Moves a file from a source location to a destination location.
 
 @parameter sourcePath - current location of file to be moved.
 @parameter destinationPath - future location that file will be moved to.
 
 @return BOOL if move was successful.
 */
+ (BOOL)cfm_moveFileFromSourcePath:(NSString *)sourcePath
                 toDestinationPath:(NSString *)destinationPath;

@end
