//
//  NSFetchRequest+CDSFetchRequest.h
//  CoreDataServices
//
//  Created by William Boles on 08/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

@import CoreData;

/**
 A category that extends `NSEntityDescription` to add methods that focus on avoiding passing "magic strings" and instead focuses on passing around a class.
 
 In order to use this category you will need to create a subclasses of `NSManagedObject` rather than using KVO.
 */
@interface NSFetchRequest (CDSFetchRequest)

/**
 Convenience init method to allow for retreive of a NSFetchRequest instance given a core data entity class. 
 
 @param entityClass - class value for the entity in core data.
 
 @return `NSFetchRequest` instance for the entityClass passed in.
 */
+ (instancetype)cds_fetchRequestWithEntityClass:(Class)entityClass;

@end
