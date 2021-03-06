/* Copyright (c) 2015 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
//  GTLCalendarEventReminder.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   Calendar API (calendar/v3)
// Description:
//   Lets you manipulate events and other calendar data.
// Documentation:
//   https://developers.google.com/google-apps/calendar/firstapp
// Classes:
//   GTLCalendarEventReminder (0 custom class methods, 2 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

// ----------------------------------------------------------------------------
//
//   GTLCalendarEventReminder
//

@interface GTLCalendarEventReminder : GTLObject

// The method used by this reminder. Possible values are:
// - "email" - Reminders are sent via email.
// - "sms" - Reminders are sent via SMS. These are only available for Google
// Apps for Work, Education, and Government customers. Requests to set SMS
// reminders for other account types are ignored.
// - "popup" - Reminders are sent via a UI popup.
@property (nonatomic, copy) NSString *method;

// Number of minutes before the start of the event when the reminder should
// trigger. Valid values are between 0 and 40320 (4 weeks in minutes).
@property (nonatomic, retain) NSNumber *minutes;  // intValue

@end
