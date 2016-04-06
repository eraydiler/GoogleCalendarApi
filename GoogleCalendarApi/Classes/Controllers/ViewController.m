//
//  ViewController.m
//  GoogleCalendarApi
//
//  Created by Eray on 03/04/16.
//  Copyright © 2016 HipoBlog. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];


    UIButton *fetchEventsButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [fetchEventsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [fetchEventsButton setTitle:@"Fetch events" forState:UIControlStateNormal];
    [fetchEventsButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [fetchEventsButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [fetchEventsButton addTarget:self
                          action:@selector(didTapFetchEventsButton:)
                forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:fetchEventsButton];

    [fetchEventsButton autoPinEdgesToSuperviewEdges];
}

#pragma mark - Actions

- (void)didTapFetchEventsButton:(id)sender {
    [self fetchEvents];
}

#pragma mark - Loading

- (void)fetchEvents {
    
}

@end
