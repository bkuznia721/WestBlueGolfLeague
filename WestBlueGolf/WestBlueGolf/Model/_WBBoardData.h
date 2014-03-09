// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBBoardData.h instead.

#import <CoreData/CoreData.h>


extern const struct WBBoardDataAttributes {
	__unsafe_unretained NSString *rank;
	__unsafe_unretained NSString *value;
} WBBoardDataAttributes;

extern const struct WBBoardDataRelationships {
	__unsafe_unretained NSString *leaderBoard;
	__unsafe_unretained NSString *peopleEntity;
} WBBoardDataRelationships;

extern const struct WBBoardDataFetchedProperties {
} WBBoardDataFetchedProperties;

@class WBLeaderBoard;
@class WBPeopleEntity;




@interface WBBoardDataID : NSManagedObjectID {}
@end

@interface _WBBoardData : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBBoardDataID*)objectID;





@property (nonatomic, strong) NSNumber* rank;



@property int16_t rankValue;
- (int16_t)rankValue;
- (void)setRankValue:(int16_t)value_;

//- (BOOL)validateRank:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* value;



@property int16_t valueValue;
- (int16_t)valueValue;
- (void)setValueValue:(int16_t)value_;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) WBLeaderBoard *leaderBoard;

//- (BOOL)validateLeaderBoard:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) WBPeopleEntity *peopleEntity;

//- (BOOL)validatePeopleEntity:(id*)value_ error:(NSError**)error_;





@end

@interface _WBBoardData (CoreDataGeneratedAccessors)

@end

@interface _WBBoardData (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveRank;
- (void)setPrimitiveRank:(NSNumber*)value;

- (int16_t)primitiveRankValue;
- (void)setPrimitiveRankValue:(int16_t)value_;




- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (int16_t)primitiveValueValue;
- (void)setPrimitiveValueValue:(int16_t)value_;





- (WBLeaderBoard*)primitiveLeaderBoard;
- (void)setPrimitiveLeaderBoard:(WBLeaderBoard*)value;



- (WBPeopleEntity*)primitivePeopleEntity;
- (void)setPrimitivePeopleEntity:(WBPeopleEntity*)value;


@end
