#import "_WBPlayer.h"
#import "WBYear.h"

// Leaderboard keys
#define kLeaderboardPlayerAverageNet @"averageNet"
#define kLeaderboardPlayerAverageOpponentScore @"averageOpponentScore"
#define kLeaderboardPlayerAveragePoints @"averagePoints"
#define kLeaderboardPlayerAverageScore @"averageScore"
#define kLeaderboardPlayerMaxPoints @"maxPoints"
#define kLeaderboardPlayerMinNet @"minNet"
#define kLeaderboardPlayerMinScore @"minScore"
#define kLeaderboardPlayerTotalImproved @"totalImproved"
#define kLeaderboardPlayerTotalPoints @"totalPoints"
#define kLeaderboardPlayerTotalWins @"totalWins"
#define kLeaderboardPlayerWinLossRatio @"winLossRatio"

@interface WBPlayer : _WBPlayer {}

// Function to be used in each variant of player for creation (does not save context, so as to not trip value requirements)
+ (WBPlayer *)baseCreatePlayerWithName:(NSString *)name
					  currentHandicap:(NSInteger)currentHandicap
							   onTeam:(WBTeam *)currentTeam;

// Player specific create function
+ (WBPlayer *)createPlayerWithName:(NSString *)name
				   currentHandicap:(NSInteger)currentHandicap
							onTeam:(WBTeam *)currentTeam;

+ (WBPlayer *)me;
- (void)setPlayerToMe;
- (void)setPlayerToNotMe;

+ (WBPlayer *)noShowPlayer;
+ (void)createNoShowPlayer;

- (void)deletePlayer;

+ (WBPlayer *)playerWithName:(NSString *)name;

- (NSString *)shortName;
- (NSString *)firstName;
- (NSString *)currentHandicapString;

- (NSArray *)recordForYear:(WBYear *)year;
- (NSString *)record;

- (NSInteger)lowRoundForYear:(WBYear *)year;
- (NSString *)lowRoundString;

- (NSInteger)lowNetForYear:(WBYear *)year;
- (NSString *)lowNetString;

- (CGFloat)averagePointsInYear:(WBYear *)year;
- (NSString *)averagePointsString;

- (CGFloat)averageScoreInYear:(WBYear *)year;
- (NSString *)averageScoreString;

- (NSInteger)improvedInYear:(WBYear *)year;
- (NSString *)improvedString;

@end
