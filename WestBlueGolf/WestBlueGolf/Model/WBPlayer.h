#import "_WBPlayer.h"

@class WBYear;

// Leaderboard keys
#define kLeaderboardPlayerAverageNet @"averageNet"
#define kLeaderboardPlayerAverageOpponentNetScore @"averageOpponentNetScore"
#define kLeaderboardPlayerAverageOpponentScore @"averageOpponentScore"
#define kLeaderboardPlayerAveragePoints @"averagePoints"
#define kLeaderboardPlayerAverageScore @"averageScore"
#define kLeaderboardPlayerHandicap @"handicap"
#define kLeaderboardPlayerMaxPoints @"maxPoints"
#define kLeaderboardPlayerMinNet @"minNet"
#define kLeaderboardPlayerMinScore @"minScore"
#define kLeaderboardPlayerTotalImproved @"totalImproved"
#define kLeaderboardPlayerTotalPoints @"totalPoints"
#define kLeaderboardPlayerTotalWins @"totalWins"
#define kLeaderboardPlayerWinLossRatio @"winLossRatio"

#define kLeaderboardPlayerTopPercentage @"topPercentage"
#define kLeaderboardPlayerTopTenPercentage @"topTenPercentage"

@interface WBPlayer : _WBPlayer {}

// Player specific create function
+ (WBPlayer *)createPlayerWithName:(NSString *)name
				   currentHandicap:(NSInteger)currentHandicap
							onTeam:(WBTeam *)currentTeam;

+ (WBPlayer *)me;
- (void)setPlayerToMe;
- (void)setPlayerToNotMe;

+ (WBPlayer *)noShowPlayer;
+ (void)createNoShowPlayer;

+ (WBPlayer *)playerWithName:(NSString *)name;
//+ (NSArray *)fetchAllPlayersWithSorts:(NSArray *)sorts;

- (NSString *)shortName;
- (NSString *)firstName;
- (NSString *)currentHandicapString;
- (NSInteger)startingHandicapInYear:(WBYear *)year;
- (WBPlayerYearData *)thisYearData;

- (NSArray *)recordForYear:(WBYear *)year;
- (CGFloat)recordRatioForYear:(WBYear *)year;
- (NSString *)record;

- (NSInteger)lowRoundForYear:(WBYear *)year;
- (NSString *)lowRoundString;

- (NSInteger)lowNetForYear:(WBYear *)year;
- (NSString *)lowNetString;

- (CGFloat)averagePointsInYear:(WBYear *)year;
- (NSString *)averagePointsString;

- (NSInteger)improvedInYear:(WBYear *)year;
- (NSString *)improvedString;

- (CGFloat)averageScoreForYear:(WBYear *)year;
- (NSString *)averageScoreString;
- (CGFloat)averageNetScoreForYear:(WBYear *)year;
- (CGFloat)averageOpponentScoreForYear:(WBYear *)year;
- (CGFloat)averageOpponentNetScoreForYear:(WBYear *)year;

- (WBBoardData *)findHandicapBoardData;
- (WBBoardData *)findWinLossBoardData;
- (WBBoardData *)findLowScoreBoardData;
- (WBBoardData *)findAveragePointsBoardData;
- (WBBoardData *)findImprovedBoardData;
- (WBBoardData *)findLowNetBoardData;

@end
