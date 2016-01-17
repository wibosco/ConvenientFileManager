//
//  NSManagedObjectContext+CDSCount.h
//  CoreDataServices
//
//  Created by William Boles on 08/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

@import CoreData;

/**
 A category that extends `NSManagedObjectContext` to provide convenience methods related to counting the number of entries/rows/objects in your Core Data Entity.
 
 In order to use this category you will need to create a subclasses of `NSManagedObject` rather than using KVO.
 */
@interface NSManagedObjectContext (CDSCount)

/*
 Retrieves the count of entries.
 
 @param entityClass - a class value for the entity in core data.
 
 @return `NSUInteger` count of entries for this class/entity.
 */
- (NSUInteger)cds_retrieveEntriesCountForEntityClass:(Class)entityClass;


/*
 Retrieves the count of entries that match the provided predicate's conditions.
 
 @param entityClass - a class value for the entity in core data.
 @param predicate - a predicate used to limit the entries returned.
 
 @return `NSUInteger` count of entries that match provided predicate.
 */
- (NSUInteger)cds_retrieveEntriesCountForEntityClass:(Class)entityClass
                                           predicate:(NSPredicate *)predicate;


@end
