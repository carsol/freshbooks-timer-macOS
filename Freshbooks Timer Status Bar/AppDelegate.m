//
//  AppDelegate.m
//  Freshbooks Timer Status Bar
//
//  Created by Carlos Solares on 7/3/14.
//  Copyright (c) 2014 loslabs.io. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(handleEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
    LSSetDefaultHandlerForURLScheme((__bridge CFStringRef)@"FreshTimer", (__bridge CFStringRef)[[NSBundle mainBundle] bundleIdentifier]);
    
    // Insert code here to initialize your application
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.title = @"00:00";
    
    NSImage *menuIcon = [NSImage imageNamed:@"Menu Icon"];
    NSImage *highlightIcon = [NSImage imageNamed:@"Menu Icon"]; // Yes, we're using the exact same image asset.
    [highlightIcon setTemplate:YES]; // Allows the correct highlighting of the icon when the menu is clicked.
    
    [[self statusItem] setImage:menuIcon];
    [[self statusItem] setAlternateImage:highlightIcon];
    [[self statusItem] setMenu:[self menu]];
    [[self statusItem] setHighlightMode:YES];
    
    
    AFOAuth1Client *freshClient = [[AFOAuth1Client alloc] initWithBaseURL:[NSURL URLWithString:@"https://sonatechinc.freshbooks.com/api/2.1/xml-in"] key:@"05eb3c88633c045f6b99e83683e957ab" secret:@"9FfxUctCWbLz7DUCxkD7xR56KBnNVSmkF"];
    
    [freshClient registerHTTPOperationClass:[AFXMLRequestOperation class]];
    
    
    [freshClient authorizeUsingOAuthWithRequestTokenPath:@"/oauth/oauth_request.php" userAuthorizationPath:@"/oauth/oauth_authorize.php" callbackURL:[NSURL URLWithString:@"/sucess"] accessTokenPath:@"/oauth/oauth_access.php" accessMethod:@"POST" scope:nil success:^(AFOAuth1Token *accessToken, id responseObject) {

        NSLog(@"success");
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"bad %@", error);
    }];
    
}

- (void)handleEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent
{
    NSURL *url = [NSURL URLWithString:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];
    NSDictionary *info = [NSDictionary dictionaryWithObject:url forKey:kAFApplicationLaunchOptionsURLKey];
    NSNotification *notification = [NSNotification notificationWithName:kAFApplicationLaunchedWithURLNotification object:self userInfo:info];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (IBAction)menuAction:(id)sender {
    NSLog(@"menuAction:");
}

- (IBAction)startTimer:(id)sender {
    NSLog(@"Start!");

    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(addOneSecond:) userInfo:nil repeats:YES];
    
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:timer forMode:NSDefaultRunLoopMode];
}

- (void)addOneSecond:(NSTimer *)timer{
    NSLog(@"sdfsd");
//    NSNumber *startTime = [NSNumber numberWithFloat:([startTime floatValue] + [plusOne floatValue])];
    double value = [startTime doubleValue];
    startTime = [NSNumber numberWithDouble:value + 1.0];

    int inputSeconds = [startTime intValue];
    int hours =  inputSeconds / 3600;
    int minutes = ( inputSeconds - hours * 3600 ) / 60;
    int seconds = inputSeconds - hours * 3600 - minutes * 60;
    
    NSString *timeString = [[NSString alloc] init];
    
    if (hours > 0) {
        timeString = [NSString stringWithFormat:@"%.2d:%.2d:%.2d", hours, minutes, seconds];
    }else{
        timeString = [NSString stringWithFormat:@"%.2d:%.2d", minutes, seconds];
    }

    
    self.statusItem.title = timeString;
}

- (IBAction)stopTimer:(id)sender {
    NSLog(@"Stop!");
    [timer invalidate];
    startTime = [NSNumber numberWithInt:0];
    NSString *timeString = [startTime stringValue];
    
    self.statusItem.title = timeString;
}

- (IBAction)exitApp:(id)sender {
    NSLog(@"Exit");
    [NSApp terminate:self];
}



@end
