#import "WBPlayer.h"
#import "WBCoreDataManager.h"
#import "WBCourse.h"
#import "WBMatch.h"
#import "WBPlayerYearData.h"
#import "WBResult.h"
#import "WBTeam.h"
#import "WBTeamMatchup.h"
#import "WBWeek.h"
#import "WBYear.h"

#define kNoShowPlayerName @"xx No Show xx"

@interface WBPlayer ()

@end

@implementation WBPlayer

+ (WBPlayer *)createPlayerWithName:(NSString *)name
				   currentHandicap:(NSInteger)currentHandicap
							onTeam:(WBTeam *)currentTeam {
	WBPlayer *newPlayer = (WBPlayer *)[WBPeopleEntity baseCreatePeopleWithName:name entityName:[self entityName]];
	newPlayer.currentHandicapValue = currentHandicap;
	newPlayer.meValue = NO;
	newPlayer.favoriteValue = NO;
	
	if (currentTeam) {
		[currentTeam addPlayersObject:newPlayer];
	}
	
	//[WBCoreDataManager saveContext];
	return newPlayer;
}

- (void)deletePlayer {
	[[[self class] managedObjectContext] deleteObject:self];
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

- (NSString *)shortName {
	NSString *firstName = [self firstName];
	NSString *shortFirstName = [NSString stringWithFormat:@"%@.", [firstName substringToIndex:1]];
	return [self.name stringByReplacingOccurrencesOfString:firstName withString:shortFirstName];
}

- (void)setPlayerToMe {
	self.meValue = YES;
	self.favoriteValue = YES;
}

- (void)setPlayerToNotMe {
	self.meValue = NO;
}

+ (WBPlayer *)noShowPlayer {
	return [WBPlayer playerWithName:kNoShowPlayerName];
}

+ (void)createNoShowPlayer {
	[WBPlayer createPlayerWithName:kNoShowPlayerName currentHandicap:25 onTeam:nil];
}

+ (WBPlayer *)playerWithName:(NSString *)name {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
	NSArray *players = [[WBCoreDataManager class] findEntity:[[self class] entityName] withPredicate:predicate sorts:nil];
	return [players lastObject];
}

+ (NSArray *)fetchAllPlayersWithSorts:(NSArray *)sorts {
	NSFetchRequest *request = [WBCoreDataManager fetchAllRequestWithEntityName:[[self class] entityName]];
	request.sortDescriptors = sorts;
	NSError *error = nil;
	NSArray *results = [[self managedObjectContext] executeFetchRequest:request error:&error];
	if (error) {
		[[WBCoreDataManager class] performSelector:@selector(logError:) withObject:error];
	}
	return results;
}

- (NSString *)firstName {
	return [self.name componentsSeparatedByString:@" "][0];
}

+ (WBPlayer *)me {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"me = 1"];
	NSArray *players = [[WBCoreDataManager class] findEntity:[[self class] entityName] withPredicate:predicate sorts:nil];
	return [players lastObject];
}

- (NSString *)record {
	NSArray *record = [self recordForYear:[WBYear thisYear]];
	BOOL hasTies = record[2] && [(NSNumber *)record[2] integerValue] != 0;
	return [NSString stringWithFormat:@"%@-%@%@%@", record[0], record[1], hasTies ? @"-" : @"", hasTies ? record[2] : @""];
}

- (CGFloat)recordRatioForYear:(WBYear *)year {
	NSArray *record = [self recordForYear:year];
	CGFloat totalWins = [(NSNumber *)record[0] floatValue] + [(NSNumber *)record[2] floatValue] / 2.0f;
	CGFloat totalWeeks = [(NSNumber *)record[0] floatValue] + [(NSNumber *)record[1] floatValue] + [(NSNumber *)record[2] floatValue];
	return totalWeeks > 0 ? totalWins / totalWeeks : 0.0f;
}

- (NSArray *)recordForYear:(WBYear *)year {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"match.teamMatchup.week.year = %@ && player = %@", year, self];
	NSArray *results = [[WBCoreDataManager class] findEntity:[WBResult entityName] withPredicate:predicate sorts:nil];
	NSInteger wins = 0;
	NSInteger losses = 0;
	NSInteger ties = 0;

	for (WBResult *result in results) {
		if ([result wasWin]) {
			wins++;
		} else if ([result wasLoss]) {
			losses++;
		} else {
			ties++;
		}
	}

	return @[[NSNumber numberWithInteger:wins], [NSNumber numberWithInteger:losses], [NSNumber numberWithInteger:ties]];
}

- (NSString *)currentHandicapString {
	NSInteger handi = self.currentHandicapValue;
	BOOL isPositive = handi > 0;
	return [NSString stringWithFormat:@"%@%ld", isPositive ? @"+" : @"", (long)handi];
}

- (NSInteger)lowRoundForYear:(WBYear *)year {
	NSFetchRequest *request = [WBCoreDataManager fetchAllRequestWithEntityName:[WBResult entityName]];
	[request setPredicate:[NSPredicate predicateWithFormat:@"match.teamMatchup.week.year = %@ && player = %@", year, self]];
	request.fetchLimit = 1;
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"score" ascending:YES]];
	
	NSError *error = nil;
	NSArray *results = [[[self class] managedObjectContext] executeFetchRequest:request error:&error];
	if (error) {
		[[WBCoreDataManager class] performSelector:@selector(logError:) withObject:error];
	}
	
	if (!results || results.count == 0) {
		return 99;
	}
	
	return [(WBResult *)[results firstObject] scoreValue];
}

- (NSString *)lowRoundString {
	return [NSString stringWithFormat:@"%ld", (long)[self lowRoundForYear:[WBYear thisYear]]];
}

- (NSInteger)lowNetForYear:(WBYear *)year {
	NSArray *results = [[self class] resultsForPlayer:self inYear:[WBYear thisYear]];
	if (results && results.count > 0) {
		NSInteger lowNet = 100;
		for (WBResult *result in results) {
			NSInteger netScoreDifference = [result netScoreDifference];
			if (netScoreDifference < lowNet) {
				lowNet = netScoreDifference;
			}
		}
		
		return lowNet;
	} else {
		return 10;
	}
}

- (NSString *)lowNetString {
	return [NSString stringWithFormat:@"%ld", (long)[self lowNetForYear:[WBYear thisYear]]];
}

- (CGFloat)averagePointsInYear:(WBYear *)year {
	NSArray *results = [[self class] resultsForPlayer:self inYear:[WBYear thisYear]];
	if (results && results.count > 0) {
		NSInteger totalPoints = 0;
		for (WBResult *result in results) {
			totalPoints += result.pointsValue;
		}
	
		return (CGFloat)totalPoints / (CGFloat)results.count;
	} else {
		return 0.0f;
	}
}

- (NSString *)averagePointsString {
	NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
	fmt.minimumFractionDigits = 1;
	NSNumber *avg = [NSNumber numberWithFloat:[self averagePointsInYear:[WBYear thisYear]]];
	return avg.floatValue != 0.0f ? [fmt stringFromNumber:avg] : @"0.0";
}

- (CGFloat)averageScoreInYear:(WBYear *)year {
	NSArray *results = [[self class] resultsForPlayer:self inYear:[WBYear thisYear]];
	if (results && results.count > 0) {
		NSInteger totalScore = 0;
		for (WBResult *result in results) {
			totalScore += (result.scoreValue - result.match.teamMatchup.week.course.parValue);
		}
		
		return (CGFloat)totalScore / (CGFloat)results.count;
	} else {
		return 0.0f;
	}
}

- (NSString *)averageScoreString {
	NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
	fmt.minimumFractionDigits = 1;
	CGFloat avg = [self averageScoreInYear:[WBYear thisYear]];
	NSString *decimalString = [fmt stringFromNumber:[NSNumber numberWithFloat:avg]];
	return [NSString stringWithFormat:@"%@%@", avg > 0 ? @"+" : @"", decimalString];
}

+ (NSArray *)resultsForPlayer:(WBPlayer *)player inYear:(WBYear *)year {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"match.teamMatchup.week.year = %@ && player = %@", year, player];
	 return [WBCoreDataManager findEntity:[WBResult entityName] withPredicate:predicate sorts:nil];
}

- (NSInteger)startingHandicapInYear:(WBYear *)year {
	for (WBPlayerYearData *data in self.yearData) {
		if (data.year == year) {
			return data.startingHandicapValue;
		}
	}
	DLog(@"No data found for player for year %ld", (long)year.valueValue);
	return INT32_MAX;
}

- (NSInteger)improvedInYear:(WBYear *)year {
	NSInteger starting = [self startingHandicapInYear:year];
	return starting != INT32_MAX ? self.currentHandicapValue - starting : 0;
}

- (NSString *)improvedString {
	NSInteger improved = [self improvedInYear:[WBYear thisYear]];
	return [NSString stringWithFormat:@"%@%ld", improved >= 0 ? @"+" : @"", (long)improved];
}

@end
