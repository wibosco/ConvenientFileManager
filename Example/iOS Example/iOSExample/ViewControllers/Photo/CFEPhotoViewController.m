//
//  CFEPhotoViewController.m
//  iOSExample
//
//  Created by Home on 17/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import "CFEPhotoViewController.h"

#import <PureLayout/PureLayout.h>

#import "CFEPhoto.h"

@interface CFEPhotoViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) CFEPhoto *image;

@end

@implementation CFEPhotoViewController

#pragma mark - Init

- (instancetype)initWithImage:(CFEPhoto *)photo
{
    self = [super init];
    
    if (self)
    {
        self.image = photo;
    }
    
    return self;
}

#pragma mark - ViewLifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*-------------------*/
    
    self.title = @"Image Detail";
    
    /*-------------------*/
    
    [self.view addSubview:self.imageView];
}

#pragma mark - Autolayout

- (void)updateViewConstraints
{
    [self.imageView autoPinEdgesToSuperviewEdges];
    
    [super updateViewConstraints];
}

#pragma mark - Subviews

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [UIImageView newAutoLayoutView];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _imageView;
}

@end
