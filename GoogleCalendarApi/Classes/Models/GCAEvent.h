//
//  GCAEvent.h
//  GoogleCalendarApi
//
//  Created by Eray on 03/04/16.
//  Copyright © 2016 HipoBlog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCAEvent : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, assign, getter=isAdded) BOOL added;

@end
