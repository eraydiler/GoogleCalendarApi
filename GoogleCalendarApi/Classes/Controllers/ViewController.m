//
//  ViewController.m
//  GoogleCalendarApi
//
//  Created by Eray on 03/04/16.
//  Copyright © 2016 HipoBlog. All rights reserved.
//

#import "ViewController.h"

static NSString const *kEventbrideEventsSearchURL = @"https://www.eventbriteapi.com/v3/events/search/";
static NSString const *kEventbrideAuthToken = @"P7JYFMA5ZWTJBVQ4T6BI";

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
    HIPNetworkClient *networkClient = [HIPNetworkClient new];

    // Prepare url
    NSString *requestURLString = [NSString stringWithFormat:@"%@?token=%@",
                                                                kEventbrideEventsSearchURL,
                                                                kEventbrideAuthToken];

    NSURL *requestURL = [NSURL URLWithString:requestURLString];

    NSURLRequest *fetchRequest = [networkClient requestWithURL:requestURL
                                                        method:HIPNetworkClientRequestMethodGet
                                                          data:nil];

    [networkClient performRequest:fetchRequest
                    withParseMode:HIPNetworkClientParseModeJSON
                       identifier:nil
                        indexPath:nil
                     cacheResults:NO
                completionHandler:^(id parsedData, NSURLResponse *response, NSError *error) {
                    if (error == nil) {
                        NSLog(@"FETCH SUCESS");
                    }
                }];
}

@end
