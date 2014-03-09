// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBBoardData.m instead.

#import "_WBBoardData.h"

const struct WBBoardDataAttributes WBBoardDataAttributes = {
	.rank = @"rank",
	.value = @"value",
};

const struct WBBoardDataRelationships WBBoardDataRelationships = {
	.leaderBoard = @"leaderBoard",
	.peopleEntity = @"peopleEntity",
};

const struct WBBoardDataFetchedProperties WBBoardDataFetchedProperties = {
};

@implementation WBBoardDataID
@end

@implementation _WBBoardData

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"WBBoardData" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"WBBoardData";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"WBBoardData" inManagedObjectContext:moc_];
}

- (WBBoardDataID*)objectID {
	return (WBBoardDataID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"rankValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rank"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"valueValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"value"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic rank;



- (int16_t)rankValue {
	NSNumber *result = [self rank];
	return [result shortValue];
}

- (void)setRankValue:(int16_t)value_ {
	[self setRank:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveRankValue {
	NSNumber *result = [self primitiveRank];
	return [result shortValue];
}

- (void)setPrimitiveRankValue:(int16_t)value_ {
	[self setPrimitiveRank:[NSNumber numberWithShort:value_]];
}





@dynamic value;



- (int16_t)valueValue {
	NSNumber *result = [self value];
	return [result shortValue];
}

- (void)setValueValue:(int16_t)value_ {
	[self setValue:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveValueValue {
	NSNumber *result = [self primitiveValue];
	return [result shortValue];
}

- (void)setPrimitiveValueValue:(int16_t)value_ {
	[self setPrimitiveValue:[NSNumber numberWithShort:value_]];
}





@dynamic leaderBoard;

	

@dynamic peopleEntity;

	






@end
