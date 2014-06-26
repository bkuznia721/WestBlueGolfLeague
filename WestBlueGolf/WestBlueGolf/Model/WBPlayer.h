#import "_WBPlayer.h"

@class WBTeam;
@class WBYear;

// Leaderboard keys
#define kLeaderboardPlayerAverageNet @"player_avg_net_score"
#define kLeaderboardPlayerAverageOpponentNetScore @"player_avg_opp_net_score"
#define kLeaderboardPlayerAverageOpponentScore @"player_avg_opp_score"
#define kLeaderboardPlayerAveragePoints @"player_avg_points"
#define kLeaderboardPlayerAverageScore @"player_avg_score"
#define kLeaderboardPlayerHandicap @"player_handicap"
#define kLeaderboardPlayerMaxPoints @"player_points_in_match"
#define kLeaderboardPlayerMinNet @"player_net_best_score"
#define kLeaderboardPlayerMinScore @"player_best_score"
#define kLeaderboardPlayerTotalImproved @"player_season_improvement"
#define kLeaderboardPlayerTotalPoints @"player_total_points"
#define kLeaderboardPlayerTotalRounds @"player_total_rounds_for_year"
#define kLeaderboardPlayerTotalWins @"player_total_wins"
#define kLeaderboardPlayerWinLossRatio @"player_win_loss_ratio"

#define kLeaderboardPlayerAverageMarginVictory @"player_avg_margin_victory"
#define kLeaderboardPlayerAverageMarginNetVictory @"player_avg_margin_net_victory"

#define kLeaderboardPlayerTopPercentage @"topPercentage"
#define kLeaderboardPlayerTopTenPercentage @"topTenPercentage"

#define kLeaderboardPlayerTripleCrown @"tripleCrown"
#define kLeaderboardPlayerTripleCrown2 @"tripleCrown2"

#define kNoShowPlayerName @"No Show"

@interface WBPlayer : _WBPlayer {}

// Player specific create function
+ (WBPlayer *)createPlayerWithId:(NSInteger)playerId
                            name:(NSString *)name
                 currentHandicap:(NSInteger)currentHandicap
                            real:(BOOL)real
                       inContext:(NSManagedObjectContext *)moc;
+ (WBPlayer *)playerWithId:(NSInteger)playerId
                      name:(NSString *)name
           currentHandicap:(NSInteger)currentHandicap
                      real:(BOOL)real
                 inContext:(NSManagedObjectContext *)moc;

+ (WBPlayer *)me;
- (void)setPlayerToMe;
- (void)setPlayerToNotMe;
- (void)toggleFavorite;
- (WBTeam *)currentTeam;

/*+ (WBPlayer *)noShowPlayer;
+ (void)createNoShowPlayerInContext:(NSManagedObjectContext *)moc;
- (BOOL)isNoShowPlayer;*/

+ (WBPlayer *)playerWithName:(NSString *)name inContext:(NSManagedObjectContext *)moc;

+ (WBPlayer *)findWithId:(NSInteger)playerId;
+ (NSArray *)findAllForYear:(WBYear *)year inContext:(NSManagedObjectContext *)moc;
- (NSArray *)filterResultsForYear:(WBYear *)year goodData:(BOOL)goodData;
- (NSArray *)filterResultsForYear:(WBYear *)year goodData:(BOOL)goodData sorts:(NSArray *)sorts;
- (WBPlayerYearData *)filterYearDataForYear:(WBYear *)year;
- (WBPlayerYearData *)thisYearData;
- (NSInteger)startingHandicapInYear:(WBYear *)year;
- (NSInteger)finishingHandicapInYear:(WBYear *)year;

- (NSInteger)thisYearHandicap;
- (NSString *)currentHandicapString;

- (NSArray *)recordForYear:(WBYear *)year;
- (CGFloat)recordRatioForYear:(WBYear *)year;
- (NSString *)recordStringForYear:(WBYear *)year;

- (NSInteger)lowRoundForYear:(WBYear *)year inContext:(NSManagedObjectContext *)moc;
- (NSString *)lowRoundString;
- (NSInteger)seasonIndexForLowRoundForYear:(WBYear *)year;

- (NSInteger)lowNetForYear:(WBYear *)year;
- (NSString *)lowNetString;
- (NSInteger)seasonIdexForLowNetForYear:(WBYear *)year;

- (CGFloat)averagePointsInYear:(WBYear *)year;
- (NSString *)averagePointsString;

- (NSInteger)improvedInYear:(WBYear *)year;
- (NSString *)improvedString;

- (CGFloat)averageScoreForYear:(WBYear *)year;
- (NSString *)averageScoreString;
- (CGFloat)averageNetScoreForYear:(WBYear *)year;
- (CGFloat)averageOpponentScoreForYear:(WBYear *)year;
- (CGFloat)averageOpponentNetScoreForYear:(WBYear *)year;

- (NSInteger)mostPointsInMatchForYear:(WBYear *)year;
- (NSInteger)seasonIndexForMostPointsInMatchForYear:(WBYear *)year;
- (NSInteger)totalPointsForYear:(WBYear *)year;

- (CGFloat)averageMarginOfVictoryForYear:(WBYear *)year;
- (CGFloat)averageMarginOfNetVictoryForYear:(WBYear *)year;

- (WBBoardData *)findHandicapBoardData;
- (WBBoardData *)findWinLossBoardData;
- (WBBoardData *)findLowScoreBoardData;
- (WBBoardData *)findAveragePointsBoardData;
- (WBBoardData *)findImprovedBoardData;
- (WBBoardData *)findLowNetBoardData;

@end
