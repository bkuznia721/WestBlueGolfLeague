#import "WBTeamMatchup.h"
#import "WBCoreDataManager.h"

@interface WBTeamMatchup ()

@end

@implementation WBTeamMatchup

+ (WBTeamMatchup *)createTeamMatchupBetweenTeam:(WBTeam *)team1 andTeam:(WBTeam *)team2 forWeek:(WBWeek *)week {
	WBTeamMatchup *newTeamMatchup = [NSEntityDescription insertNewObjectForEntityForName:@"WBTeamMatchup" inManagedObjectContext:[[self class] managedObjectContext]];
	newTeamMatchup.week = week;
	[newTeamMatchup addTeamsObject:team1];
	[newTeamMatchup addTeamsObject:team2];
	
	[[WBCoreDataManager sharedManager] saveContext];
	return newTeamMatchup;
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

@end
