//
//  FirstViewController.m
//  iOSExample
//
//  Created by Boles on 17/01/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import "CFEListViewController.h"

#import <CoreDataServices/CDSServiceManager.h>
#import <CoreDataServices/NSManagedObjectContext+CDSRetrieval.h>
#import <CoreDataServices/NSEntityDescription+CDSEntityDescription.h>
#import <ConvenientFileManager/NSFileManager+CFMCache.h>
#import <ConvenientFileManager/NSFileManager+CFMDocuments.h>

#import "CFEMedia.h"
#import "CFEMediaTableViewCell.h"
#import "CFEMediaViewController.h"

@interface CFEListViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *medias;

@property (nonatomic, strong) UIBarButtonItem *imagePickerBarButtonItem;

@property (nonatomic, strong) UIImagePickerController *imagePickerViewController;

- (void)imagePickerButtonPressed:(UIBarButtonItem *)sender;
- (void)saveImageToDisk:(UIImage *)image;

@end

@implementation CFEListViewController

#pragma mark - ViewLifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*-------------------*/
    
    self.title = @"Images";
    
    /*-------------------*/
    
    self.navigationItem.rightBarButtonItem = self.imagePickerBarButtonItem;
    
    /*-------------------*/
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.medias = nil;
    
    [self.tableView reloadData];
}

#pragma mark - Subview

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame
                                                  style:UITableViewStylePlain];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[CFEMediaTableViewCell class]
           forCellReuseIdentifier:[CFEMediaTableViewCell reuseIdentifier]];
    }
    
    return _tableView;
}

- (UIBarButtonItem *)imagePickerBarButtonItem
{
    if (!_imagePickerBarButtonItem)
    {
        _imagePickerBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                  target:self
                                                                                  action:@selector(imagePickerButtonPressed:)];
    }
    
    return _imagePickerBarButtonItem;
}

#pragma mark - Image

- (NSArray *)medias
{
    if (!_medias)
    {
        NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"createdDate"
                                                                   ascending:YES];
        
        _medias = [[CDSServiceManager sharedInstance].mainManagedObjectContext cds_retrieveEntriesForEntityClass:[CFEMedia class]
                                                                                             sortDescriptors:@[dateSort]];
    }
    
    return _medias;
}

- (void)saveImageToDisk:(UIImage *)image
{
    CFEMedia *media = [NSEntityDescription cds_insertNewObjectForEntityForClass:[CFEMedia class]
                                                         inManagedObjectContext:[CDSServiceManager sharedInstance].mainManagedObjectContext];
    
    media.mediaID = [NSUUID UUID].UUIDString;
    media.name = [NSString stringWithFormat:@"Image %@", @(self.medias.count)];
    media.location = @(arc4random_uniform(2));
    media.createdDate = [NSDate date];
    
    [[CDSServiceManager sharedInstance].mainManagedObjectContext save:nil];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    switch (media.location.integerValue)
    {
        case CFEMediaLocationCache:
        {
            [NSFileManager cfm_saveData:imageData
                   toCacheDirectoryPath:media.name];
            
            break;
        }
        case CFEMediaLocationDocuments:
        {
            [NSFileManager cfm_saveData:imageData
               toDocumentsDirectoryPath:media.name];
            
            break;
        }
    }
}

- (UIImagePickerController *)imagePickerViewController
{
    if (!_imagePickerViewController)
    {
        _imagePickerViewController = [[UIImagePickerController alloc] init];
        _imagePickerViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
        _imagePickerViewController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        _imagePickerViewController.delegate = self;
    }
    
    return _imagePickerViewController;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.medias.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CFEMediaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CFEMediaTableViewCell reuseIdentifier]
                                                                  forIndexPath:indexPath];
    
    CFEMedia *media = self.medias[indexPath.row];
    
    cell.nameLabel.text = media.name;
    cell.directoryLocationLabel.text = [media locationString];
    
    [cell layoutByApplyingConstraints];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CFEMedia *media = self.medias[indexPath.row];
    
    CFEMediaViewController *viewController = [[CFEMediaViewController alloc] initWithMedia:media];
    
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}

#pragma mark - ButtonActions

- (void)imagePickerButtonPressed:(UIBarButtonItem *)sender
{
    [self presentViewController:self.imagePickerViewController
                       animated:YES
                     completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self saveImageToDisk:image];
    
    self.medias = nil;
    
    [self.tableView reloadData];
    
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
}

@end
