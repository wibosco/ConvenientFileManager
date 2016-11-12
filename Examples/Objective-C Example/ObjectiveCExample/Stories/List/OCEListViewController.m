//
//  ViewController.m
//  ObjectiveCExample
//
//  Created by William Boles on 12/11/2016.
//  Copyright © 2016 Boles. All rights reserved.
//

#import "OCEListViewController.h"
#import <ConvenientFileManager/ConvenientFileManager-Swift.h>
#import "OCEMediaTableViewCell.h"
#import "OCEMedia.h"

@interface OCEListViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *addMediaBarButtonItem;

@property (nonatomic, strong) NSMutableArray<OCEMedia *>* images;
@property (nonatomic, strong) UIImagePickerController *imagePickerViewController;

@end

@implementation OCEListViewController

#pragma mark - Images

- (NSArray<OCEMedia *> *)images {
    if (!_images) {
        _images = [[NSMutableArray alloc] init];
    }
    
    return _images;
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

#pragma mark - ViewLifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 100.0f;
    
    self.addMediaBarButtonItem.target = self;
    self.addMediaBarButtonItem.action = @selector(addMediaButtonPressed:);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OCEMediaTableViewCell *cell = (OCEMediaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"MediaTableViewCell"
                                                                                           forIndexPath:indexPath];
    OCEMedia *media = self.images[indexPath.row];
    
    cell.locationLabel.text = [self mediaLocation:media.location];
    cell.mediaImageView.image = [self loadImageFromMediaSavedLocation:media];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OCEMedia *media = self.images[indexPath.row];
    switch (media.location) {
        case OCEMediaLocationCache:
            [NSFileManager cfm_deleteDataFromCacheDirectoryWithRelativePath:media.name];
            break;
        case OCEMediaLocationDocuments:
            [NSFileManager cfm_deleteDataFromDocumentsDirectoryWithRelativePath:media.name];
            break;
    }
    
    [self.images removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

#pragma mark - ButtonActions

- (void)addMediaButtonPressed:(UIBarButtonItem *)sender {
    [self presentViewController:self.imagePickerViewController animated:YES completion:nil];
}

#pragma mark - Media

- (NSString *)mediaLocation:(OCEMediaLocation)location {
    switch (location) {
        case OCEMediaLocationCache:
            return @"Cache";
        case OCEMediaLocationDocuments:
            return @"Documents";
    }
}

- (UIImage *)loadImageFromMediaSavedLocation:(OCEMedia *)media {
    NSData *imageData = nil;
    
    switch (media.location) {
        case OCEMediaLocationCache:
            imageData = [NSFileManager cfm_retrieveDataFromCacheDirectoryWithRelativePath:media.name];
            break;
        case OCEMediaLocationDocuments:
            imageData = [NSFileManager cfm_retrieveDataFromDocumentsDirectoryWithRelativePath:media.name];
            break;
    }
    
    return [UIImage imageWithData:imageData];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    OCEMedia *media = [[OCEMedia alloc] init];
    
    media.name = [NSUUID UUID].UUIDString;
    media.location = arc4random_uniform(2);
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    switch (media.location) {
        case OCEMediaLocationCache:
            [NSFileManager cfm_writeData:imageData toCacheDirectoryWithRelativePath:media.name];
            break;
        case OCEMediaLocationDocuments:
            [NSFileManager cfm_writeData:imageData toDocumentsDirectoryWithRelativePath:media.name];
            break;
    }

    [self.images addObject:media];
    [self.tableView reloadData];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
