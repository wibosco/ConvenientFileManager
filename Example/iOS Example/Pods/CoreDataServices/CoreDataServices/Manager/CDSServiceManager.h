//
//  CoreDataServices.h
//  CoreDataServices
//
//  Created by William Boles on 15/04/2014.
//  Copyright (c) 2014 Boles. All rights reserved.
//

@import CoreData;
@import Foundation;
@import UIKit;

/**
 A singleton manager that is responsible for setting up a typical (one context) core data stack and providing access to the main queue context. Also contains some convenience methods for interacting with that main queue context.
 */
@interface CDSServiceManager : NSObject

/*
 Context that is used as the default `NSManagedObjectContext` instance.
 
 This context is should only be used on the main thread - configured as `NSMainQueueConcurrencyType`.
 
 @return NSManagedObjectContext instance.
 */
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

/*
 Returns the global CDSServiceManager instance.
 
 @return CDSServiceManager shared instance.
 */
+ (instancetype)sharedInstance;

/**
 Sets up the core data stack using a model with the filename.
 
 @param name - filename of the model to load.
 */
- (void)setupModelURLWithModelName:(NSString *)name;

/*
 Saves the managed object context that is set via the `managedObjectContext` property.
 */
- (void)saveManagedObjectContext;

/**
 Destroys all data from core data, tears down the stack and builds it up again.
 */
- (void)reset;

/**
 Destroys all data from core data and tears down the stack.
 */
- (void)clear;

@end
