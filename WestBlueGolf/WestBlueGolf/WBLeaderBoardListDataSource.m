//
//  WBLeaderBoardListDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/6/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBLeaderBoardListDataSource.h"
#import "WBLeaderBoardListCell.h"
#import "WBLeaderBoardTableViewController.h"

#define SORT_KEY @"tablePriority"

@interface WBLeaderBoardListDataSource ()

@property (assign, nonatomic) BOOL isPlayerBoard;

@end

@implementation WBLeaderBoardListDataSource

+ (id)dataSourceWithViewController:(UIViewController *)aViewController playerBoard:(BOOL)playerBoard {
	return [[self alloc] initWithViewController:aViewController playerBoard:playerBoard];
}

- (id)initWithViewController:(UIViewController *)aViewController playerBoard:(BOOL)playerBoard {
	self = [super initWithViewController:aViewController];
	if (self) {
		self.isPlayerBoard = playerBoard;
	}
	return self;
}

#pragma mark - WBEntityDataSource methods to implement

- (NSString *)cellIdentifier {
	static NSString *CellIdentifier = @"LeaderBoardListCell";
	return CellIdentifier;
}

- (NSString *)entityName {
	return @"WBLeaderBoard";
}

- (NSString *)sectionNameKeyPath {
	return nil;
}

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"isPlayerBoard = %@", [NSNumber numberWithBool:self.isPlayerBoard]];
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY ascending:YES];
	return @[sortOrderDescriptor];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBLeaderBoard *leaderBoard = (WBLeaderBoard *)object;
	WBLeaderBoardListCell *leaderBoardCell = (WBLeaderBoardListCell *)cell;
	[leaderBoardCell configureCellForLeaderBoard:leaderBoard];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.viewController.splitViewController) {
		UIViewController *vc = nil;
		for (UINavigationController *nc in self.viewController.splitViewController.viewControllers) {
			vc = [nc topViewController];
			if (vc != self.viewController) {
                WBLeaderBoard *board = [[(WBEntityDataSource *)tableView.dataSource fetchedResultsController] objectAtIndexPath:tableView.indexPathForSelectedRow];
                [(WBLeaderBoardTableViewController *)vc setSelectedLeaderboard:board];
			}
		}
	}
	
	//[tableView deselectRowAtIndexPath:tableView.indexPathForSelectedRow animated:YES];
}

@end
