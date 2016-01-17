//
//  CFEPhoto+CoreDataProperties.h
//  iOSExample
//
//  Created by Home on 17/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CFEPhoto.h"

NS_ASSUME_NONNULL_BEGIN

@interface CFEPhoto (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *photoID;
@property (nullable, nonatomic, retain) NSDate *createdDate;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *location;

@end

NS_ASSUME_NONNULL_END
