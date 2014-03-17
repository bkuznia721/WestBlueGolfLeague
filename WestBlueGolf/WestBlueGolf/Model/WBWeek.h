#import "_WBWeek.h"

@interface WBWeek : _WBWeek {}

+ (WBWeek *)createWeekWithDate:(NSDate *)date
						inYear:(WBYear *)year
					 forCourse:(WBCourse *)course
				   seasonIndex:(NSInteger)seasonIndex;

+ (WBWeek *)weekWithId:(NSInteger)weekId inYear:(WBYear *)year;

@end
