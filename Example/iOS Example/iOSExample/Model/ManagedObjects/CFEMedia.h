//
//  CFEMedia.h
//  iOSExample
//
//  Created by Boles on 17/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CFEMediaLocation)
{
    CFEMediaLocationCache,
    CFEMediaLocationDocuments,
};

@interface CFEMedia : NSManagedObject

- (NSString *)locationString;

@end

NS_ASSUME_NONNULL_END

#import "CFEMedia+CoreDataProperties.h"
