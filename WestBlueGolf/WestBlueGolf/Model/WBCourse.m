#import "WBCourse.h"
#import "WBCoreDataManager.h"

@interface WBCourse ()

@end

@implementation WBCourse

+ (WBCourse *)createCourseWithName:(NSString *)name
							   par:(NSInteger)par {
	WBCourse *newCourse = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] context]];
	newCourse.name = name;
	newCourse.parValue = par;
	return newCourse;
}

+ (WBCourse *)courseWithName:(NSString *)name par:(NSInteger)par {
	WBCourse *course = (WBCourse *)[WBCourse findFirstRecordWithFormat:@"name = %@", name];
	if (!course) {
		course = [WBCourse createCourseWithName:name par:par];
	}
	return course;
}

- (NSString *)shortName {
	NSString *firstName = [self.name componentsSeparatedByString:@" "][0];
	if ([firstName isEqualToString:self.name]) {
		return [firstName substringToIndex:5];
	}

	NSString *secondName = [self.name componentsSeparatedByString:@" "][1];
	
	NSString *shortFirstName = [NSString stringWithFormat:@"%@", [firstName substringToIndex:2]];
	NSString *shortSecondName = [NSString stringWithFormat:@"%@", [secondName substringToIndex:1]];
	return [NSString stringWithFormat:@"%@-%@", shortFirstName, shortSecondName];
}

@end
