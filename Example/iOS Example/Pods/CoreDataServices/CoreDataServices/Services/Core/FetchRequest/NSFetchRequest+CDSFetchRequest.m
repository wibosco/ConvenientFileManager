//
//  NSFetchRequest+CDSFetchRequest.m
//  CoreDataServices
//
//  Created by William Boles on 08/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import "NSFetchRequest+CDSFetchRequest.h"

@implementation NSFetchRequest (CDSFetchRequest)

#pragma mark - FetchRequest

+ (instancetype)cds_fetchRequestWithEntityClass:(Class)entityClass
{
    NSString *entityName = NSStringFromClass(entityClass);
    
    return [NSFetchRequest fetchRequestWithEntityName:entityName];
}

@end
