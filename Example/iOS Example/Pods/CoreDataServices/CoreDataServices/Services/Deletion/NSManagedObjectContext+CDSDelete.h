//
//  NSManagedObjectContext+CDSDelete.h
//  CoreDataServices
//
//  Created by William Boles on 08/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

@import CoreData;

/**
 A category that extends `NSManagedObjectContext` to provide convenience methods related to deleting entries/rows/objects in your Core Data Entity.
 
 In order to use this category you will need to create a subclasses of `NSManagedObject` rather than using KVO.
 */
@interface NSManagedObjectContext (CDSDelete)

/*
 Deletes an `NSManagedObject` instance.
 
 @param managedObject - to be deleted.
 */
- (void)cds_deleteManagedObject:(NSManagedObject *)managedObject;

/*
 Deletes an `NSManagedObject` instance.
 
 @param managedObject - to be deleted.
 @param saveAfterDeletion - used to determine if after deletion the managed object context should be saved. Especially useful when deleting objects on a background thread and you want to perform our tasks before saving/merging into the main `NSManagedObjectContext`.
 */
- (void)cds_deleteManagedObject:(NSManagedObject *)managedObject
              saveAfterDeletion:(BOOL)saveAfterDeletion;

/*
 Deletes entries/rows/objects from core data entity.
 
 @param entityClass - a class value for the entity in core data.
 */
- (void)cds_deleteEntriesForEntityClass:(Class)entityClass;

/*
 Deletes entries/rows/objects from core data entity.
 
 @param entityClass - a class value for the entity in core data.
 @param saveAfterDeletion - used to determine if after deletion the managed object context should be saved. Especially useful when deleting objects on a background thread and you want to perform our tasks before saving/merging into the main `NSManagedObjectContext`.
 */
- (void)cds_deleteEntriesForEntityClass:(Class)entityClass
                      saveAfterDeletion:(BOOL)saveAfterDeletion;

/*
 Deletes entries/rows/objects from core data entity that matches the predicate passed.
 
 @param entityClass - a class value for the entity in core data.
 @param predicate - a predicate used to limit the entries deleted.
 */
- (void)cds_deleteEntriesForEntityClass:(Class)entityClass
                              predicate:(NSPredicate *)predicate;

/*
 Deletes entries/rows/objects from core data entity that matches the predicate passed.
 
 @param entityClass - a class value for the entity in core data.
 @param predicate - a predicate used to limit the entries deleted.
 @param saveAfterDeletion - used to determine if after deletion the managed object context should be saved. Especially useful when deleting objects on a background thread and you want to perform our tasks before saving/merging into the main `NSManagedObjectContext`.
 */
- (void)cds_deleteEntriesForEntityClass:(Class)entityClass
                              predicate:(NSPredicate *)predicate
                      saveAfterDeletion:(BOOL)saveAfterDeletion;


@end
