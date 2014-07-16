//
//  AppDelegate.h
//  Freshbooks Timer Status Bar
//
//  Created by Carlos Solares on 7/3/14.
//  Copyright (c) 2014 loslabs.io. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSNumber *startTime;
    NSNumber *endTime;
    NSTimer *timer;
    NSString *freshTimerString;
}

@property (readwrite, retain) IBOutlet NSMenu *menu;
@property (readwrite, retain) IBOutlet NSStatusItem *statusItem;

@property (assign) IBOutlet NSWindow *window;
@property (strong, nonatomic) IBOutlet WebView *webView;



@property (unsafe_unretained) IBOutlet NSWindow *settingWindow;
@property (strong) IBOutlet NSTextField *domainTextField;


//file stuff
@property (strong, nonatomic) NSString *bundlePath;
@property (strong, nonatomic) NSString *path;
@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSMutableDictionary *userData;



- (IBAction)menuAction:(id)sender;
- (IBAction)startTimer:(id)sender;
- (IBAction)stopTimer:(id)sender;
- (IBAction)exitApp:(id)sender;
- (IBAction)openSetting:(id)sender;
- (IBAction)saveSetting:(id)sender;


@end
