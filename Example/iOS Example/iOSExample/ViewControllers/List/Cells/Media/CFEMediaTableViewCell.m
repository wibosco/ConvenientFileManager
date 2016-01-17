//
//  CDEPhotoTableViewCell.m
//  CoreDataServicesiOSExample
//
//  Created by William Boles on 15/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import "CFEMediaTableViewCell.h"

#import <PureLayout/PureLayout.h>

static CGFloat const kCFEPadding = 28.0f;

@interface CFEMediaTableViewCell ()

@property (nonatomic, strong, readwrite) UILabel *nameLabel;
@property (nonatomic, strong, readwrite) UILabel *directoryLocationLabel;

@end

@implementation CFEMediaTableViewCell

#pragma mark - Init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.directoryLocationLabel];
    }
    
    return self;
}

#pragma mark - Subviews

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [UILabel newAutoLayoutView];
        _nameLabel.font = [UIFont fontWithName:@"HelveticaNeue"
                                          size:15.0f];
    }
    
    return _nameLabel;
}

- (UILabel *)directoryLocationLabel
{
    if (!_directoryLocationLabel)
    {
        _directoryLocationLabel = [UILabel newAutoLayoutView];
        _directoryLocationLabel.font = [UIFont fontWithName:@"HelveticaNeue"
                                                       size:11.0f];
    }
    
    return _directoryLocationLabel;
}

#pragma mark - Autolayout

- (void)updateConstraints
{
    [super updateConstraints];
    
    /*-------------------------*/
    
    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                     withInset:kCFEPadding];
    
    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop
                                     withInset:4.0f];
    
    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight
                                     withInset:kCFEPadding];
    
    /*-------------------------*/
    
    [self.directoryLocationLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft
                                                  withInset:kCFEPadding];
    
    [self.directoryLocationLabel autoPinEdge:ALEdgeTop
                                      toEdge:ALEdgeBottom
                                      ofView:self.nameLabel];
    
    [self.directoryLocationLabel autoPinEdgeToSuperviewEdge:ALEdgeRight
                                                  withInset:kCFEPadding];
    
    [self.directoryLocationLabel autoSetDimension:ALDimensionHeight
                                           toSize:15.0f];
    
    /*-------------------------*/
}

#pragma mark - Identifier

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

#pragma mark - Layout

- (void)layoutByApplyingConstraints
{
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
