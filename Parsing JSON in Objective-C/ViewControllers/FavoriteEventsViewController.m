//
//  FavoriteEventsViewController.m
//  Parsing JSON in Objective-C
//
//  Created by C4Q on 5/25/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import "FavoriteEventsViewController.h"
#import "FavoriteEventsAPI.h"
#import "EventCell.h"
#import "EventDetailViewController.h"
#define CELLID @"eventCell"

@interface FavoriteEventsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *favoriteEventsArray;
@end

@implementation FavoriteEventsViewController

#pragma mark - Setup UI

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)configureSubviews {
    [self.tableView registerClass:EventCell.self forCellReuseIdentifier:CELLID];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _favoriteEventsArray = [[FavoriteEventsAPI sharedManager] getEvents];
}

#pragma mark - Setup Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailedSegue"]) {
        //get current cell
        EventCell *eventCell = sender;
        if (eventCell) {
            //get indexPath
            NSIndexPath *indexPath = [self.tableView indexPathForCell:eventCell];
            if (indexPath) {
                Event *selectedEvent = self.favoriteEventsArray[indexPath.row];
                EventDetailViewController *eventDetailVC = segue.destinationViewController;
                if (eventDetailVC) {
                    eventDetailVC.event = selectedEvent;
                }
            }
        }
    }
}

#pragma mark - Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EventCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        [self performSegueWithIdentifier:@"detailedSegue" sender:cell];
    }
}

#pragma mark - Table View Datasource Methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    Event *currentEvent = self.favoriteEventsArray[indexPath.row];
    [cell configureCellWithEvent:currentEvent];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.favoriteEventsArray.count;
}

@end
