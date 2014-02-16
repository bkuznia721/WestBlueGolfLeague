#import "WBCourse.h"
#import "WBCoreDataManager.h"

@interface WBCourse ()

@end

@implementation WBCourse

+ (WBCourse *)createCourseWithName:(NSString *)name
							   par:(NSInteger)par {
	WBCourse *newCourse = [NSEntityDescription insertNewObjectForEntityForName:@"WBCourse" inManagedObjectContext:[[self class] managedObjectContext]];
	newCourse.name = name;
	newCourse.parValue = par;
	
	[[WBCoreDataManager sharedManager] saveContext];
	return newCourse;
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

@end
