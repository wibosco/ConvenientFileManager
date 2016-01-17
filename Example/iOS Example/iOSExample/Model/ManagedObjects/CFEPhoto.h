//
//  CFEPhoto.h
//  iOSExample
//
//  Created by Boles on 17/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CFEPhotoLocation)
{
    CFEPhotoLocationCache,
    CFEPhotoLocationDocuments,
};

@interface CFEPhoto : NSManagedObject

- (NSString *)locationString;

@end

NS_ASSUME_NONNULL_END

#import "CFEPhoto+CoreDataProperties.h"
