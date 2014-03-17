//
//  WBMultiFetchDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/13/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBMultiFetchDataSource.h"
#import "WBSectionDataSource.h"

@interface WBMultiFetchDataSource ()

@property (weak, nonatomic) UIViewController *viewController;

@property (strong, nonatomic) NSMutableArray *sectionDataSources;

@end

@implementation WBMultiFetchDataSource

+ (id)dataSourceWithViewController:(UIViewController *)aViewController {
	return [[self alloc] initWithViewController:aViewController];
}

- (id)initWithViewController:(UIViewController *)aViewController {
	self = [super init];
	if (self) {
		self.viewController = aViewController;
	}
	return self;
}

- (void)beginFetch {
	/*NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		ALog(@"Unresolved error %@, %@", error, [error userInfo]);
		[WBCoreDataManager logError:error];
	}*/
	for (WBSectionDataSource *dataSource in self.sectionDataSources) {
		[dataSource beginFetch];
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionDataSources.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionDataSources[section] tableView:tableView numberOfRowsInSection:1];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.sectionDataSources[indexPath.section] tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:1]];
}

@end