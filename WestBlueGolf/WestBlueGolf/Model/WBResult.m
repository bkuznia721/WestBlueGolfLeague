#import "WBResult.h"
#import "WBCourse.h"
#import "WBMatch.h"
#import "WBTeam.h"
#import "WBTeamMatchup.h"
#import "WBPlayer.h"
#import "WBWeek.h"

@interface WBResult ()

@end

@implementation WBResult

+ (WBResult *)createResultForMatch:(WBMatch *)match
						 forPlayer:(WBPlayer *)player
							  team:(WBTeam *)team
						withPoints:(NSInteger)points
					 priorHandicap:(NSInteger)priorHandicap
							 score:(NSInteger)score
							   moc:(NSManagedObjectContext *)moc {
	BOOL found = NO;
	for (WBPlayer *p in match.players) {
		if (player.idValue == p.idValue) {
			found = YES;
		}
	}
	
	if (!found) {
		ALog(@"Attempting to add result for player not in match");
	}
	
	if (points > 24 || (match.results.count > 0 && [(WBResult *)match.results.allObjects[0] pointsValue] + points > 24)) {
		//ALog(@"Attempting to add result with points totalling greater than 24");
        DLog(@"Attempting to add result with points totalling greater than 24");
        points = 0;
	}
	
	WBResult *newResult = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
	newResult.pointsValue = points;
	newResult.priorHandicapValue = priorHandicap;
	newResult.scoreValue = score;

	[match addResultsObject:newResult];
	[player addResultsObject:newResult];
	[team addResultsObject:newResult];
	return newResult;
}

- (WBResult *)opponentResult {
	WBMatch *match = self.match;
	for (WBResult *result in match.results) {
		if (result != self) {
			return result;
		}
	}
	return nil;
}

- (BOOL)wasWin {
	return self.pointsValue > 12.0;
}

- (BOOL)wasTie {
	return self.pointsValue == 12.0;
}

- (BOOL)wasLoss {
	return self.pointsValue < 12.0;
}

- (NSInteger)scoreDifference {
	return self.scoreValue - self.match.teamMatchup.week.course.parValue;
}

- (NSInteger)netScoreDifference {
	return [self scoreDifference] - self.priorHandicapValue;
}

- (NSString *)netScoreDifferenceString {
	return [NSString stringWithFormat:@"%@%ld", [self netScoreDifference] < 0 ? @"" : @"+", (long)[self netScoreDifference]];
}

- (NSString *)priorHandicapString {
	return [NSString stringWithFormat:@"%@%@", self.priorHandicapValue < 0 ? @"" : @"+", self.priorHandicap];
}

@end
