//
//  NSManagedObjectContext+CDSRetrieval.h
//  CoreDataServices
//
//  Created by William Boles on 08/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

@import CoreData;

/**
 A category that extends `NSManagedObjectContext` to provide convenience methods related to retrieving data from a Core Data Entity.
 
 In order to use this category you will need to create a subclasses of `NSManagedObject` rather than using KVO.
 */
@interface NSManagedObjectContext (CDSRetrieval)

/*
 Retrieves all entries for an entity in core data.
 
 @param entityClass - a class value for the entity in core data.
 
 @return `NSArray` of `NSManagedObjects`.
 */
- (NSArray *)cds_retrieveEntriesForEntityClass:(Class)entityClass;

/*
 Retrieves all entries for an entity in core data.
 
 @param entityClass - a class value for the entity in core data.
 @param fetchBatchSize - limits the number of returned objects in each batch.
 
 @return `NSArray` of `NSManagedObjects`.
 */
- (NSArray *)cds_retrieveEntriesForEntityClass:(Class)entityClass
                                fetchBatchSize:(NSUInteger)fetchBatchSize;


/*
 Retrieves all entries for an entity in core data that match the provided predicate's conditions.
 
 @param entityClass - a class value for the entity in core data.
 @param predicate - a predicate used to limit the entries returned.
 
 @return `NSArray` of `NSManagedObjects`.
 */
- (NSArray *)cds_retrieveEntriesForEntityClass:(Class)entityClass
                                     predicate:(NSPredicate *)predicate;


/*
 Retrieves all entries for an entity in core data that match the provided predicate's conditions.
 
 @param entityClass - a class value for the entity in core data.
 @param predicate - a predicate used to limit the entries returned.
 @param fetchBatchSize - limits the number of returned objects in each batch.
 
 @return `NSArray` of `NSManagedObjects`.
 */
- (NSArray *)cds_retrieveEntriesForEntityClass:(Class)entityClass
                                     predicate:(NSPredicate *)predicate
                                fetchBatchSize:(NSUInteger)fetchBatchSize;


/*
 Retrieves ordered entries for an entity in core data.
 
 @param entityClass - a class value for the entity in core data.
 @param sortDescriptors - an array containing sorting values to be applied to this request.
 
 @return `NSArray` of `NSManagedObjects`.
 */
- (NSArray *)cds_retrieveEntriesForEntityClass:(Class)entityClass
                               sortDescriptors:(NSArray *)sortDescriptors;


/*
 Retrieves ordered entries for an entity in core data.
 
 @param entityClass - a class value for the entity in core data.
 @param sortDescriptors - an array containing sorting values to be applied to this request.
 @param fetchBatchSize - limits the number of returned objects in each batch.
 
 @return `NSArray` of `NSManagedObjects`.
 */
- (NSArray *)cds_retrieveEntriesForEntityClass:(Class)entityClass
                               sortDescriptors:(NSArray *)sortDescriptors
                                fetchBatchSize:(NSUInteger)fetchBatchSize;


/*
 Retrieves ordered entries for an entity in core data that match the provided predicate's conditions.
 
 @param entityClass - a class value for the entity in core data.
 @param predicate - a predicate used to limit the entries returned.
 @param sortDescriptors - an array containing sorting values to be applied to this request.
 
 @return `NSArray` of `NSManagedObjects`.
 */
- (NSArray *)cds_retrieveEntriesForEntityClass:(Class)entityClass
                                     predicate:(NSPredicate *)predicate
                               sortDescriptors:(NSArray *)sortDescriptors;


/*
 Retrieves ordered entries for an entity in core data that match the provided predicate's conditions.
 
 @param entityClass - a class value for the entity in core data.
 @param predicate - a predicate used to limit the entries returned.
 @param sortDescriptors - an array containing sorting values to be applied to this request.
 @param fetchBatchSize - limits the number of returned objects in each batch.
 
 @return `NSArray` of `NSManagedObjects`.
 */
- (NSArray *)cds_retrieveEntriesForEntityClass:(Class)entityClass
                                     predicate:(NSPredicate *)predicate
                               sortDescriptors:(NSArray *)sortDescriptors
                                fetchBatchSize:(NSUInteger)fetchBatchSize;


#pragma mark - SingleRetrieval

/*
 Retrieves first entry for an entity in core data.
 
 @param entityClass - a class value for the entity in core data.
 
 @return `NSManagedObject` instance.
 */
- (NSManagedObject *)cds_retrieveFirstEntryForEntityClass:(Class)entityClass;

/*
 Retrieves first entry for an entity in core data that match the provided predicate's conditions.
 
 @param entityClass - a class value for the entity in core data.
 @param predicate - a predicate used to limit the entries returned.
 
 @return `NSManagedObject` instance.
 */
- (NSManagedObject *)cds_retrieveFirstEntryForEntityClass:(Class)entityClass
                                                predicate:(NSPredicate *)predicate;


/*
 Retrieves first entry for an entity in core data.
 
 @param entityClass - a class value for the entity in core data.
 @param predicate - a predicate used to limit the entries returned.
 @param sortDescriptors - an array containing sorting values to be applied to this request.
 
 @return `NSManagedObject` instance.
 */
- (NSManagedObject *)cds_retrieveFirstEntryForEntityClass:(Class)entityClass
                                                predicate:(NSPredicate *)predicate
                                          sortDescriptors:(NSArray *)sortDescriptors;


@end
