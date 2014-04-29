//
//  WBTeamResultsDataSource.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/12/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBTeamResultsDataSource.h"
#import "WBModels.h"
#import "WBResultTableViewCell.h"
#import "WBTeamProfileDataSource.h"

#define SORT_KEY_SECTION_1 @"week.date"

@implementation WBTeamResultsDataSource

- (WBTeam *)selectedTeam {
	WBTeamProfileDataSource *multi = (WBTeamProfileDataSource *)self.parentDataSource;
	return multi.selectedTeam;
}

- (NSString *)cellIdentifierForObject:(NSManagedObject *)object {
	static NSString *CellIdentifier = @"TeamResultsCell";
	static NSString *IncompleteCellIdentifier = @"IncompleteTeamResultsCell";

	WBTeamMatchup *matchup = (WBTeamMatchup *)object;
	return matchup.matchCompleteValue ? CellIdentifier : IncompleteCellIdentifier;
}

- (NSString *)entityName {
	return @"WBTeamMatchup";
}

- (BOOL)shouldExpand {
	return YES;
}

- (NSArray *)sortDescriptorsForFetch {
	NSSortDescriptor *sortOrderDescriptor = [[NSSortDescriptor alloc] initWithKey:SORT_KEY_SECTION_1 ascending:NO];
	return @[sortOrderDescriptor];
}

- (NSPredicate *)fetchPredicate {
	return [NSPredicate predicateWithFormat:@"%@ IN teams && week.year = %@", [self selectedTeam], [WBYear thisYear]];
}

- (void)configureCell:(UITableViewCell *)cell
		   withObject:(NSManagedObject *)object {
	WBTeamMatchup *matchup = (WBTeamMatchup *)object;
	WBResultTableViewCell *resultCell = (WBResultTableViewCell *)cell;
	[resultCell configureCellForResultsOfTeam:self.selectedTeam matchup:matchup];
}

@end
