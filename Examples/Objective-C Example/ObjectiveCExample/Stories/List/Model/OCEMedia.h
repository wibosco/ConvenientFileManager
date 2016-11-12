//
//  OCEMedia.h
//  ObjectiveCExample
//
//  Created by William Boles on 12/11/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, OCEMediaLocation)
{
    OCEMediaLocationCache,
    OCEMediaLocationDocuments,
};

@interface OCEMedia : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) OCEMediaLocation location;

@end

NS_ASSUME_NONNULL_END
