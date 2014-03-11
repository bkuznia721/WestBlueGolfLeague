//
//  WBManagedObject.h
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/10/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@interface WBManagedObject : NSManagedObject

+ (NSManagedObjectContext *)context;
+ (NSFetchRequest *)fetchAllRequest;

+ (WBManagedObject *)createEntity;
- (void)deleteEntity;

+ (NSArray *)findAll;
+ (NSArray *)findAllSortedBy:(NSString *)property ascending:(BOOL)asc;
+ (NSArray *)findWithPredicate:(NSPredicate *)predicate;
+ (NSArray *)findWithPredicate:(NSPredicate *)predicate sortedBy:(NSArray *)sortDescriptors;
+ (WBManagedObject *)findFirstRecordWithPredicate:(NSPredicate *)predicate sortedBy:(NSArray *)sortDescriptors;

+ (NSUInteger)countAll;
+ (NSUInteger)countWithPredicate:(NSPredicate *)predicate;

+ (Class)dataManager;

@end
