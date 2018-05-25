//
//  EventDetailViewController.m
//  Parsing JSON in Objective-C
//
//  Created by C4Q on 5/25/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import "EventDetailViewController.h"
#import "ImageCache.h"
#import "FavoriteEventsAPI.h"

@interface EventDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rsvpCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *eventDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *favoriteButton;
@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSubviews];
}

- (void)configureSubviews {
    //set up the labels, etc.
    [self setUpButton];
    [self setupLabels];
    [self setupTextView];
    [self setupImage];
}

- (void)eventIsFavorited {
    UIImage *heartFilled = [[UIImage imageNamed:@"heartFilled"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.favoriteButton setImage:heartFilled];
    [self.favoriteButton setTintColor:UIColor.redColor];
    [self.favoriteButton setImage:heartFilled];
}

- (void)setUpButton {
    NSArray<Event *> *favoriteEventsArray = [[FavoriteEventsAPI sharedManager] getEvents];
    Event *lastEvent = favoriteEventsArray.lastObject;
    if ([favoriteEventsArray containsObject:self.event]) {
        [self eventIsFavorited];
    }
}

- (void)setupLabels {
    //event name
    self.eventNameLabel.text = self.event.eventName;
    
    //group name
    self.groupNameLabel.text = self.event.groupName;
    
    //date label
    self.dateLabel.text = self.event.eventDate;
    
    //rsvp count
    self.rsvpCountLabel.text = [NSString stringWithFormat:@"RSVP: %ld", self.event.rsvpCount];
}

- (void)setupTextView {
    [self.eventDescriptionTextView setValue:self.event.eventDescription forKey:@"contentToHTMLString"];
}

- (void)setupImage {
    if (self.event.highResLink) {
        //grab image from cache
        UIImage *eventImage = [[ImageCache sharedManager] retrieveImageWithKey:self.event.highResLink];
        if (!eventImage) {
            //grab from online
            [[ImageCache sharedManager] downloadImageWithURLString:self.event.highResLink completionHandler:^(NSError *error, UIImage *image) {
                if (error) {
                    self.eventImageView.image = [UIImage imageNamed:@"placeholder-image"];
                    NSLog(@"Could not get image with error: %@", error.localizedDescription);
                } else if (image) {
                    self.eventImageView.image = image;
                    [[ImageCache sharedManager] storeImage:image withKey:self.event.highResLink];
                }
            }];
        } else {
            self.eventImageView.image = eventImage;
        }
    } else {
        self.eventImageView.image = [UIImage imageNamed:@"placeholder-image"];
    }
}

- (IBAction)favoriteButtonTapped:(UIBarButtonItem *)sender {
    UIAlertController *alertVC;
    //to do - save to favorites or unfavorite
    UIImage *favoriteButtonImage = sender.image;
    //if unsaved
    if ([favoriteButtonImage isEqual: [UIImage imageNamed:@"heartUnfilled"]]) {
        [self eventIsFavorited];
        
        BOOL addSuccess = [[FavoriteEventsAPI sharedManager] addEvent:self.event];
        
        if (addSuccess) {
            alertVC = [UIAlertController alertControllerWithTitle:@"Success!" message:@"This event was added to your favorites!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
            [alertVC addAction:okAction];
            [self presentViewController:alertVC animated:YES completion:^{}];
        }
    } else { //if saved
        [sender setImage: [UIImage imageNamed:@"heartUnfilled"]];
        [sender setTintColor:nil];
        
        BOOL removeSuccess = [[FavoriteEventsAPI sharedManager] removeEvent:self.event];
        if (!removeSuccess) {
            alertVC = [UIAlertController alertControllerWithTitle:@"ERROR" message:@"Could not remove this event from your favorites." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
            [alertVC addAction:okAction];
            [self presentViewController:alertVC animated:YES completion:^{}];
        }
    }
}

@end
