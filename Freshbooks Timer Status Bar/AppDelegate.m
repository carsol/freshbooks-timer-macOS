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
    _statusItem.title = @"00:00";
    
    NSImage *menuIcon = [NSImage imageNamed:@"Menu Icon"];
    NSImage *highlightIcon = [NSImage imageNamed:@"Menu Icon"]; // Yes, we're using the exact same image asset.
    [highlightIcon setTemplate:YES]; // Allows the correct highlighting of the icon when the menu is clicked.
    
    [[self statusItem] setImage:menuIcon];
    [[self statusItem] setAlternateImage:highlightIcon];
    [[self statusItem] setMenu:[self menu]];
    [[self statusItem] setHighlightMode:YES];
    
    self.webView.policyDelegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://sonatechinc.freshbooks.com/internal/timesheet/timer"]];
	[self.webView.mainFrame loadRequest:request];

    

    
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
        
//        NSString *stuff = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"text\").innerHTML=\"Hello World\";"];
//        
//        NSLog(@"%@", stuff);
        
        [listener use];
    }
    
}

-(void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    NSLog(@"didFinishLoadForFrame");
//    NSString *stuff = [self.webView stringByEvaluatingJavaScriptFromString:@"alert(dsfas); return \"dstuf\""];
//    NSLog(stuff);
//    NSString *output = [sender stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('timer-clock-minutes')[0].innerHTML"];
//    NSString *output = [sender stringByEvaluatingJavaScriptFromString:script];
    DOMDocument *domDoc = [[sender mainFrame] DOMDocument];
    
    DOMHTMLElement* hours = (DOMHTMLElement *)[domDoc getElementById:@"timer-clock-hours"];
    DOMHTMLElement* minutes = (DOMHTMLElement *)[domDoc getElementById:@"timer-clock-minutes"];
    DOMHTMLElement* seconds = (DOMHTMLElement *)[domDoc getElementById:@"timer-clock-seconds"];
    
    NSString * string = [NSString stringWithFormat:@"%@:%@:%@", hours.innerText, minutes.innerText, seconds.innerText];
    [self updateStatusText:string];

    NSTimer *freshTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimerFromWebView:) userInfo:nil repeats:YES];
    
    NSRunLoop *freshRunner = [NSRunLoop currentRunLoop];
    [freshRunner addTimer:freshTimer forMode:NSDefaultRunLoopMode];
//    NSLog(@"%@", outputString);

}

- (void)updateStatusText:(NSString *)string {
    self.statusItem.title = string;
    NSLog(@"updateStatusText %@", string);
    
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

//    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(addOneSecond:) userInfo:nil repeats:YES];
//    
//    NSRunLoop *runner = [NSRunLoop currentRunLoop];
//    [runner addTimer:timer forMode:NSDefaultRunLoopMode];
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
