#import "WBPeopleEntity.h"

#define LEAGUE_AVERAGE_NAME @"=League Average="

@interface WBPeopleEntity ()
@end

@implementation WBPeopleEntity

+ (WBPeopleEntity *)createPeopleWithId:(NSInteger)peopleId
                                  name:(NSString *)name
                                  real:(BOOL)real
                             inContext:(NSManagedObjectContext *)moc {
	id entity = [self createEntityInContext:moc];
	WBPeopleEntity *newPeople = (WBPeopleEntity *)entity;
    newPeople.idValue = peopleId;
	newPeople.name = name;
	return newPeople;
}

+ (WBPeopleEntity *)leagueAverageInContext:(NSManagedObjectContext *)moc {
	WBPeopleEntity *avg = (WBPeopleEntity *)[self findFirstRecordWithFormat:@"name = %@", LEAGUE_AVERAGE_NAME];
	if (!avg) {
		avg = [WBPeopleEntity createPeopleWithId:-1 name:LEAGUE_AVERAGE_NAME real:NO inContext:moc];
	}
	return avg;
}

- (BOOL)isLeagueAverage {
	return [self.name isEqualToString:LEAGUE_AVERAGE_NAME];
}

+ (WBPeopleEntity *)peopleEntityWithName:(NSString *)name {
	return (WBPeopleEntity *)[WBPeopleEntity findFirstRecordWithFormat:@"name = %@", name];
}

- (NSString *)firstName {
	return [self.name componentsSeparatedByString:@" "][0];
}

- (NSString *)shortName {
	NSString *firstName = [self firstName];
	if ([firstName isEqualToString:self.name]) {
		return firstName;
	}

	NSString *shortFirstName = [NSString stringWithFormat:@"%@.", [firstName substringToIndex:1]];
	return [self.name stringByReplacingOccurrencesOfString:firstName withString:shortFirstName];
}

+ (WBPeopleEntity *)findWithId:(NSInteger)peopleId {
	return (WBPeopleEntity *)[[self class] findFirstRecordWithFormat:@"id = %@", [NSNumber numberWithInteger:peopleId]];
}

@end
