//
//  MRRootTableViewController.m
//  MRSwipeCell
//
//  Created by Jose Luis Martinez de la Riva on 24/01/14.
//  Copyright (c) 2014 Jose Luis Martinez de la Riva. All rights reserved.
//

// Controllers
#import "MRRootTableViewController.h"

// Views
#import "MRLabelViewCell.h"

@interface MRRootTableViewController () <MRSwipeCellDelegate>
@property (strong, nonatomic) NSMutableArray *openIndexPathArray;
@end

@implementation MRRootTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[MRLabelViewCell class] forCellReuseIdentifier:@"MRLabelViewCell"];
    self.openIndexPathArray = [NSMutableArray array];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MRLabelViewCell";
    MRLabelViewCell *cell = (MRLabelViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    if ([self.openIndexPathArray containsObject:[NSNumber numberWithInteger:indexPath.row]]) {
        [cell setInitialRightViewState:MRSwipeTableViewCellStateRight];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    MRSwipeTableViewCell *cell = (MRSwipeTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.state == MRSwipeTableViewCellStateCenter) {
        return YES;
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row selected: %ld", (long)indexPath.row);
}

#pragma mark - MRSwipeCell Delegate

- (void)didHideRightView:(MRSwipeTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.openIndexPathArray removeObject:[NSNumber numberWithInteger:indexPath.row]];

    NSLog(@"Hide rightView for indexPath.row %ld", (long)indexPath.row);
}

- (void)didShowRightView:(MRSwipeTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.openIndexPathArray addObject:[NSNumber numberWithInteger:indexPath.row]];
    
    NSLog(@"Show rightView for indexPath.row %ld", (long)indexPath.row);
}

@end
