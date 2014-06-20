#import "_WBPeopleEntity.h"

@interface WBPeopleEntity : _WBPeopleEntity {}

+ (WBPeopleEntity *)createPeopleWithName:(NSString *)name
                                    real:(BOOL)real
                               inContext:(NSManagedObjectContext *)moc;

+ (WBPeopleEntity *)leagueAverageInContext:(NSManagedObjectContext *)moc;
- (BOOL)isLeagueAverage;

+ (WBPeopleEntity *)peopleEntityWithName:(NSString *)name;

- (NSString *)shortName;
- (NSString *)firstName;

@end
