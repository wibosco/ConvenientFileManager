//
//  NSManagedObjectContext+CDSDelete.m
//  CoreDataServices
//
//  Created by William Boles on 08/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import "NSManagedObjectContext+CDSDelete.h"

#import "NSManagedObjectContext+CDSRetrieval.h"
#import "CDSServiceManager.h"

@implementation NSManagedObjectContext (CDSDelete)

#pragma mark - Single

- (void)cds_deleteManagedObject:(NSManagedObject *)managedObject
{
    [self cds_deleteManagedObject:managedObject
                saveAfterDeletion:YES];
}

- (void)cds_deleteManagedObject:(NSManagedObject *)managedObject
              saveAfterDeletion:(BOOL)saveAfterDeletion
{
    if (managedObject)
    {
        [self deleteObject:managedObject];
        
        if (saveAfterDeletion)
        {
            if ([self save:nil])
            {
                //Force context to process pending changes as
                //cascading deletes may not be immediatly applied by core data.
                [self processPendingChanges];
            }
        }
    }
}

#pragma mark - Multiple

- (void)cds_deleteEntriesForEntityClass:(Class)entityClass
                              predicate:(NSPredicate *)predicate
                      saveAfterDeletion:(BOOL)saveAfterDeletion
{
    NSArray *entities = [self cds_retrieveEntriesForEntityClass:entityClass
                                                  predicate:predicate];
    
    for (NSManagedObject *entity in entities)
    {
        [self cds_deleteManagedObject:entity
                    saveAfterDeletion:NO];
    }
    
    if (saveAfterDeletion)
    {
        if ([self save:nil])
        {
            //Force context to process pending changes as
            //cascading deletes may not be immediatly applied by coredata.
            [self processPendingChanges];
        }
    }
}

- (void)cds_deleteEntriesForEntityClass:(Class)entityClass
                              predicate:(NSPredicate *)predicate
{
    [self cds_deleteEntriesForEntityClass:entityClass
                                predicate:predicate
                        saveAfterDeletion:YES];
}

- (void)cds_deleteEntriesForEntityClass:(Class)entityClass
{
    [self cds_deleteEntriesForEntityClass:entityClass
                                predicate:nil
                        saveAfterDeletion:YES];
}

- (void)cds_deleteEntriesForEntityClass:(Class)entityClass
                      saveAfterDeletion:(BOOL)saveAfterDeletion
{
    [self cds_deleteEntriesForEntityClass:entityClass
                                predicate:nil
                        saveAfterDeletion:saveAfterDeletion];
}

@end
