//
//  GCAEventResponse.m
//  GoogleCalendarApi
//
//  Created by Eray on 09/04/16.
//  Copyright © 2016 HipoBlog. All rights reserved.
//

#import "GCAEventsSearchResponse.h"

#import "GCAEvent.h"

@implementation GCAEventsSearchResponse

- (instancetype)initWithParsedData:(NSDictionary *)parsedData {
    self = [super init];

    if (self) {
        [self parseEventsFromParsedData:parsedData];
    }

    return self;
}

- (void)parseEventsFromParsedData:(NSDictionary *)parsedData {
    NSArray *eventsData = parsedData[@"events"];

    NSMutableArray *events = [NSMutableArray array];

    for (NSDictionary *anEvent in eventsData) {
        GCAEvent *event = [GCAEvent new];

        event.name = anEvent[@"name"][@"text"];
        event.content = anEvent[@"description"][@"text"];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];

        NSString *startDate = anEvent[@"start"][@"local"];
        event.startDate = [dateFormatter dateFromString:startDate];

        NSString *endDate = anEvent[@"end"][@"local"];
        event.endDate = [dateFormatter dateFromString:endDate];

        [events addObject:event];
    }

    _events = events;
}

@end
