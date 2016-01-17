//
//  NSManagedObjectContext+CDSCount.m
//  CoreDataServices
//
//  Created by William Boles on 08/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import "NSManagedObjectContext+CDSCount.h"

#import "CDSServiceManager.h"
#import "NSFetchRequest+CDSFetchRequest.h"

@implementation NSManagedObjectContext (CDSCount)

#pragma mark - Count

- (NSUInteger)cds_retrieveEntriesCountForEntityClass:(Class)entityClass
                                           predicate:(NSPredicate *)predicate
{
    NSUInteger count = 0;
    
    NSString *entityName = NSStringFromClass(entityClass);
    
    if (entityName.length > 0)
    {
        NSFetchRequest *request = [NSFetchRequest cds_fetchRequestWithEntityClass:entityClass];
        
        if (predicate)
        {
            request.predicate = predicate;
        }
        
        NSError *error = nil;
        
        count = [self countForFetchRequest:request
                                     error:&error];
        
        if (error)
        {
            NSLog(@"Error attempting to retrieve entries count from entity: %@ with pred: %@, userinfo: %@", entityName, predicate, [error userInfo]);
        }
    }
    
    return count;
}

- (NSUInteger)cds_retrieveEntriesCountForEntityClass:(Class)entityClass
{
    return [self cds_retrieveEntriesCountForEntityClass:entityClass
                                              predicate:nil];
}

@end
