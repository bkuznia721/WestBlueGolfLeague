#import "_WBMatch.h"

@interface WBMatch : _WBMatch {}

+ (WBMatch *)createMatchForTeamMatchup:(WBTeamMatchup *)teamMatchup
							   player1:(WBPlayer *)player1
							   player2:(WBPlayer *)player2
								   moc:(NSManagedObjectContext *)moc;

- (NSInteger)pairing;

- (NSArray *)displayStrings;

@end
