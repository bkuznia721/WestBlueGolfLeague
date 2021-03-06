#import "WBTeamMatchup.h"
#import "WBMatch.h"
#import "WBPlayer.h"
#import "WBResult.h"
#import "WBTeam.h"
#import "WBYear.h"
#import "WBWeek.h"

#define TIME_SHORT_FIRST_MATCH	@"3:44pm"
#define TIME_SHORT_SECOND_MATCH	@"4:00pm"
#define TIME_SHORT_THIRD_MATCH	@"4:16pm"
#define TIME_SHORT_FOURTH_MATCH	@"4:32pm"
#define TIME_SHORT_FIFTH_MATCH	@"4:48pm"

#define TIME_FIRST_MATCH	TIME_SHORT_FIRST_MATCH	@" (3:52)"
#define TIME_SECOND_MATCH	TIME_SHORT_SECOND_MATCH	@" (4:08)"
#define TIME_THIRD_MATCH	TIME_SHORT_THIRD_MATCH	@" (4:24)"
#define TIME_FOURTH_MATCH	TIME_SHORT_FOURTH_MATCH	@" (4:40)"
#define TIME_FIFTH_MATCH	TIME_SHORT_FIFTH_MATCH	@" (4:56)"

@interface WBTeamMatchup ()
@end

@implementation WBTeamMatchup

+ (WBTeamMatchup *)createTeamMatchupBetweenTeam:(WBTeam *)team1
										andTeam:(WBTeam *)team2
										forWeek:(WBWeek *)week
                                      matchupId:(NSInteger)matchupId
                                   matchupOrder:(NSInteger)matchupOrder
								  matchComplete:(BOOL)matchComplete
                                    playoffType:(WBPlayoffType)playoffType
											moc:(NSManagedObjectContext *)moc {
	WBTeamMatchup *newTeamMatchup = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
	newTeamMatchup.matchIdValue = matchupId;
	newTeamMatchup.matchCompleteValue = matchComplete;
    newTeamMatchup.playoffTypeValue = playoffType;
    newTeamMatchup.matchOrderValue = matchupOrder;

    [week addTeamMatchupsObject:newTeamMatchup];
    [team1 addMatchupsObject:newTeamMatchup];
    [team2 addMatchupsObject:newTeamMatchup];
	return newTeamMatchup;
}

+ (WBTeamMatchup *)matchupForTeam:(WBTeam *)team inWeek:(WBWeek *)week inContext:(NSManagedObjectContext *)moc {
	return (WBTeamMatchup *)[[self class] findFirstRecordWithPredicate:[NSPredicate predicateWithFormat:@"week = %@ && ANY teams = %@", week, team] sortedBy:nil moc:moc];
}

+ (NSArray *)findMatchupsForWeek:(WBWeek *)week {
	return [[self class] findWithPredicate:[NSPredicate predicateWithFormat:@"week = %@", week] sortedBy:@[[NSSortDescriptor sortDescriptorWithKey:@"matchId" ascending:YES]]];
}

- (WBTeam *)opponentTeamOfTeam:(WBTeam *)team {
	for (WBTeam *aTeam in self.teams) {
		if (aTeam != team) {
			return aTeam;
		}
	}
	return nil;
}

- (NSArray *)displayStrings {
	// Determine winner/loser, tie is unimportant
	WBTeam *team1 = self.teams.allObjects[0];
	WBTeam *team2 = nil;
	if (self.teams.count == 2) {
		team2 = self.teams.allObjects[1];
	} else {
		team2 = team1; // if only 1 team, its against itself
	}
	NSInteger team1Points = [self totalPointsForTeam:team1];
	NSInteger team2Points = [self totalPointsForTeam:team2];
	WBTeam *winner = (team1Points > team2Points) ? team1 : team2;
	WBTeam *loser = team1 == winner ? team2 : team1;
	WBTeam *myTeam = [WBTeam myTeam];
	
	NSString *winnerName = [NSString stringWithFormat:@"%@%@", winner == myTeam ? @"*" : @"", winner.name];
	NSString *winnerPoints = [NSString stringWithFormat:@"%ld pts", (long)(team1 == winner ? team1Points : team2Points)];
	NSString *winnerScore = [self totalScoreStringForTeam:winner];
	NSString *loserName = [NSString stringWithFormat:@"%@%@", loser == myTeam ? @"*" : @"", loser.name];
	NSString *loserPoints = [NSString stringWithFormat:@"%ld pts", (long)(team1 == winner ? team2Points : team1Points)];
	NSString *loserScore = [self totalScoreStringForTeam:loser];
	return @[winnerName, winnerPoints, winnerScore, loserName, loserPoints, loserScore];
}

- (NSArray *)displayStringsForTeam:(WBTeam *)team {
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"M/dd"];
	NSString *dateString = [dateFormatter stringFromDate:self.week.date];
	
	WBTeam *opponent = [self opponentTeamOfTeam:team];
	NSString *teamScore = [self totalScoreStringForTeam:team];
	NSString *opponentScore = [self totalScoreStringForTeam:opponent];
	NSString *titleString = [NSString stringWithFormat:@"%@ vs %@", dateString, [opponent shortName]];

	NSString *winLoss = nil;
	if (!self.week.isBadDataValue) {
		NSInteger points = [self totalPointsForTeam:team];
		BOOL win = points > 48;
		BOOL tie = points == 48;
		winLoss = win ? @"W" : tie ? @"T" : @"L";
	} else {
		winLoss = @"N/A";
	}
	
	NSString *scoreString = [NSString stringWithFormat:@"%@-%@", teamScore, opponentScore];
	
	NSString *teamRanksString = @"";
	if (self.week.seasonIndexValue == 1) {
		teamRanksString = @"Unranked";
	} else {
		NSInteger myTeamRank = [team rankPriorToWeek:self.week];
		NSInteger opponentRank = [opponent rankPriorToWeek:self.week];
		if (myTeamRank == 0 || opponentRank == 0) {
			teamRanksString = @"Unranked";
		} else {
			teamRanksString = [NSString stringWithFormat:@"#%ld vs #%ld", (long)myTeamRank, (long)opponentRank];
		}
	}
	
	NSInteger myTeamHandicap = [self totalHandicapForTeam:team];
	NSInteger opponentHandicap = [self totalHandicapForTeam:opponent];
	NSString *handicapString = [NSString stringWithFormat:@"+%ld vs +%ld", (long)myTeamHandicap, (long)opponentHandicap];
	
	NSInteger myTeamPoints = [self totalPointsForTeam:team];
	NSInteger opponentPoints = [self totalPointsForTeam:opponent];
	NSString *pointsString = [NSString stringWithFormat:@"%ld/%ld", (long)myTeamPoints, (long)opponentPoints];
	
	NSInteger myTeamNetScore = [self totalNetScoreForTeam:team];
	NSInteger opponentNetScore = [self totalNetScoreForTeam:opponent];
	NSString *myTeamNetScoreString = [NSString stringWithFormat:@"%@%ld", myTeamNetScore < 0 ? @"" : @"+", (long)myTeamNetScore];
	NSString *opponentNetScoreString = [NSString stringWithFormat:@"%@%ld", opponentNetScore < 0 ? @"" : @"+", (long)opponentNetScore];
	NSString *netScoreString = [NSString stringWithFormat:@"%@,%@", myTeamNetScoreString, opponentNetScoreString];
	
	return @[titleString, winLoss, scoreString, teamRanksString, handicapString, pointsString, netScoreString];
}

- (NSInteger)totalPointsForTeam:(WBTeam *)team {
	NSInteger total = 0;
	for (WBMatch *match in self.matches) {
		for (WBResult *result in match.results) {
			if (result.team == team && ![result.player.name isEqualToString:kNoShowPlayerName]) {
				total += result.pointsValue;
			}
		}
	}
	
	return total;
}

- (NSString *)totalPointsStringForTeam:(WBTeam *)team {
	return [NSString stringWithFormat:@"%ld pts", (long)[self totalPointsForTeam:team]];
}

- (NSInteger)totalScoreForTeam:(WBTeam *)team {
	NSInteger total = 0;
	for (WBMatch *match in self.matches) {
		for (WBResult *result in match.results) {
            // We actually want to include No Shows in this to not give the impression that the teams score was lower
			if (result.team == team /*&& ![result.player.name isEqualToString:kNoShowPlayerName]*/) {
				total += result.scoreValue;
			}
		}
	}

	return total;
}

- (NSString *)totalScoreStringForTeam:(WBTeam *)team {
	return [NSString stringWithFormat:@"%ld", (long)[self totalScoreForTeam:team]];
}

- (NSInteger)totalHandicapForTeam:(WBTeam *)team {
	NSInteger total = 0;
	for (WBMatch *match in self.matches) {
		for (WBResult *result in match.results) {
			if (result.team == team && ![result.player.name isEqualToString:kNoShowPlayerName]) {
				total += result.priorHandicapValue;
			}
		}
	}
	
	if (total == 0) {
		NSArray *players = [team top4Players];
		for (WBPlayer *player in players) {
			total += [player thisYearHandicap];
		}
	}
	
	return total;
}

- (NSInteger)totalNetScoreForTeam:(WBTeam *)team {
	NSInteger total = 0;
	for (WBMatch *match in self.matches) {
		for (WBResult *result in match.results) {
			if (result.team == team && ![result.player.name isEqualToString:kNoShowPlayerName]) {
				total += [result netScoreDifference];
			}
		}
	}
	
	return total;
}

- (NSArray *)orderedMatches {
	NSMutableArray *matches = [NSMutableArray arrayWithArray:self.matches.allObjects];
	[matches sortUsingComparator:^(id obj1, id obj2) {
		WBMatch *match1 = (WBMatch *)obj1;
		WBMatch *match2 = (WBMatch *)obj2;
		NSInteger handicapSum1 = [match1.results.allObjects[0] priorHandicapValue] + [match1.results.allObjects[1] priorHandicapValue];
		NSInteger handicapSum2 = [match2.results.allObjects[0] priorHandicapValue] + [match2.results.allObjects[1] priorHandicapValue];
		return handicapSum1 < handicapSum2 ? NSOrderedAscending : handicapSum1 == handicapSum2 ? NSOrderedSame : NSOrderedDescending;
	}];
	return matches;
}

- (NSString *)timeLabel {
	NSArray *matchups = [[self class] findMatchupsForWeek:self.week];
	NSInteger matchIndex = [matchups indexOfObject:self];
	switch (matchIndex) {
		case 0:
			return TIME_FIRST_MATCH;
		case 1:
			return TIME_SECOND_MATCH;
		case 2:
			return TIME_THIRD_MATCH;
		case 3:
			return TIME_FOURTH_MATCH;
		case 4:
			return TIME_FIFTH_MATCH;
		default:
			break;
	}
	return @"";
}

- (NSString *)shortTime {
	NSArray *matchups = [[self class] findMatchupsForWeek:self.week];
	NSInteger matchIndex = [matchups indexOfObject:self];
	switch (matchIndex) {
		case 0:
			return TIME_SHORT_FIRST_MATCH;
		case 1:
			return TIME_SHORT_SECOND_MATCH;
		case 2:
			return TIME_SHORT_THIRD_MATCH;
		case 3:
			return TIME_SHORT_FOURTH_MATCH;
		case 4:
			return TIME_SHORT_FIFTH_MATCH;
		default:
			break;
	}
	return @"";
}

- (WBTeam *)teamWithName:(NSString *)name {
    if (name && name.length > 0 && [[name substringToIndex:1] isEqualToString:@"*"]) {
        name = [name substringFromIndex:1];
    }
    
	for (WBTeam *team in self.teams) {
		if ([team.name isEqualToString:name]) {
			return team;
		}
	}
	return nil;
}

- (NSArray *)playersForTeam:(WBTeam *)team {
    TRAssert(team && [self.teams containsObject:team], @"No team provided to playersForTeam:");

    NSMutableArray *players = [NSMutableArray array];
    for (WBMatch *match in self.matches) {
        for (WBResult *result in match.results) {
            if (result.team.idValue == team.idValue) {
                if (result.player) {
                    [players addObject:result.player];
                } else {
                    // Kind of a harsh return, but if we're missing 1 player, the whole array is useless
                    return nil;
                }
            }
        }
    }
    
    // Sort by handicap
    if (players.count > 0) {
        [players sortUsingComparator:^(id obj1, id obj2) {
            WBPlayer *player1 = (WBPlayer *)obj1;
            WBPlayer *player2 = (WBPlayer *)obj2;
            NSInteger handicap1 = player1.currentHandicapValue;
            NSInteger handicap2 = player2.currentHandicapValue;
            return handicap1 < handicap2 ? NSOrderedAscending : handicap1 == handicap2 ? NSOrderedSame : NSOrderedDescending;
        }];
    }
    
    return players;
}

- (BOOL)scoringComplete {
    if (!self.matchCompleteValue) {
        return NO;
    }

    // If the match is complete and we have 4 matches, we're scored!
    return [self lineupComplete];
}

// Asking for lineup complete assumes scoring complete already returned no.
- (BOOL)lineupComplete {
    NSArray *matches = [self orderedMatches];
    //TRAssert(matches && matches.count == 4, @"Attempting to display less than 4 matches");
    return matches && matches.count == 4;
}

@end
