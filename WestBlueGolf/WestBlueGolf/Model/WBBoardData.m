#import "WBBoardData.h"
#import "WBCoreDataManager.h"
#import "WBLeaderBoard.h"
#import "WBYear.h"

@interface WBBoardData ()
@end

@implementation WBBoardData

+ (WBBoardData *)createBoardDataForEntity:(WBPeopleEntity *)entity
							  leaderBoard:(WBLeaderBoard *)leaderBoard
									value:(CGFloat)value
									 rank:(NSInteger)rank
									 year:(WBYear *)year {
	if (!entity) {
		ALog(@"No people sent to boardData contstructor");
		return nil;
	}
	
	WBBoardData *data = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] context]];
	data.valueValue = value;
	data.rankValue = rank;
	
	[entity addBoardDataObject:data];
	[leaderBoard addBoardDataObject:data];
	[year addBoardDataObject:data];
	return data;
}

- (NSString *)rankString {
	if ([self.peopleEntity isLeagueAverage]) {
		return @"";
	}
	return [NSString stringWithFormat:@"#%@", self.rank];
}

+ (WBBoardData *)findWithBoardKey:(NSString *)key peopleEntity:(WBPeopleEntity *)entity {
	NSArray *data = [self findWithPredicate:[NSPredicate predicateWithFormat:@"leaderBoard.key = %@ && peopleEntity = %@ && year.value = %@", key, entity, [WBYear thisYear]]];
	return [data firstObject];
}

@end
