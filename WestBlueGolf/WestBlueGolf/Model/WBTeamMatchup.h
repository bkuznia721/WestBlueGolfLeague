#import "_WBTeamMatchup.h"

@interface WBTeamMatchup : _WBTeamMatchup {}

+ (WBTeamMatchup *)createTeamMatchupBetweenTeam:(WBTeam *)team1
										andTeam:(WBTeam *)team2
										forWeek:(WBWeek *)week
										matchId:(NSInteger)matchId
								  matchComplete:(BOOL)matchComplete;

+ (WBTeamMatchup *)matchupForTeam:(WBTeam *)team inWeek:(WBWeek *)week;

- (WBTeam *)opponentTeamOfTeam:(WBTeam *)team;

- (NSString *)totalPointsStringForTeam:(WBTeam *)team;
- (NSString *)totalScoreStringForTeam:(WBTeam *)team;

- (NSArray *)displayStrings;
- (NSArray *)displayStringsForTeam:(WBTeam *)team;

- (NSString *)timeLabel;
- (NSString *)shortTime;

@end
