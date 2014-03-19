//
//  WBAppDelegate.m
//  West Blue Golf
//
//  Created by Mike Harlow on 1/22/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBAppDelegate.h"
#import "WBCoreDataManager.h"
#import "WBHandicapManager.h"
#import "WBInputDataManager.h"
#import "WBLeaderBoardManager.h"
#import "WBModels.h"
#import "WBNotifications.h"
#import "WBProfileTableViewController.h"

@interface WBAppDelegate ()

@property (assign, nonatomic) NSInteger yearSelection;

@end

@implementation WBAppDelegate

- (NSInteger)thisYearValue {
	return self.yearSelection;
}

- (void)setThisYearValue:(NSInteger)value {
	self.yearSelection = value;
	[[NSNotificationCenter defaultCenter] postNotificationName:WBYearChangedNotification object:nil];
}

- (void)setLoading:(BOOL)loading {
	_loading = loading;
	[[NSNotificationCenter defaultCenter] postNotificationName:WBLoadingFinishedNotification object:nil];
}

- (void)loadAndCalculateForYear:(NSInteger)yearValue {
	WBInputDataManager *inputManager = [[WBInputDataManager alloc] init];
	[inputManager loadJsonDataForYearValue:yearValue];
	WBYear *year = [WBYear yearWithValue:yearValue];
	WBHandicapManager *handiManager = [[WBHandicapManager alloc] init];
	[handiManager calculateHandicapsForYear:year];
	WBLeaderBoardManager *boardManager = [[WBLeaderBoardManager alloc] init];
	[boardManager calculateLeaderBoardsForYear:year];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupCoreData:NO];
	
	[self subscribeToNotifications];

    return YES;
}

- (void)setupCoreData:(BOOL)reset {
	if (reset) {
		[[WBCoreDataManager sharedManager] resetManagedObjectContextAndPersistentStore];
	}
	//[WBCoreDataManager sharedManager];
	
	WBYear *year = [WBYear newestYear];
	self.yearSelection = year.valueValue;
	
	if (!year) {
		WBInputDataManager *inputManager = [[WBInputDataManager alloc] init];
		[inputManager createYears];
		
		[self setThisYearValue:[WBYear newestYear].valueValue];
		
		[self resetYear];
	}
}

- (void)resetYear {
	WBYear *newYear = [WBYear thisYear];
	if (!newYear.weeks || newYear.weeks.count == 0) {
		self.loading = YES;
		[self loadAndCalculateForYear:newYear.valueValue];
		[self performSelector:@selector(setLoading:) withObject:NO afterDelay:3.0];
	}

	[[NSNotificationCenter defaultCenter] postNotificationName:WBYearChangedLoadingFinishedNotification object:nil];
}

- (void)setProfileTabPlayer {
	WBPlayer *me = [WBPlayer me];
	UITabBarController *tbc = (UITabBarController *)self.window.rootViewController;
	UINavigationController *profileTab = (UINavigationController *)[tbc.viewControllers objectAtIndex:0];
	((WBProfileTableViewController *)profileTab.topViewController).selectedPlayer = me;
}

- (BOOL)isProfileTab:(UIViewController *)vc {
	UITabBarController *tbc = (UITabBarController *)self.window.rootViewController;
	UINavigationController *navc = (UINavigationController *)[tbc.viewControllers objectAtIndex:0];
	return vc == navc.topViewController;
}

- (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	[self unsubscribeFromNotfications];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	[self unsubscribeFromNotfications];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	[self subscribeToNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	[self subscribeToNotifications];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	[self unsubscribeFromNotfications];
}

- (void)subscribeToNotifications {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(resetYear)
												 name:WBYearChangedNotification
											   object:nil];
}

- (void)unsubscribeFromNotfications {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
