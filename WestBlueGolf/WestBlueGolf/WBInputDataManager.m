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

- (void)loadJsonData {
	WBTeam *noTeam = [WBTeam createTeamWithName:@"Season not yet over" teamId:0];
	WBYear *year = [WBYear createYearWithValue:2013 champion:noTeam];

	//TODO: Will need a way to calculate this
	year.isCompleteValue = YES;
	
	// week table
	NSArray *weekArray = [self jsonFromData:[self fileDataForFilename:@"weekTable"]];
	
	for (NSDictionary *elt in weekArray) {
		NSString *courseName = [elt objectForKey:wbJsonKeyWeekCourse];
		WBCourse *course = [WBCourse courseWithName:courseName];
		if (!course) {
			NSInteger par = [[elt objectForKey:wbJsonKeyWeekPar] integerValue];
			course = [WBCourse createCourseWithName:courseName par:par];
		}
		
		NSInteger weekId = [[elt objectForKey:wbJsonKeyWeekIndex] integerValue];
		NSString *weekDate = [elt objectForKey:wbJsonKeyWeekDate];
		NSDate *date = [self dateForString:weekDate];
		[WBWeek createWeekWithDate:date inYear:year forCourse:course seasonIndex:weekId];
	}
	
	// team table
	NSArray *teamArray = [self jsonFromData:[self fileDataForFilename:@"teamTable"]];
	
	for (NSDictionary *elt in teamArray) {
		NSString *teamName = [elt objectForKey:wbJsonKeyTeamName];
		NSInteger teamId = [[elt objectForKey:wbJsonKeyTeamId] integerValue];
		[WBTeam createTeamWithName:teamName teamId:teamId];
	}
	
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
	NSArray *playerArray = [self jsonFromData:[self fileDataForFilename:@"playerTable"]];
	WBPlayer *player = nil;
	for (NSDictionary *elt in playerArray) {
		NSString *playerName = [elt objectForKey:wbJsonKeyPlayerName];
		NSInteger teamId = [[elt objectForKey:wbJsonKeyPlayerTeam] integerValue];
		NSInteger startingHandicap = [[elt objectForKey:wbJsonKeyPlayerStartScore] integerValue] - 36;
		BOOL isRookie = [[elt objectForKey:wbJsonKeyPlayerIsRookie] boolValue];
		WBTeam *playerTeam = [WBTeam teamWithId:teamId];
		
		player = [WBPlayer createPlayerWithName:playerName currentHandicap:startingHandicap onTeam:playerTeam];
		
		[WBPlayerYearData createPlayerYearDataForPlayer:player year:year withStartingHandicap:startingHandicap withFinishingHandicap:startingHandicap isRookie:isRookie];
	}
	
	// Create a player to catch all the no shows
	[WBPlayer createNoShowPlayer];
	
	// match table
	NSArray *matchArray = [self jsonFromData:[self fileDataForFilename:@"matchTable"]];
	
	for (NSDictionary *elt in matchArray) {
		NSInteger weekId = [[elt objectForKey:wbJsonKeyMatchWeek] integerValue];
		NSInteger team1Id = [[elt objectForKey:wbJsonKeyMatchTeam1] integerValue];
		NSInteger team2Id = [[elt objectForKey:wbJsonKeyMatchTeam2] integerValue];
		BOOL matchComplete = [[elt objectForKey:wbJsonKeyMatchComplete] boolValue];
		if (!matchComplete) {
			DLog(@"Incomplete Match in received data");
			continue;
		}
		
		WBWeek *week = [WBWeek weekWithId:weekId];
		WBTeam *team1 = [WBTeam teamWithId:team1Id];
		WBTeam *team2 = [WBTeam teamWithId:team2Id];
		
		[WBTeamMatchup createTeamMatchupBetweenTeam:team1 andTeam:team2 forWeek:week];
	}

	// results table
	NSArray *resultsArray = [self jsonFromData:[self fileDataForFilename:@"resultsTable"]];
	
	for (NSDictionary *elt in resultsArray) {
		NSInteger weekId = [[elt objectForKey:wbJsonKeyResultWeek] integerValue];
		NSInteger team1Id = [[elt objectForKey:wbJsonKeyResultTeam1] integerValue];
		NSInteger team2Id = [[elt objectForKey:wbJsonKeyResultTeam2] integerValue];
		NSString *player1Name = [elt objectForKey:wbJsonKeyResultPlayer1];
		NSString *player2Name = [elt objectForKey:wbJsonKeyResultPlayer2];
		NSInteger score1 = [[elt objectForKey:wbJsonKeyResultScore1] integerValue];
		NSInteger score2 = [[elt objectForKey:wbJsonKeyResultScore2] integerValue];
		NSInteger points1 = [[elt objectForKey:wbJsonKeyResultPoints1] integerValue];
		NSInteger points2 = [[elt objectForKey:wbJsonKeyResultPoints2] integerValue];
		
		WBWeek *week = [WBWeek weekWithId:weekId];
		
		WBPlayer *player1 = [WBPlayer playerWithName:player1Name];
		WBPlayer *player2 = [WBPlayer playerWithName:player2Name];
		if (!player1 || !player2) {
			DLog(@"Bad Player Results");
		}
		
		WBTeam *team1 = [WBTeam teamWithId:team1Id];
		WBTeam *team2 = [WBTeam teamWithId:team2Id];
		WBTeamMatchup *matchup = [WBTeamMatchup matchupForTeam:team1 inWeek:week];
		
		WBMatch *match = [WBMatch createMatchForTeamMatchup:matchup player1:player1 player2:player2];
		if (player1) {
			[WBResult createResultForMatch:match forPlayer:player1 team:team1 withPoints:points1 priorHandicap:player1.currentHandicapValue score:score1];
		}
		if (player2) {
			[WBResult createResultForMatch:match forPlayer:player2 team:team2 withPoints:points2 priorHandicap:player2.currentHandicapValue score:score2];
		}
	}
	
	// Delete the noTeam
	[noTeam deleteEntity];
	
	[WBCoreDataManager saveContext];
}

#pragma mark - Helper functions

// Example: "4/23/2013", total grammar of formatters - @"yyyy-MM-dd HH:mm:ss ZZZ"
- (NSDate *)dateForString:(NSString *)dateString {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM/dd/yyyy"];
	return [dateFormatter dateFromString:dateString];
}

- (NSData *)fileDataForFilename:(NSString *)name {
	NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
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

#pragma mark - Test Method

- (void)createTestData {
	/*WBTeam *noTeam = [WBTeam createTeamWithName:@"Season not yet over"];
	 WBYear *year = [WBYear createYearWithValue:2013 champion:noTeam];
	 WBCourse *course = [WBCourse createCourseWithName:@"Gold Front" par:36];
	 WBWeek *week = [WBWeek createWeekWithDate:[NSDate date] inYear:year forCourse:course];
	 
	 WBTeam *team1 = [WBTeam createTeamWithName:@"Earthmovers"];
	 WBCaptain *captain1 = [WBCaptain createCaptainWithId:1 username:@"dale" password:@"vlasak" name:@"Dale Vlasak" currentHandicap:14 onTeam:team1];
	 WBPlayer *player10 = [WBPlayer createPlayerWithName:@"Michael Harlow" currentHandicap:5 onTeam:team1];
	 WBPlayer *player11 = [WBPlayer createPlayerWithName:@"Tim Wagner" currentHandicap:3 onTeam:team1];
	 WBPlayer *player12 = [WBPlayer createPlayerWithName:@"Andy Norgren" currentHandicap:14 onTeam:team1];
	 
	 WBTeam *team2 = [WBTeam createTeamWithName:@"Swing Doctors"];
	 WBCaptain *captain2 = [WBCaptain createCaptainWithId:2 username:@"nick" password:@"remarke" name:@"Nick Remarke" currentHandicap:11 onTeam:team2];
	 WBPlayer *player20 = [WBPlayer createPlayerWithName:@"Ryan Hunecke" currentHandicap:9 onTeam:team2];
	 WBPlayer *player21 = [WBPlayer createPlayerWithName:@"Jason Meggit" currentHandicap:7 onTeam:team2];
	 WBPlayer *player22 = [WBPlayer createPlayerWithName:@"Nick Brett" currentHandicap:7 onTeam:team2];
	 
	 WBTeamMatchup *matchup = [WBTeamMatchup createTeamMatchupBetweenTeam:team1 andTeam:team2 forWeek:week];
	 WBMatch *match1 = [WBMatch createMatchForTeamMatchup:matchup player1:player11 player2:player21];
	 [WBResult createResultForMatch:match1 forPlayer:player11 withPoints:18 priorHandicap:3 score:39];
	 [WBResult createResultForMatch:match1 forPlayer:player21 withPoints:6 priorHandicap:7 score:43];
	 WBMatch *match2 = [WBMatch createMatchForTeamMatchup:matchup player1:player10 player2:player22];
	 [WBResult createResultForMatch:match2 forPlayer:player10 withPoints:22 priorHandicap:5 score:41];
	 [WBResult createResultForMatch:match2 forPlayer:player22 withPoints:2 priorHandicap:7 score:43];
	 WBMatch *match3 = [WBMatch createMatchForTeamMatchup:matchup player1:captain1 player2:player20];
	 [WBResult createResultForMatch:match3 forPlayer:captain1 withPoints:15 priorHandicap:14 score:50];
	 [WBResult createResultForMatch:match3 forPlayer:player20 withPoints:9 priorHandicap:7 score:43];
	 WBMatch *match4 = [WBMatch createMatchForTeamMatchup:matchup player1:player12 player2:captain2];
	 [WBResult createResultForMatch:match4 forPlayer:player12 withPoints:12 priorHandicap:14 score:50];
	 [WBResult createResultForMatch:match4 forPlayer:captain2 withPoints:12 priorHandicap:11 score:37];
	 
	 // Delete the noTeam
	 [noTeam deleteTeam];*/
	
	[WBCoreDataManager saveContext];
}

@end
