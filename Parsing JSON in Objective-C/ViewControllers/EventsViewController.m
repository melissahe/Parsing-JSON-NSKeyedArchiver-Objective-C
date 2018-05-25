//
//  ViewController.m
//  Parsing JSON in Objective-C
//
//  Created by C4Q on 5/21/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import "EventsViewController.h"
#import "MeetupAPI.h"
#import "Event.h"
#import "EventCell.h"
#import "EventDetailViewController.h"
#define CELLID @"eventCell"

@interface EventsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray <Event *> *eventsArray;
@end

@implementation EventsViewController

#pragma mark - Setup UI

- (void)viewDidLoad {
    [super viewDidLoad];
    //what's the difference between .class and .self
    [self.tableView registerClass:EventCell.class forCellReuseIdentifier: CELLID];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
}

//what happens when search bar is used
- (void)searchEventsWithKeyword:(NSString *)keyword {
    [[MeetupAPI sharedManager] searchEventsForKeyword:keyword completionHandler:^(NSError *error, NSArray<Event *> *eventsArray) {
        if (error) {
            //TODO - error handling
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error.localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){}];
            [alertVC addAction:okAction];
            [self presentViewController:alertVC animated:YES completion:^{}];
        } else if (eventsArray) {
            self.eventsArray = eventsArray;
            self.navigationItem.title = [NSString stringWithFormat:@"%lu Events", eventsArray.count];
            [self.tableView reloadData];
        }
    }];
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
                Event *selectedEvent = self.eventsArray[indexPath.row];
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
    EventCell *eventCell = [tableView cellForRowAtIndexPath:indexPath];
    if (eventCell) {
        [self performSegueWithIdentifier:@"detailedSegue" sender:eventCell];
    }
}

#pragma mark - Table View Data Source Methods

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    EventCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    Event *currentEvent = self.eventsArray[indexPath.row];
    //set up cell
    [cell configureCellWithEvent:currentEvent];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.eventsArray.count;
}

#pragma mark - Search Bar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchEventsWithKeyword:searchBar.text];
    [searchBar resignFirstResponder];
}


@end
