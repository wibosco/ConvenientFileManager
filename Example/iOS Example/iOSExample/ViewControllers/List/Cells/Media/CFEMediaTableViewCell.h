//
//  CDEPhotoTableViewCell.h
//  CoreDataServicesiOSExample
//
//  Created by William Boles on 15/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFEMediaTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *directoryLocationLabel;

+ (NSString *)reuseIdentifier;

- (void)layoutByApplyingConstraints;

@end
