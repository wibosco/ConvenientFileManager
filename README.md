[![Build Status](https://travis-ci.org/wibosco/ConvenientFileManager.svg)](https://travis-ci.org/wibosco/ConvenientFileManager)
[![Version](https://img.shields.io/cocoapods/v/ConvenientFileManager.svg?style=flat)](http://cocoapods.org/pods/ConvenientFileManager)
[![License](https://img.shields.io/cocoapods/l/ConvenientFileManager.svg?style=flat)](http://cocoapods.org/pods/ConvenientFileManager)
[![Platform](https://img.shields.io/cocoapods/p/ConvenientFileManager.svg?style=flat)](http://cocoapods.org/pods/ConvenientFileManager)

ConvenientFileManager is a suite of categories to ease using `NSFileManager` for common tasks.

##Installation via [CocoaPods](https://cocoapods.org/)

To integrate ConvenientFileManager into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

pod 'ConvenientFileManager'
```

Then, run the following command:

```bash
$ pod install
```

> CocoaPods 0.39.0+ is required to build ConvenientFileManager.

##Usage

ConvenientFileManager comes with convenience methods for the `Documents` (`NSFileManager+CFMDocuments.h`) and `Cache` (`NSFileManager+CFMCache`) folders in your app sandbox. These methods will prefix the relevant path on the one provided for accessing data however you may already have the absolute path and wish to use that instead, in which case you should use `NSFileManager+CFMPersistence`.

####Saving

```objc
#import <ConvenientFileManager/NSFileManager+CFMCache.h>
#import <ConvenientFileManager/NSFileManager+CFMDocuments.h>

....

- (void)saveImageToDisk:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);
    
    switch (self.media.location.integerValue)
    {
        case CFEMediaLocationCache:
        {
            [NSFileManager cfm_saveData:imageData
                   toCacheDirectoryPath:self.media.name];
            
            break;
        }
        case CFEMediaLocationDocuments:
        {
            [NSFileManager cfm_saveData:imageData
               toDocumentsDirectoryPath:self.media.name];
            
            break;
        }
    }
}
```

####Retrieving

```objc
#import <ConvenientFileManager/NSFileManager+CFMCache.h>
#import <ConvenientFileManager/NSFileManager+CFMDocuments.h>

....

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
```

####Deleting

```objc
#import <ConvenientFileManager/NSFileManager+CFMCache.h>
#import <ConvenientFileManager/NSFileManager+CFMDocuments.h>

....

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
}
```

####Exists

**Synchronously**

```objc
#import <ConvenientFileManager/NSFileManager+CFMCache.h>
#import <ConvenientFileManager/NSFileManager+CFMDocuments.h>

....

- (BOOL)mediaAssetHasBeenDownloaded:(CFEMedia *)media
{
	BOOL mediaAssetHasBeenDownloaded = NO;

    switch (self.media.location.integerValue)
    {
        case CFEMediaLocationCache:
        {
            mediaAssetHasBeenDownloaded = [NSFileManager cfm_cacheDirectoryPathForResourceWithPath:self.media.name];
            
            break;
        }
        case CFEMediaLocationDocuments:
        {
            mediaAssetHasBeenDownloaded = [NSFileManager cfm_fileExistsInDocumentsDirectory:self.media.name];
            
            break;
        }
    }
    
    return mediaAssetHasBeenDownloaded;
}
```

**Asynchronously**

```objc

#import <ConvenientFileManager/NSFileManager+CFMPersistence.h>

...

[NSFileManager cfm_fileExistsAtPath:self.media.absoluteLocalPath
                         completion:^(BOOL fileExists)
 {
     if (!fileExists)
     {   
         [CFMMediaAPIManager retrieveAssetForMedia:media
                                           success:success
                                           failure:failure];
     }
     else
     {
         if (failure)
         {
             failure(error);
         }
     }
 }];

```


> ConvenientFileManager comes with an [example project](https://github.com/wibosco/ConvenientFileManager/tree/master/Example/iOS%20Example) to provide more details than listed above.

> ConvenientFileManager uses [modules](http://useyourloaf.com/blog/modules-and-precompiled-headers.html) for importing/using frameworks - you will need to enable this in your project.

##Found an issue?

Please open a [new Issue here](https://github.com/wibosco/ConvenientFileManager/issues/new) if you run into a problem specific to ConvenientFileManager, have a feature request, or want to share a comment. Note that general NSFileManager questions should be asked on [Stack Overflow](http://stackoverflow.com).

Pull requests are encouraged and greatly appreciated! Please try to maintain consistency with the existing [code style](http://www.williamboles.me/objective-c-coding-style). If you're considering taking on significant changes or additions to the project, please communicate in advance by opening a new Issue. This allows everyone to get onboard with upcoming changes, ensures that changes align with the project's design philosophy, and avoids duplicated work.