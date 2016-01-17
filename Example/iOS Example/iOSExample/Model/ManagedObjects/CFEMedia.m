//
//  CFEMedia.m
//  iOSExample
//
//  Created by Boles on 17/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import "CFEMedia.h"

@implementation CFEMedia

#pragma mark - Location

- (NSString *)locationString
{
    NSString *locationString = nil;
    
    switch (self.location.integerValue)
    {
        case CFEMediaLocationCache:
        {
            locationString = @"Cache";
            
            break;
        }
        case CFEMediaLocationDocuments:
        {
            locationString = @"Documents";
            
            break;
        }
    }
    
    return locationString;
}

@end
