//
//  AppDelegate.h
//  Freshbooks Timer Status Bar
//
//  Created by Carlos Solares on 7/3/14.
//  Copyright (c) 2014 loslabs.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSNumber *startTime;
    NSNumber *endTime;
    NSTimer *timer;
}

@property (readwrite, retain) IBOutlet NSMenu *menu;
@property (readwrite, retain) IBOutlet NSStatusItem *statusItem;

- (IBAction)menuAction:(id)sender;
- (IBAction)startTimer:(id)sender;
- (IBAction)stopTimer:(id)sender;
- (IBAction)exitApp:(id)sender;


@end
