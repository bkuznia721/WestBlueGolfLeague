#import "WBPlayerYearData.h"
#import "WBPlayer.h"
#import "WBTeam.h"
#import "WBYear.h"

@interface WBPlayerYearData ()

@end


@implementation WBPlayerYearData

+ (WBPlayerYearData *)createPlayerYearDataWithId:(NSInteger)dataId
                                       forPlayer:(WBPlayer *)player
                                            year:(WBYear *)year
                                          onTeam:(WBTeam *)team
                            withStartingHandicap:(NSInteger)startingHandicap
                           withFinishingHandicap:(NSInteger)finishingHandicap
                                        isRookie:(BOOL)isRookie
                                             moc:(NSManagedObjectContext *)moc {
    if (!team) {
        DLog(@"no team");
    }
    
	WBPlayerYearData *newData = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
    newData.idValue = dataId;
	newData.startingHandicapValue = startingHandicap;
	newData.finishingHandicapValue = finishingHandicap;
	newData.isRookieValue = isRookie;
	
	[player addYearDataObject:newData];
	[team addPlayerYearDataObject:newData];
	[year addPlayerYearDataObject:newData];
	return newData;
}

@end
