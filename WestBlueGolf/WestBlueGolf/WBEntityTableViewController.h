//
//  WBEntityTableViewController.h
//  WestBlueGolf
//
//  Created by Michael Harlow on 2/23/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

@interface WBEntityTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (NSString *)cellIdentifier;
- (NSString *)entityName;
- (NSArray *)sortDescriptorsForFetch;
- (NSString *)sectionNameKeyPath;
- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object;

@end
