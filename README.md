[![Build Status](https://travis-ci.org/wibosco/ConvenientFileManager.svg)](https://travis-ci.org/wibosco/ConvenientFileManager)
[![Version](https://img.shields.io/cocoapods/v/ConvenientFileManager.svg?style=flat)](http://cocoapods.org/pods/ConvenientFileManager)
[![License](https://img.shields.io/cocoapods/l/ConvenientFileManager.svg?style=flat)](http://cocoapods.org/pods/ConvenientFileManager)
[![Platform](https://img.shields.io/cocoapods/p/ConvenientFileManager.svg?style=flat)](http://cocoapods.org/pods/ConvenientFileManager)
[![CocoaPods](https://img.shields.io/cocoapods/metrics/doc-percent/ConvenientFileManager.svg)](http://cocoapods.org/pods/ConvenientFileManager)

ConvenientFileManager is a suite of categories to ease using `(NS)FileManager` for common tasks.

## Installation via [CocoaPods](https://cocoapods.org/)

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

## Usage

ConvenientFileManager comes with a suite of convenience methods for the `Documents` (`FileManager+Documents`) and `Cache` (`FileManager+Cache`) directories in your app's sandbox. These extensions/categories provide a streamlined interface for reading, writing and deleting data from these directories over what `(NS)FileManager` provides by removing some of the boilerplate around which directory you are using.

Even if you already have the absolute path for reading, writing or deleting data you have access to the same suite of methods by using `FileManager+Persistence`.

#### Writing/Saving

###### Swift

```swift
func writeImageToDisk(image: UIImage) {
    if let imageData = UIImagePNGRepresentation(image) {
        switch self.media.location.integerValue {
        case .cache:
            FileManager.writeToCacheDirectory(data: imageData, relativePath: self.media.name)
        case .documents:
            FileManager.writeDataToDocumentsDirectory(data: imageData, relativePath: self.media.name)
        }
    }
}
```

###### Objective-C

```objc
- (void)writeImageToDisk:(UIImage *)image
{
    NSData *imageData = UIImagePNGRepresentation(image);

    switch (self.media.location.integerValue)
    {
        case CFEMediaLocationCache:
        {
            [NSFileManager cfm_writeData:imageData toCacheDirectoryWithRelativePath:self.media.name];

            break;
        }
        case CFEMediaLocationDocuments:
        {
            [NSFileManager cfm_writeData:imageData toDocumentsDirectoryWithRelativePath:self.media.name];

            break;
        }
    }
}
```

#### Retrieving

###### Swift

```swift
func retrieveImageFromMedia(media: CFEMedia) -> UIImage? {
    var retrievedData: NSData?

    switch media.location.integerValue {
    case .cache:
        retrievedData = FileManager.retrieveDataFromCacheDirectory(relativePath: media.name)
    case .documents:
        retrievedData = FileManager.retrieveDataFromDocumentsDirectory(relativePath: media.name)
    }

    guard let unwrappedRetrievedData = retrievedData else {
        return nil
    }

    return UIImage.init(data: unwrappedRetrievedData)
}
```

###### Objective-C

```objc
- (UIImage *)retrieveImageFromMedia:(CFEMedia *)media
{
    NSData *imageData = nil;

    switch (media.location.integerValue)
    {
        case CFEMediaLocationCache:
        {
            imageData = [NSFileManager cfm_retrieveDataFromCacheDirectoryWithRelativePath:media.name];

            break;
        }
        case CFEMediaLocationDocuments:
        {
            imageData = [NSFileManager cfm_retrieveDataFromDocumentsDirectoryWithRelativePath:media.name];

            break;
        }
    }

    return [[UIImage alloc] initWithData:imageData];
}
```

#### Deleting

###### Swift

```swift
func trashButtonPressed(sender: UIBarButtonItem) {
    switch self.media.location.integerValue {
    case .cache:
        FileManager.deleteDataFromCacheDirectory(relativePath: self.media.name)
    case .documents:
        FileManager.deleteDataFromDocumentsDirectory(relativePath: self.media.name)
    }
}
```

###### Objective-C

```objc
- (void)trashButtonPressed:(UIBarButtonItem *)sender
{
    switch (self.media.location.integerValue)
    {
        case CFEMediaLocationCache:
        {
            [NSFileManager cfm_deleteDataFromCacheDirectoryWithRelativePath:self.media.name];

            break;
        }
        case CFEMediaLocationDocuments:
        {
            [NSFileManager cfm_deleteDataFromDocumentDirectoryWithRelativePath:self.media.name];

            break;
        }
    }
}
```

#### Exists

**Synchronously**

###### Swift

```swift
func mediaAssetHasBeenDownloaded(media: CFEMedia) -> Bool {
    var mediaAssetHasBeenDownloaded = false

    switch self.media.location.integerValue {
    case .cache:
        mediaAssetHasBeenDownloaded = FileManager.fileExistsInCacheDirectory(relativePath: self.media.name)
    case .documents:
        mediaAssetHasBeenDownloaded = FileManager.fileExistsInDocumentsDirectory(relativePath: self.media.name)
    }

    return mediaAssetHasBeenDownloaded
}
```

###### Objective-C

```objc
- (BOOL)mediaAssetHasBeenDownloaded:(CFEMedia *)media
{
    BOOL mediaAssetHasBeenDownloaded = NO;

    switch (self.media.location.integerValue)
    {
        case CFEMediaLocationCache:
        {
            mediaAssetHasBeenDownloaded = [NSFileManager cfm_fileExistsInCacheDirectoryWithRelativePath:self.media.name];

            break;
        }
        case CFEMediaLocationDocuments:
        {
            mediaAssetHasBeenDownloaded = [NSFileManager cfm_fileExistsInCacheDirectoryWithRelativePath:self.media.name];

            break;
        }
    }

    return mediaAssetHasBeenDownloaded;
}
```

**Asynchronously**

###### Swift

```swift
FileManager.fileExistsAtPath(absolutePath: self.media.absoluteLocalPath) { (fileExists) in
    if (!fileExists) {
        //Yay!
    } else {
        //Boo!
    }
}
```

###### Objective-C

```objc
[NSFileManager cfm_fileExistsAtAbsolutePath:self.media.absoluteLocalPath
                                 completion:^(BOOL fileExists)
 {
     if (!fileExists)
     {   
        //Yay!
     }
     else
     {
        //Boo!
     }
 }];
```


> ConvenientFileManager comes with an [example project](https://github.com/wibosco/ConvenientFileManager/tree/master/Examples/Swift%20Example) to provide more details than listed above.

> ConvenientFileManager uses [modules](http://useyourloaf.com/blog/modules-and-precompiled-headers.html) for importing/using frameworks - you will need to enable this in your project.

## Found an issue?

Please open a [new Issue here](https://github.com/wibosco/ConvenientFileManager/issues/new) if you run into a problem specific to ConvenientFileManager, have a feature request, or want to share a comment. Note that general NSFileManager questions should be asked on [Stack Overflow](http://stackoverflow.com).

Pull requests are encouraged and greatly appreciated! Please try to maintain consistency with the existing code style. If you're considering taking on significant changes or additions to the project, please communicate in advance by opening a new Issue. This allows everyone to get onboard with upcoming changes, ensures that changes align with the project's design philosophy, and avoids duplicated work.
