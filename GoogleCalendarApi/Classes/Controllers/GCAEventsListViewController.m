//
//  EventsListTableViewController.m
//  GoogleCalendarApi
//
//  Created by Eray on 09/04/16.
//  Copyright © 2016 HipoBlog. All rights reserved.
//

#import "GCAEventsListViewController.h"
#import "GCAEvent.h"

static NSString * const kGoogleAPIClientID = @"";
static NSString * const kGoogleAPICalendarID = @"primary";
static NSString * const kGoogleAPIKeychainItemName = @"Google Calendar API";

NSString * const kGCAEventCellIdentifier = @"kGCAEventCellIdentifier";


@interface GCAEventsListViewController ()

@property (nonatomic, strong) NSArray *events;
@property (nonatomic, strong) GTLServiceCalendar *calendarService;
@property (nonatomic, strong) GTLCalendarEvent *calendarEvent;
@property (nonatomic, strong) NSIndexPath *currentSelectedIndexPath;
@property (nonatomic, assign) BOOL didCancelGoogleAuthentication;

- (void)configureCell:(UITableViewCell *)cell
          atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation GCAEventsListViewController

#pragma mark - Init

- (instancetype)initWithEvents:(NSArray *)events {
    self = [super init];

    if (self) {
        _events = events;
    }

    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:[kGCAEventCellIdentifier copy]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _events.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
      UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:kGCAEventCellIdentifier];

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _currentSelectedIndexPath = indexPath;

    _calendarService = [[GTLServiceCalendar alloc] init];

    _calendarService.authorizer = [GTMOAuth2ViewControllerTouch
                                   authForGoogleFromKeychainForName:kGoogleAPIKeychainItemName
                                   clientID:kGoogleAPIClientID
                                   clientSecret:nil];

    if (!_calendarService.authorizer.canAuthorize) {
        [self launchGoogleAuthenticationView];
    } else {
        [self addEventToGoogleCalendar];
    }
}

#pragma mark - Cell Configuration

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    GCAEvent *event = _events[indexPath.row];

    cell.textLabel.text = event.name;
    cell.detailTextLabel.numberOfLines = 4.0;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@", event.startDate,
                                                                          event.endDate,
                                                                          event.content];

    cell.detailTextLabel.enabled = cell.textLabel.enabled = !event.isAdded;
    cell.selectionStyle = (event.isAdded) ? UITableViewCellSelectionStyleNone
                                          : UITableViewCellSelectionStyleDefault;

}

#pragma mark - Google Calendar

- (void)didTapCloseButton:(id)sender {
    NSLog(@"CLOSE BUTTON TAPPED");
}

- (void)launchGoogleAuthenticationView {
    _didCancelGoogleAuthentication = NO;

    GTMOAuth2ViewControllerTouch *authController;

    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    NSArray *scopes = [NSArray arrayWithObjects:kGTLAuthScopeCalendar, nil];

    authController = [[GTMOAuth2ViewControllerTouch alloc]
                      initWithScope:[scopes componentsJoinedByString:@" "]
                      clientID:kGoogleAPIClientID
                      clientSecret:nil
                      keychainItemName:kGoogleAPIKeychainItemName
                      delegate:self
                      finishedSelector:@selector(googleAuthenticationViewController:finishedWithAuth:error:)];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [closeButton setTitle:@"Cancel" forState:UIControlStateNormal];

    [closeButton addTarget:self
                    action:@selector(didTapCloseButton:)
          forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc]
                                         initWithCustomView:closeButton];

    [authController.navigationItem setLeftBarButtonItem:closeButtonItem];

    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:authController];

    [self presentViewController:navController
                       animated:YES
                     completion:nil];
}

- (void)googleAuthenticationViewController:(GTMOAuth2ViewControllerTouch *)authViewController
                          finishedWithAuth:(GTMOAuth2Authentication *)authResult
                                     error:(NSError *)error {

    if (_didCancelGoogleAuthentication) {
        return;
    }

    if (error != nil) {
        UIAlertView *alert;

        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Authentication Error", nil)
                                           message:error.localizedDescription
                                          delegate:nil
                                 cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                 otherButtonTitles:nil];
        [alert show];

        _calendarService.authorizer = nil;
    } else {
        _calendarService.authorizer = authResult;

        [self dismissViewControllerAnimated:YES
                                 completion:^{
                                     [self addEventToGoogleCalendar];
                                 }];
    }
}

- (void)addEventToGoogleCalendar {
    GCAEvent *selectedEvent = _events[_currentSelectedIndexPath.row];

    if (selectedEvent.isAdded) {
        return;
    }

    _calendarEvent = [[GTLCalendarEvent alloc] init];

    [_calendarEvent setSummary:selectedEvent.name];
    [_calendarEvent setDescriptionProperty:selectedEvent.content];

    NSDate *startDate = selectedEvent.startDate;
    NSDate *endDate = selectedEvent.endDate;

    if (endDate == nil) {
        endDate = [startDate dateByAddingTimeInterval:(60 * 60)];
    }

    GTLDateTime *startTime = [GTLDateTime dateTimeWithDate:startDate
                                                  timeZone:[NSTimeZone systemTimeZone]];

    [_calendarEvent setStart:[GTLCalendarEventDateTime object]];
    [_calendarEvent.start setDateTime:startTime];

    GTLDateTime *endTime = [GTLDateTime dateTimeWithDate:endDate
                                                timeZone:[NSTimeZone systemTimeZone]];

    [_calendarEvent setEnd:[GTLCalendarEventDateTime object]];
    [_calendarEvent.end setDateTime:endTime];


    GTLQueryCalendar *insertQuery = [GTLQueryCalendar queryForEventsInsertWithObject:_calendarEvent
                                                                          calendarId:kGoogleAPICalendarID];
    [self showAlertWithTitle:nil
                  andMessage:NSLocalizedString(@"Adding Event…", nil)];

    [_calendarService executeQuery:insertQuery
                 completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
                     if (error == nil) {
                         [self showAlertWithTitle:nil
                                       andMessage:NSLocalizedString(@"Event Added!", nil)];

                         selectedEvent.added = YES;
                         [self.tableView reloadRowsAtIndexPaths:@[_currentSelectedIndexPath]
                                               withRowAnimation:YES];
                     } else {
                         [self showAlertWithTitle:NSLocalizedString(@"Event Entry Failed", nil)
                                       andMessage:NSLocalizedString(@"Could not add event, please try again.", nil)];
                     }
                 }];
}

#pragma mark - Helpers

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    UIAlertView *alert;

    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:message
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"OK", nil)
                             otherButtonTitles:nil];
    [alert show];

    [self performSelector:@selector(dismissAletView:)
               withObject:alert
               afterDelay:2.0];
}

- (void)dismissAletView:(UIAlertView *)alertView {
    [alertView dismissWithClickedButtonIndex:0
                                    animated:YES];
}

@end
