//
//  GCAEventResponse.h
//  GoogleCalendarApi
//
//  Created by Eray on 09/04/16.
//  Copyright © 2016 HipoBlog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCAEventsSearchResponse : NSObject

@property (nonatomic, strong, readonly) NSArray *events;

- (instancetype)initWithParsedData:(NSDictionary *)parsedData;

@end
