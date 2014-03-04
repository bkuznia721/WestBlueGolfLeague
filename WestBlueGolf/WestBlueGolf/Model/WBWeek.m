#import "WBWeek.h"
#import "WBCoreDataManager.h"
#import "WBCourse.h"
#import "WBYear.h"

@interface WBWeek ()

@end

@implementation WBWeek

+ (WBWeek *)createWeekWithDate:(NSDate *)date
						inYear:(WBYear *)year
					 forCourse:(WBCourse *)course {
	WBWeek *newWeek = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] managedObjectContext]];
	newWeek.date = date;
	newWeek.year = year;
	newWeek.seasonIndexValue = [year.weeks count] + 1;
	
	[course addWeeksObject:newWeek];
	
	[WBCoreDataManager saveContext];
	return newWeek;
}

- (void)deleteWeek {
	[[[self class] managedObjectContext] deleteObject:self];
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

@end
