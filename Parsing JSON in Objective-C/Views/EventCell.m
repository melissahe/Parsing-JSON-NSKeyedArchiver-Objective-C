//
//  EventCell.m
//  Parsing JSON in Objective-C
//
//  Created by C4Q on 5/24/18.
//  Copyright © 2018 Melissa He @ C4Q. All rights reserved.
//

#import "EventCell.h"
//name of macro should be all caps so that people know to look for the constant somewhere, otherwise if it's lowercase, people might start looking for a local variable
#define PADDING 10

//class extension - you made this class
//category - extending sdk class, doesn't belong to you
@interface EventCell ()

@property (nonatomic) UILabel *eventNameLabel;
@property (nonatomic) UILabel *eventCreatedLabel;
@property (nonatomic) UILabel *groupNameLabel;
@property (nonatomic) UIImageView *eventImageView;

@end

@implementation EventCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:@"eventCell"];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self setupViews];
}

- (void)setupViews {
    [self setupEventImageView];
    [self setupEventNameLabel];
    [self setupEventCreatedLabel];
    [self setupGroupNameLabel];
}

- (void)setupEventImageView {
    if (!_eventImageView) {
        _eventImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"placeholder-image"]];
    }
    [self.contentView addSubview:self.eventImageView];
    self.eventImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.eventImageView.clipsToBounds = YES;
    
    //set constraints using batch constraints
    self.eventImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints: @[
                                               [self.eventImageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor],
                                               [self.eventImageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
                                               [self.eventImageView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
                                               [self.eventImageView.widthAnchor constraintEqualToAnchor:self.contentView.heightAnchor]
                                               ]];
}

- (void)setupEventNameLabel {
    if (!_eventNameLabel) {
        _eventNameLabel = [[UILabel alloc] init];
    }
    [self.contentView addSubview:self.eventNameLabel];
    self.eventNameLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    self.eventNameLabel.numberOfLines = 0;
    [self.eventNameLabel setContentHuggingPriority:252 forAxis:UILayoutConstraintAxisVertical];
    
    //setup constraints
    self.eventNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints: @[
                                               [self.eventNameLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:PADDING],
                                          [self.eventNameLabel.leadingAnchor constraintEqualToAnchor:self.eventImageView.trailingAnchor constant:PADDING],
                                               [self.eventNameLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-PADDING]
                                               ]];
}

- (void)setupEventCreatedLabel {
    if (!_eventCreatedLabel) {
        _eventCreatedLabel = [[UILabel alloc] init];
    }
    [self.contentView addSubview:self.eventCreatedLabel];
    self.eventCreatedLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
    self.eventCreatedLabel.numberOfLines = 1;
    [self.eventCreatedLabel setContentHuggingPriority:253 forAxis:UILayoutConstraintAxisVertical];
    
    //setup constraints
    self.eventCreatedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints: @[
                                               [self.eventCreatedLabel.topAnchor constraintEqualToAnchor:self.eventNameLabel.bottomAnchor constant:PADDING],
                                               [self.eventCreatedLabel.leadingAnchor constraintEqualToAnchor:self.eventImageView.trailingAnchor constant:PADDING],
                                               ]];
}

- (void)setupGroupNameLabel {
    if (!_groupNameLabel) {
        _groupNameLabel = [[UILabel alloc] init];
    }
    [self.contentView addSubview:self.groupNameLabel];
    self.groupNameLabel.font = [UIFont systemFontOfSize:15];
    self.groupNameLabel.numberOfLines = 1;
    [self.groupNameLabel setContentHuggingPriority:249 forAxis:UILayoutConstraintAxisHorizontal];
    [self.groupNameLabel setContentCompressionResistancePriority:1000 forAxis:UILayoutConstraintAxisVertical];
    
    //setup constraints
    self.groupNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints: @[
                                               [self.groupNameLabel.topAnchor constraintEqualToAnchor:self.eventCreatedLabel.bottomAnchor],
                                               [self.groupNameLabel.leadingAnchor constraintEqualToAnchor:self.eventImageView.trailingAnchor constant:PADDING],
                                               [self.groupNameLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-PADDING],
                                               [self.groupNameLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-PADDING]
                                               
                                               ]];
}

- (void)configureCellWithEvent:(Event *)event {
    //setup name
    self.eventNameLabel.text = event.eventName;
    
    //setup date
    self.eventCreatedLabel.text = event.eventDate;
    
    //setup group
    self.groupNameLabel.text = event.groupName;
    
    //setup image
    self.eventImageView.image = NULL;
    if (event.highResLink) {
        //this should be done on the background thread, otherwise threadlocking occurs
        [[ImageCache sharedManager] downloadImageWithURLString:event.highResLink completionHandler:^(NSError *error, UIImage *image) {
            if (error) {
                self.eventImageView.image = [UIImage imageNamed:@"placeholder-image"];
                NSLog(@"Could not get image with error: %@", error.localizedDescription);
            } else if (image) {
                self.eventImageView.image = image;
                [[ImageCache sharedManager] storeImage:image withKey:event.highResLink];
            }
        }];
    } else {
        self.eventImageView.image = [UIImage imageNamed:@"placeholder-image"];
    }
}

@end
