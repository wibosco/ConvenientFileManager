//
//  NSEntityDescription+CDSEntityDescription.m
//  CoreDataServices
//
//  Created by William Boles on 08/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import "NSEntityDescription+CDSEntityDescription.h"

@implementation NSEntityDescription (CDSEntityDescription)

#pragma mark - Retrieval

+ (NSEntityDescription *)cds_entityForClass:(Class)entityClass
                     inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSString *entityName = NSStringFromClass(entityClass);
    
    return [NSEntityDescription entityForName:entityName
                       inManagedObjectContext:managedObjectContext];
}

#pragma mark - Insertion

+ (__kindof NSManagedObject *)cds_insertNewObjectForEntityForClass:(Class)entityClass
                                            inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSString *entityName = NSStringFromClass(entityClass);
    
    return [NSEntityDescription insertNewObjectForEntityForName:entityName
                                         inManagedObjectContext:managedObjectContext];
}

@end
