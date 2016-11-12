//
//  OCEMediaTableViewCell.h
//  ObjectiveCExample
//
//  Created by William Boles on 12/11/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCEMediaTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UIImageView *mediaImageView;

@end

NS_ASSUME_NONNULL_END
