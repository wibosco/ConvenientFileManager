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
 Retrieve data to path in document directory.
 
 @parameter absolutePath - absolute path that will be used to retrieve the data that it's location.
 
 @return NSData that was retrieved.
 */
+ (NSData *)cfm_retrieveDataAtPath:(NSString *)absolutePath;

/**
 Save data to path on filesystem.
 
 If the directory doesn't exist it will be created.
 
 @parameter data - data to be saved.
 @parameter absolutePath - absolute path that the data will be saved to.
 
 @return BOOL if save was successful.
 */
+ (BOOL)cfm_saveData:(NSData *)data
              toPath:(NSString *)absolutePath;

/**
 Creates directory on filesystem.
 
 If the directory doesn't exist it will be created.
 
 @parameter absolutePath - absolute path/directory-structure that will be created.
 
 @return BOOL if creation was successful.
 */
+ (BOOL)cfm_createDirectoryAtPath:(NSString *)absolutePath;

/**
 Determines if a file exists at path.
 
 @parameter absolutePath - absolute path to the file.
 
 @return BOOL - YES if file exists, NO if file doesn't exist.
 */
+ (BOOL)cfm_fileExistsAtPath:(NSString *)absolutePath;

/**
 Determines asynchronously  if a file exists at path.
 
 @parameter absolutePath - absolute path to the file.
 @parameter completion - a block that will be executed upon determining if a file exists or not.
 */
+ (void)cfm_fileExistsAtPath:(NSString *)absolutePath
                  completion:(void (^)(BOOL fileExists))completion;

/**
 Delete data from path.
 
 @parameter absolutePath - absolute path to the file.
 
 @return BOOL if deletion was successful.
 */
+ (BOOL)cfm_deleteDataAtPath:(NSString *)absolutePath;

/**
 URL of resource in directory.
 
 @parameter absolutePath - absolute path that will be combined cache path.
 
 @return Combined URL.
 */
+ (NSURL *)cfm_fileURLForPath:(NSString *)absolutePath;

/**
 Moves a file from a source location to a destination location.
 
 @parameter sourcePath - current absolute path of file to be moved.
 @parameter destinationPath - future absolute path that file will be moved to.
 
 @return BOOL if move was successful.
 */
+ (BOOL)cfm_moveFileFromSourcePath:(NSString *)sourcePath
                 toDestinationPath:(NSString *)destinationPath;

@end
