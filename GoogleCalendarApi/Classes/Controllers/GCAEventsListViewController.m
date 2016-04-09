//
//  EventsListTableViewController.m
//  GoogleCalendarApi
//
//  Created by Eray on 09/04/16.
//  Copyright © 2016 HipoBlog. All rights reserved.
//

#import "GCAEventsListViewController.h"
#import "GCAEvent.h"

NSString * const kGCAEventCellIdentifier = @"kGCAEventCellIdentifier";


@interface GCAEventsListViewController ()

@property (nonatomic, strong) NSArray *events;

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
    return 60.0;
}

#pragma mark - Cell Configuration

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    GCAEvent *event = _events[indexPath.row];

    cell.textLabel.text = event.name;
    cell.detailTextLabel.text = event.content;
}

@end
