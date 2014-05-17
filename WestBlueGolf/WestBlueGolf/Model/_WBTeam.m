// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBTeam.m instead.

#import "_WBTeam.h"

const struct WBTeamAttributes WBTeamAttributes = {
	.teamId = @"teamId",
};

const struct WBTeamRelationships WBTeamRelationships = {
	.matchups = @"matchups",
	.playerYearData = @"playerYearData",
	.results = @"results",
};

const struct WBTeamFetchedProperties WBTeamFetchedProperties = {
};

@implementation WBTeamID
@end

@implementation _WBTeam

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBTeam" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBTeam";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBTeam" inManagedObjectContext:moc_];
}

- (WBTeamID*)objectID {
	return (WBTeamID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"teamIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"teamId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic teamId;



- (int16_t)teamIdValue {
	NSNumber *result = [self teamId];
	return [result shortValue];
}

- (void)setTeamIdValue:(int16_t)value_ {
	[self setTeamId:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveTeamIdValue {
	NSNumber *result = [self primitiveTeamId];
	return [result shortValue];
}

- (void)setPrimitiveTeamIdValue:(int16_t)value_ {
	[self setPrimitiveTeamId:[NSNumber numberWithShort:value_]];
}





@dynamic matchups;

	
- (NSMutableSet*)matchupsSet {
	[self willAccessValueForKey:@"matchups"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"matchups"];
  
	[self didAccessValueForKey:@"matchups"];
	return result;
}
	

@dynamic playerYearData;

	
- (NSMutableSet*)playerYearDataSet {
	[self willAccessValueForKey:@"playerYearData"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"playerYearData"];
  
	[self didAccessValueForKey:@"playerYearData"];
	return result;
}
	

@dynamic results;

	
- (NSMutableSet*)resultsSet {
	[self willAccessValueForKey:@"results"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"results"];
  
	[self didAccessValueForKey:@"results"];
	return result;
}
	






@end
