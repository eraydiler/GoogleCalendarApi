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

@property (nonatomic, strong) UIButton *fetchEventsButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor whiteColor]];

    // Fetch events button
    _fetchEventsButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [_fetchEventsButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_fetchEventsButton setTitle:@"Fetch events" forState:UIControlStateNormal];
    [_fetchEventsButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_fetchEventsButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_fetchEventsButton addTarget:self
                          action:@selector(didTapFetchEventsButton:)
                forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:_fetchEventsButton];

    [_fetchEventsButton autoPinEdgesToSuperviewEdges];

    // Activity indicator
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initForAutoLayout];

    _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;

    [self.view addSubview:_activityIndicatorView];

    [_activityIndicatorView autoPinEdgesToSuperviewEdges];
}

#pragma mark - Actions

- (void)didTapFetchEventsButton:(id)sender {
    [self fetchEvents];
}

#pragma mark - Loading

- (void)fetchEvents {
    [self showActivityIndicator:YES];

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

                    [self showActivityIndicator:NO];
                }];
}

- (void)showActivityIndicator:(BOOL)show {
    _fetchEventsButton.hidden = show;

    if (show) {
        [_activityIndicatorView startAnimating];
    } else {
        [_activityIndicatorView stopAnimating];
    }
}

@end
