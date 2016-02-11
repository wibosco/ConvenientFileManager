//
//  CFEPhotoViewController.m
//  iOSExample
//
//  Created by Boles on 17/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import "CFEMediaViewController.h"

#import <PureLayout/PureLayout.h>
#import <CoreDataServices/CDSServiceManager.h>
#import <CoreDataServices/NSManagedObjectContext+CDSDelete.h>
#import <ConvenientFileManager/NSFileManager+CFMCache.h>
#import <ConvenientFileManager/NSFileManager+CFMDocuments.h>

#import "CFEMedia.h"

@interface CFEMediaViewController ()

@property (nonatomic, strong) UIImageView *mediaImageView;
@property (nonatomic, strong) CFEMedia *media;
@property (nonatomic, strong) UIBarButtonItem *trashBarButtonItem;

- (void)trashButtonPressed:(UIBarButtonItem *)sender;
- (UIImage *)retrieveImageFromMedia:(CFEMedia *)media;

@end

@implementation CFEMediaViewController

#pragma mark - Init

- (instancetype)initWithMedia:(CFEMedia *)media
{
    self = [super init];
    
    if (self)
    {
        self.media = media;
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
    
    self.navigationItem.rightBarButtonItem = self.trashBarButtonItem;
    
    /*-------------------*/
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.mediaImageView];
    
    /*-------------------*/
    
    [self updateViewConstraints];
}

#pragma mark - Autolayout

- (void)updateViewConstraints
{
    [self.mediaImageView autoPinEdgesToSuperviewEdges];
    
    [super updateViewConstraints];
}

#pragma mark - Subviews

- (UIImageView *)mediaImageView
{
    if (!_mediaImageView)
    {
        _mediaImageView = [UIImageView newAutoLayoutView];
        _mediaImageView.contentMode = UIViewContentModeScaleAspectFill;
        _mediaImageView.image = [self retrieveImageFromMedia:self.media];
    }
    
    return _mediaImageView;
}

- (UIBarButtonItem *)trashBarButtonItem
{
    if (!_trashBarButtonItem)
    {
        _trashBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                            target:self
                                                                            action:@selector(trashButtonPressed:)];
    }
    
    return _trashBarButtonItem;
}

#pragma mark - Image

- (UIImage *)retrieveImageFromMedia:(CFEMedia *)media
{
    NSData *imageData = nil;
    
    switch (media.location.integerValue)
    {
        case CFEMediaLocationCache:
        {
            imageData = [NSFileManager cfm_retrieveDataFromCacheDirectoryWithPath:media.name];
            
            break;
        }
        case CFEMediaLocationDocuments:
        {
            imageData = [NSFileManager cfm_retrieveDataFromDocumentsDirectoryWithPath:media.name];
            
            break;
        }
    }
    
    return [[UIImage alloc] initWithData:imageData];
}

#pragma mark - ButtonActions

- (void)trashButtonPressed:(UIBarButtonItem *)sender
{
    switch (self.media.location.integerValue)
    {
        case CFEMediaLocationCache:
        {
            [NSFileManager cfm_deleteDataFromCacheDirectoryWithPath:self.media.name];
            
            break;
        }
        case CFEMediaLocationDocuments:
        {
            [NSFileManager cfm_deleteDataFromDocumentDirectoryWithPath:self.media.name];
            
            break;
        }
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mediaID MATCHES %@", self.media.mediaID];
    
    [[CDSServiceManager sharedInstance].mainManagedObjectContext cds_deleteEntriesForEntityClass:[CFEMedia class]
                                                                                       predicate:predicate];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
