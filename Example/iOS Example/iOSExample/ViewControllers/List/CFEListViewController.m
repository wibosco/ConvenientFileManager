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

#import "CFEPhoto.h"
#import "CFEPhotoTableViewCell.h"
#import "CFEPhotoViewController.h"

@interface CFEListViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *images;

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

#pragma mark - Subview

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame
                                                  style:UITableViewStylePlain];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[CFEPhotoTableViewCell class]
           forCellReuseIdentifier:[CFEPhotoTableViewCell reuseIdentifier]];
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

- (NSArray *)images
{
    if (!_images)
    {
        NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"createdDate"
                                                                   ascending:YES];
        
        _images = [[CDSServiceManager sharedInstance].managedObjectContext cds_retrieveEntriesForEntityClass:[CFEPhoto class]
                                                                                             sortDescriptors:@[dateSort]];
    }
    
    return _images;
}

- (void)saveImageToDisk:(UIImage *)image
{
    CFEPhoto *photo = [NSEntityDescription cds_insertNewObjectForEntityForClass:[CFEPhoto class]
                                                         inManagedObjectContext:[CDSServiceManager sharedInstance].managedObjectContext];
    
    photo.photoID = [NSUUID UUID].UUIDString;
    photo.name = [NSString stringWithFormat:@"Image %@", @(self.images.count)];
    photo.location = @(arc4random_uniform(2));
    photo.createdDate = [NSDate date];
    
    [[CDSServiceManager sharedInstance].managedObjectContext save:nil];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    switch (photo.location.integerValue)
    {
        case CFEPhotoLocationCache:
        {
            [NSFileManager cfm_saveData:imageData
                   toCacheDirectoryPath:photo.name];
            
            break;
        }
        case CFEPhotoLocationDocuments:
        {
            [NSFileManager cfm_saveData:imageData
               toDocumentsDirectoryPath:photo.name];
            
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
    return self.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CFEPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CFEPhotoTableViewCell reuseIdentifier]
                                                                  forIndexPath:indexPath];
    
    CFEPhoto *image = self.images[indexPath.row];
    
    cell.nameLabel.text = image.name;
    cell.directoryLocationLabel.text = [image locationString];
    
    [cell layoutByApplyingConstraints];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CFEPhoto *image = self.images[indexPath.row];
    
    CFEPhotoViewController *viewController = [[CFEPhotoViewController alloc] initWithImage:image];
    
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}

#pragma mark - PhotoPicker

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
    
    self.images = nil;
    
    [self.tableView reloadData];
    
    [picker dismissViewControllerAnimated:YES
                               completion:nil];
}

@end
