//
//  WBWeekTableViewController.m
//  WestBlueGolf
//
//  Created by Mike Harlow on 3/7/14.
//  Copyright (c) 2014 Mike Harlow. All rights reserved.
//

#import "WBWeekTableViewController.h"
#import "WBMatchupResultDataSource.h"

@interface WBWeekTableViewController ()

@property (strong, nonatomic) WBMatchupResultDataSource *dataSource;

@end

@implementation WBWeekTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.dataSource = [WBMatchupResultDataSource dataSourceWithViewController:self];

    self.tableView.dataSource = self.dataSource;
	self.tableView.delegate = self.dataSource;
	
	[self.dataSource beginFetch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
