//
//  WBInputDataManager.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/10/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBInputDataManager.h"
#import "WBCoreDataManager.h"
#import "WBModels.h"

#define wbJsonKeyYearValue @"YearValue"

#define wbJsonKeyWeekIndex @"Week"
#define wbJsonKeyWeekPar @"Par"
#define wbJsonKeyWeekDate @"Date"
#define wbJsonKeyWeekCourse @"Course"

#define wbJsonKeyTeamId @"TeamID"
#define wbJsonKeyTeamName @"TeamName"
#define wbJsonKeyTeamDivision @"Division" // unused

#define wbJsonKeyUserId @"ID"
#define wbJsonKeyUserName @"Username"
#define wbJsonKeyUserPassword @"Password"

#define wbJsonKeyPlayerName @"PlayerName"
#define wbJsonKeyPlayerTeam @"TeamID"
#define wbJsonKeyPlayerStartScore @"Week0Score"
#define wbJsonKeyPlayerIsRookie @"Status"

#define wbJsonKeyMatchComplete @"MatchComplete"
#define wbJsonKeyMatchId @"MatchID" // unused
#define wbJsonKeyMatchWeek @"Week"
#define wbJsonKeyMatchTeam1 @"TeamID1"
#define wbJsonKeyMatchTeam2 @"TeamID2"
#define wbJsonKeyMatchId @"MatchID"

#define wbJsonKeyResultWeek @"Week"
#define wbJsonKeyResultTeam1 @"TeamID1" // teams are redundant data here because of players
#define wbJsonKeyResultPlayer1 @"PlayerName1"
#define wbJsonKeyResultScore1 @"Score1"
#define wbJsonKeyResultPoints1 @"Points1"
#define wbJsonKeyResultTeam2 @"TeamID2" // teams are redundant
#define wbJsonKeyResultPlayer2 @"PlayerName2"
#define wbJsonKeyResultScore2 @"Score2"
#define wbJsonKeyResultPoints2 @"Points2"

@implementation WBInputDataManager

- (void)createYearsInContext:(NSManagedObjectContext *)moc {
	NSArray *yearArray = [self jsonFromData:[self fileDataForFilename:@"yearTable" year:0]];
	NSInteger yearValue = 0;
	for (NSDictionary *elt in yearArray) {
		yearValue = [[elt objectForKey:wbJsonKeyYearValue] integerValue];
		[WBYear yearWithValue:yearValue inContext:moc];
	}
	
	[WBCoreDataManager saveContext:moc];
}

- (void)loadJsonDataForYearValue:(NSInteger)yearValue fromContext:(NSManagedObjectContext *)moc {
	WBYear *year = [WBYear findYearWithValue:yearValue inContext:moc];

	//TODO: Will need a way to calculate this
	year.isCompleteValue = YES;
	
	// week table
	NSData *weekData = [self fileDataForFilename:@"weekTable" year:year];
	if (!weekData) {
		DLog(@"No data for year %ld", (long)yearValue);
		return;
	}

	NSArray *weekArray = [self jsonFromData:weekData];
	WBCourse *course = nil;
	NSString *courseName = nil, *weekDate = nil;
	NSInteger par = 0, weekId = 0;
	NSDate *date = nil;
	for (NSDictionary *elt in weekArray) {
		courseName = [elt objectForKey:wbJsonKeyWeekCourse];
		par = [[elt objectForKey:wbJsonKeyWeekPar] integerValue];
		course = [WBCourse courseWithName:courseName par:par inContext:moc];
		
		weekId = [[elt objectForKey:wbJsonKeyWeekIndex] integerValue];
		weekDate = [elt objectForKey:wbJsonKeyWeekDate];
		date = [self dateForString:weekDate];

		[WBWeek createWeekWithDate:date inYear:year forCourse:course seasonIndex:weekId inContext:moc];
	}

	//[WBCoreDataManager saveContext:moc];
	
	// team table
	NSArray *teamArray = [self jsonFromData:[self fileDataForFilename:@"teamTable" year:year]];
	NSString *teamName = nil;
	NSInteger teamId = 0;
	for (NSDictionary *elt in teamArray) {
		teamName = [elt objectForKey:wbJsonKeyTeamName];
		teamId = [[elt objectForKey:wbJsonKeyTeamId] integerValue];
		[WBTeam teamWithName:teamName teamId:teamId inContext:moc];
	}
	
	//[WBCoreDataManager saveContext:moc];
	
	// password/user table
	/*NSArray *captainArray = [self jsonFromData:[self fileDataForFilename:@"passwordTable"]];
	 
	 for (NSDictionary *elt in captainArray) {
	 NSInteger captainId = [[elt objectForKey:wbJsonKeyUserId] integerValue];
	 NSString *captainUsername = [elt objectForKey:wbJsonKeyUserName];
	 NSString *captainPassword = [elt objectForKey:wbJsonKeyUserPassword];
	 // Still need to set full name, handicap, and team from user data
	 [WBCaptain createCaptainWithId:captainId username:captainUsername password:captainPassword name:@"No Name" currentHandicap:99 onTeam:noTeam];
	 
	 }*/
	
	// player table
	NSArray *playerArray = [self jsonFromData:[self fileDataForFilename:@"playerTable" year:year]];
	WBTeam *playerTeam = nil;
	WBPlayer *player = nil;
	NSString *playerName = nil;
	NSInteger startingHandicap = 0;
	teamId = 0;
	BOOL isRookie = NO;
	for (NSDictionary *elt in playerArray) {
		playerName = [elt objectForKey:wbJsonKeyPlayerName];
		teamId = [[elt objectForKey:wbJsonKeyPlayerTeam] integerValue];
		startingHandicap = [[elt objectForKey:wbJsonKeyPlayerStartScore] integerValue] - 36;
		isRookie = [[elt objectForKey:wbJsonKeyPlayerIsRookie] boolValue];
		playerTeam = [WBTeam teamWithId:teamId inContext:moc];
		
		player = [WBPlayer playerWithName:playerName currentHandicap:startingHandicap onTeam:playerTeam inContext:moc];
		
		[WBPlayerYearData createPlayerYearDataForPlayer:player year:year withStartingHandicap:startingHandicap withFinishingHandicap:startingHandicap isRookie:isRookie moc:moc];
	}
	
	// Create a player to catch all the no shows (ends up being conditional too)
	[WBPlayer createNoShowPlayerInContext:moc];
	
	//[WBCoreDataManager saveContext:moc];
	
	// match table
	NSArray *matchArray = [self jsonFromData:[self fileDataForFilename:@"matchTable" year:year]];
	WBWeek *week = nil;
	WBTeam *team1 = nil, *team2 = nil;
	WBTeamMatchup *matchup = nil;
	NSInteger team1Id = 0, team2Id = 0, matchId = 0;
	weekId = 0;
	BOOL matchComplete = NO;
	
	for (NSDictionary *elt in matchArray) {
		weekId = [[elt objectForKey:wbJsonKeyMatchWeek] integerValue];
		team1Id = [[elt objectForKey:wbJsonKeyMatchTeam1] integerValue];
		team2Id = [[elt objectForKey:wbJsonKeyMatchTeam2] integerValue];
		matchId = [[elt objectForKey:wbJsonKeyMatchId] integerValue];
		matchComplete = [[elt objectForKey:wbJsonKeyMatchComplete] boolValue];
		if (!matchComplete) {
			DLog(@"Incomplete Match in received data");
			//continue;
		}
		
		week = [WBWeek findWeekWithId:weekId inYear:year inContext:moc];
		team1 = [WBTeam teamWithId:team1Id inContext:moc];
		team2 = [WBTeam teamWithId:team2Id inContext:moc];
		if (!team1 || !team2) {
			if (team1.teamIdValue == 0 || team2.teamIdValue == 0) {
				DLog(@"Team 0s");
				team1 = team2 = [WBTeam teamWithName:@"Playoff Team" teamId:0 inContext:moc];
				team1.realValue = NO;
				team2.realValue = NO;
			} else {
				DLog(@"Bad teams");
				continue;
			}
		}
		
		matchup = [WBTeamMatchup createTeamMatchupBetweenTeam:team1 andTeam:team2 forWeek:week matchId:matchId matchComplete:matchComplete moc:moc];
	}
	
	//[WBCoreDataManager saveContext:moc];
	
	WBWeek *firstPlayoffWeek = [WBWeek firstPlayoffWeekInYear:year];
	NSArray *firstWeekMatchups = [firstPlayoffWeek.teamMatchups sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"matchId" ascending:YES]]];
	WBTeamMatchup *oneFourMatch = firstWeekMatchups[0];
	oneFourMatch.playoffTypeValue = WBPlayoffTypeChampionship;
	WBTeamMatchup *twoThreeMatch = firstWeekMatchups[1];
	twoThreeMatch.playoffTypeValue = WBPlayoffTypeChampionship;
	WBTeamMatchup *fiveEightMatch = firstWeekMatchups[2];
	fiveEightMatch.playoffTypeValue = WBPlayoffTypeConsolation;
	WBTeamMatchup *sixSevenMatch = firstWeekMatchups[3];
	sixSevenMatch.playoffTypeValue = WBPlayoffTypeConsolation;
	WBTeamMatchup *nineTenMatch = firstWeekMatchups[4];
	nineTenMatch.playoffTypeValue = WBPlayoffTypeLexis;
	
	WBWeek *finalPlayoffWeek = [WBWeek finalPlayoffWeekInYear:year];
	NSArray *finalWeekMatchups = [finalPlayoffWeek.teamMatchups sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"matchId" ascending:YES]]];
	WBTeamMatchup *oneTwoMatch = finalWeekMatchups[0];
	oneTwoMatch.playoffTypeValue = WBPlayoffTypeChampionship;
	WBTeamMatchup *threeFourMatch = finalWeekMatchups[1];
	threeFourMatch.playoffTypeValue = WBPlayoffTypeBronze;
	WBTeamMatchup *fiveSixMatch = finalWeekMatchups[2];
	fiveSixMatch.playoffTypeValue = WBPlayoffTypeConsolation;
	WBTeamMatchup *sevenEightMatch = finalWeekMatchups[3];
	sevenEightMatch.playoffTypeValue = WBPlayoffTypeLexis;
	WBTeamMatchup *lastMatch = finalWeekMatchups[4];
	lastMatch.playoffTypeValue = WBPlayoffTypeLexis;

	//[WBCoreDataManager saveContext:moc];
	
	// results table
	NSArray *resultsArray = [self jsonFromData:[self fileDataForFilename:@"resultsTable" year:year]];
	WBPlayer *player1 = nil, *player2 = nil;
	WBMatch *match = nil;
	NSString *player1Name = nil, *player2Name = nil;
	NSInteger score1 = 0, score2 = 0, points1 = 0, points2 = 0;
	weekId = 0, team1Id = 0, team2Id = 0, week = nil, team1 = nil, team2 = nil, matchup = nil;
	for (NSDictionary *elt in resultsArray) {
		weekId = [[elt objectForKey:wbJsonKeyResultWeek] integerValue];
		team1Id = [[elt objectForKey:wbJsonKeyResultTeam1] integerValue];
		team2Id = [[elt objectForKey:wbJsonKeyResultTeam2] integerValue];
		player1Name = [elt objectForKey:wbJsonKeyResultPlayer1];
		player2Name = [elt objectForKey:wbJsonKeyResultPlayer2];
		score1 = [[elt objectForKey:wbJsonKeyResultScore1] integerValue];
		score2 = [[elt objectForKey:wbJsonKeyResultScore2] integerValue];
		points1 = [[elt objectForKey:wbJsonKeyResultPoints1] integerValue];
		points2 = [[elt objectForKey:wbJsonKeyResultPoints2] integerValue];
		
		week = [WBWeek findWeekWithId:weekId inYear:year inContext:moc];
		
		if (team1Id == team2Id) {
			DLog(@"Match has same team on both sides");
			week.isBadDataValue = YES;
		}
		
		player1 = [WBPlayer playerWithName:player1Name inContext:moc];
		player2 = [WBPlayer playerWithName:player2Name inContext:moc];
		if (!player1 || !player2) {
			DLog(@"Bad Player Results");
			continue;
		}
		
		team1 = [WBTeam teamWithId:team1Id inContext:moc];
		team2 = [WBTeam teamWithId:team2Id inContext:moc];
		if (!team1 || !team2) {
			DLog(@"Bad Teams");
			continue;
		}
		
		matchup = [WBTeamMatchup matchupForTeam:team1 inWeek:week inContext:moc];
		
		match = [WBMatch createMatchForTeamMatchup:matchup player1:player1 player2:player2 moc:moc];
		if (player1) {
			[WBResult createResultForMatch:match forPlayer:player1 team:team1 withPoints:points1 priorHandicap:player1.currentHandicapValue score:score1 moc:moc];
		}
		if (player2) {
			[WBResult createResultForMatch:match forPlayer:player2 team:team2 withPoints:points2 priorHandicap:player2.currentHandicapValue score:score2 moc:moc];
		}
	}

	//[WBCoreDataManager saveContext:moc];
	
	// Determine if there are any weeks with no matches and mark them bad data (in addition to those marked bad from having teams playing themselves)
	NSArray *matches = nil;
	for (WBWeek *week in year.weeks) {
		matches = [WBMatch findWithPredicate:[NSPredicate predicateWithFormat:@"teamMatchup.week = %@", week] sortedBy:nil fetchLimit:0 moc:moc];
		if (!matches || matches.count == 0) {
			DLog(@"week has no matches");
			week.isBadDataValue = YES;
		}
	}
	
	[WBCoreDataManager saveContext:moc];
}

- (void)clearRefreshableDataForYearValue:(NSInteger)yearValue {
	WBYear *year = [WBYear findYearWithValue:yearValue inContext:[[WBCoreDataManager sharedManager] managedObjectContext]];
	
	// This should delete all weeks, teamMatchups, matches, and results
	for (WBWeek *week in year.weeks) {
		[week deleteEntityInContext:week.managedObjectContext];
	}
	
	for (WBPlayerYearData *data in year.playerYearData) {
		[data deleteEntityInContext:data.managedObjectContext];
	}
	
	for (WBBoardData *boardData in year.boardData) {
		[boardData deleteEntityInContext:boardData.managedObjectContext];
	}
}

#pragma mark - Helper functions

// Example: "4/23/2013", total grammar of formatters - @"yyyy-MM-dd HH:mm:ss ZZZ"
- (NSDate *)dateForString:(NSString *)dateString {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM/dd/yyyy"];
	return [dateFormatter dateFromString:dateString];
}

- (NSData *)fileDataForFilename:(NSString *)name year:(WBYear *)year {
	NSString *fileName = [NSString stringWithFormat:@"%@%@", name, year.value > 0 ? year.value : @""];
	NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
	return [[NSFileManager defaultManager] contentsAtPath:path];
}

- (NSArray *)jsonFromData:(NSData *)data {
	if (data) {
		NSError *error = nil;
		id object = [NSJSONSerialization JSONObjectWithData:data
													options:0
													  error:&error];
		
		if (error) {
			ALog(@"json was malformed");
		}
		
		if ([object isKindOfClass:[NSArray class]]) {
			return object;
		} else {
			ALog(@"json wasn't an array");
		}
	} else {
		ALog(@"no json data found");
	}
	return nil;
}

@end
