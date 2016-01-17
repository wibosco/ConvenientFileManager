//
//  CFEPhoto.m
//  iOSExample
//
//  Created by Boles on 17/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import "CFEPhoto.h"

@implementation CFEPhoto

#pragma mark - Location

- (NSString *)locationString
{
    NSString *locationString = nil;
    
    switch (self.location.integerValue)
    {
        case CFEPhotoLocationCache:
        {
            locationString = @"Cache";
            
            break;
        }
        case CFEPhotoLocationDocuments:
        {
            locationString = @"Documents";
            
            break;
        }
    }
    
    return locationString;
}

@end
