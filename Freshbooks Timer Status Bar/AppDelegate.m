//
//  AppDelegate.m
//  Freshbooks Timer Status Bar
//
//  Created by Carlos Solares on 7/3/14.
//  Copyright (c) 2014 loslabs.io. All rights reserved.
//

#import "AppDelegate.h"
#import <WebKit/WebKit.h>

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    _statusItem.title = @"00:00:00";
    
//    NSImage *menuIcon = [NSImage imageNamed:@"Menu Icon"];
//    NSImage *highlightIcon = [NSImage imageNamed:@"Menu Icon"]; // Yes, we're using the exact same image asset.
//    [highlightIcon setTemplate:YES]; // Allows the correct highlighting of the icon when the menu is clicked.
    
//    [[self statusItem] setImage:menuIcon];
//    [[self statusItem] setAlternateImage:highlightIcon];
    [[self statusItem] setMenu:[self menu]];
    [[self statusItem] setHighlightMode:YES];
    
    self.webView.policyDelegate = self;
    
    //    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://sonatechinc.freshbooks.com/internal/timesheet/timer"] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
    
    self.bundlePath = [[NSBundle mainBundle]bundlePath]; //Path of your bundle
    self.path = [self.bundlePath stringByAppendingPathComponent:@"data.plist"];
    self.fileManager = [NSFileManager defaultManager];
    
    
    if ([self.fileManager fileExistsAtPath: self.path])
    {
        self.userData = [[NSMutableDictionary alloc] initWithContentsOfFile: self.path];  // if file exist at path initialise your dictionary with its data
    }
    else
    {
        // If the file doesn’t exist, create an empty dictionary
        self.userData = [[NSMutableDictionary alloc] init];
    }
    
    NSLog(@"applicationDidFinishLaunching %@",self.userData);
    
    [self saveDomain:@"sonatechinc"];
    
    
    NSString *url = [NSString stringWithFormat:@"https://%@.freshbooks.com/internal/timesheet/timer", self.getDomain];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

	[self.webView.mainFrame loadRequest:request];

    

    
}




- (NSString *)getDomain {
    NSMutableDictionary *savedData = [[NSMutableDictionary alloc] initWithContentsOfFile: self.path];
    NSString * domainString = [savedData objectForKey:@"domain"];
    NSLog(@"getDomain %@", domainString);
    
    return domainString;
}


- (void)saveDomain:(NSString *)domainString {

    [self.userData setObject:domainString forKey:@"domain"];
    [self.userData writeToFile:self.path atomically:YES];
    
    NSLog(@"saveDomain %@",self.userData);
}





// WebView
-(void)webView:(WebView *)webView
decidePolicyForNavigationAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request frame:(WebFrame *)frame decisionListener:(id < WebPolicyDecisionListener >)listener {
    int actionKey = [[actionInformation objectForKey: WebActionNavigationTypeKey] intValue];
    if (actionKey == WebNavigationTypeOther)
    {
        [listener use];
    }
    else
    {
        //
        // Here is where you would intercept the user navigating away
        // from the current page, and use `[listener ignore];`
        //
        NSLog(@"\n\nuser navigating from: \n\t%@\nto:\n\t%@",
              [webView mainFrameURL],
              [[request URL] absoluteString]);
        
        [listener use];
    }
    
}

-(void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
//    NSLog(@"didFinishLoadForFrame");

    NSString *url = [sender mainFrameURL];
    
    if ([url rangeOfString:@"/timer"].location != NSNotFound){
        //Matches
        NSTimer *freshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimerFromWebView:) userInfo:nil repeats:YES];
        
        NSRunLoop *freshRunner = [NSRunLoop currentRunLoop];
        [freshRunner addTimer:freshTimer forMode:NSDefaultRunLoopMode];
        //    NSLog(@"%@", outputString);
    }
}

- (void)updateStatusText:(NSString *)string {
    self.statusItem.title = string;
//    NSLog(@"updateStatusText %@", string);
    
}

- (void)updateTimerFromWebView:(WebView *)sender {
    DOMDocument *domDoc = [[self.webView mainFrame] DOMDocument];
    
    DOMHTMLElement* hours = (DOMHTMLElement *)[domDoc getElementById:@"timer-clock-hours"];
    DOMHTMLElement* minutes = (DOMHTMLElement *)[domDoc getElementById:@"timer-clock-minutes"];
    DOMHTMLElement* seconds = (DOMHTMLElement *)[domDoc getElementById:@"timer-clock-seconds"];
    
    NSString * string = [NSString stringWithFormat:@"%@:%@:%@", hours.innerText, minutes.innerText, seconds.innerText];
    [self updateStatusText:string];
}


- (IBAction)menuAction:(id)sender {
    NSLog(@"menuAction:");
    [self.window makeKeyAndOrderFront:nil];
}

- (IBAction)startTimer:(id)sender {
    NSLog(@"Start!");

    [self.webView stringByEvaluatingJavaScriptFromString:@"$(\"#timer-button\").click()"];
    
}

- (IBAction)stopTimer:(id)sender {
    NSLog(@"Stop!");
    [self.webView stringByEvaluatingJavaScriptFromString:@"$(\"#timer-button\").click()"];
    
}

- (IBAction)exitApp:(id)sender {
    NSLog(@"Exit");
    [NSApp terminate:self];
}



@end
