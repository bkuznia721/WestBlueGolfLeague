// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBWeek.m instead.

#import "_WBWeek.h"

const struct WBWeekAttributes WBWeekAttributes = {
	.date = @"date",
	.seasonIndex = @"seasonIndex",
};

const struct WBWeekRelationships WBWeekRelationships = {
	.course = @"course",
	.teamMatchups = @"teamMatchups",
	.year = @"year",
};

const struct WBWeekFetchedProperties WBWeekFetchedProperties = {
};

@implementation WBWeekID
@end

@implementation _WBWeek

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBWeek" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBWeek";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBWeek" inManagedObjectContext:moc_];
}

- (WBWeekID*)objectID {
	return (WBWeekID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"seasonIndexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"seasonIndex"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic date;






@dynamic seasonIndex;



- (int16_t)seasonIndexValue {
	NSNumber *result = [self seasonIndex];
	return [result shortValue];
}

- (void)setSeasonIndexValue:(int16_t)value_ {
	[self setSeasonIndex:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSeasonIndexValue {
	NSNumber *result = [self primitiveSeasonIndex];
	return [result shortValue];
}

- (void)setPrimitiveSeasonIndexValue:(int16_t)value_ {
	[self setPrimitiveSeasonIndex:[NSNumber numberWithShort:value_]];
}





@dynamic course;

	

@dynamic teamMatchups;

	
- (NSMutableSet*)teamMatchupsSet {
	[self willAccessValueForKey:@"teamMatchups"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"teamMatchups"];
  
	[self didAccessValueForKey:@"teamMatchups"];
	return result;
}
	

@dynamic year;

	






@end