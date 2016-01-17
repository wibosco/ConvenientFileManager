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

#import "CFEPhoto.h"
#import "CFEPhotoTableViewCell.h"
#import "CFEPhotoViewController.h"

@interface CFEListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, strong) UIBarButtonItem *photoPickerBarButtonItem;

- (void)photoPickerButtonPressed:(UIBarButtonItem *)sender;

@end

@implementation CFEListViewController

#pragma mark - ViewLifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*-------------------*/
    
    self.title = @"Photos";
    
    /*-------------------*/
    
    self.navigationItem.rightBarButtonItem = self.photoPickerBarButtonItem;
    
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

- (UIBarButtonItem *)photoPickerBarButtonItem
{
    if (!_photoPickerBarButtonItem)
    {
        _photoPickerBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                  target:self
                                                                                  action:@selector(photoPickerButtonPressed:)];
    }
    
    return _photoPickerBarButtonItem;
}

#pragma mark - Photos

- (NSArray *)photos
{
    if (!_photos)
    {
        NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"createdDate"
                                                                   ascending:YES];
        
        _photos = [[CDSServiceManager sharedInstance].managedObjectContext cds_retrieveEntriesForEntityClass:[CFEPhoto class]
                                                                                             sortDescriptors:@[dateSort]];
    }
    
    return _photos;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CFEPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[CFEPhotoTableViewCell reuseIdentifier]
                                                                 forIndexPath:indexPath];
    
    CFEPhoto *photo = self.photos[indexPath.row];

    cell.nameLabel.text = photo.name;
    cell.directoryLocationLabel.text = [photo locationString];
    
    [cell layoutByApplyingConstraints];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CFEPhoto *photo = self.photos[indexPath.row];
    
    CFEPhotoViewController *viewController = [[CFEPhotoViewController alloc] initWithPhoto:photo];
    
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}

#pragma mark - Insert

- (void)photoPickerButtonPressed:(UIBarButtonItem *)sender
{

}

@end
