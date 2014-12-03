//
//  AppDelegate.m
//  Flick
//
//  Created by Nirbhay Agarwal on 05/10/14.
//  Copyright (c) 2014 NSRover. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (strong, nonatomic) NSStatusItem *statusItem;
@property (assign, nonatomic) BOOL darkModeOn;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [_statusItem setToolTip:@"Control-click to quit"];
 
    [_statusItem setAction:@selector(toggled:)];
    _statusItem.highlightMode = NO;
    
    [self updateDarkMode];
    [self setImage];
}

- (void)addSystemBarItem {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [_statusItem setToolTip:@"Control-click to quit"];
    
    [_statusItem setAction:@selector(toggled:)];
    _statusItem.highlightMode = NO;
    [self setImage];
}

- (void)updateDarkMode {
    NSString *value = (__bridge NSString *)(CFPreferencesCopyValue((CFStringRef)@"AppleInterfaceStyle", kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost));
    if ([value isEqualToString:@"Dark"]) {
        self.darkModeOn = YES;
    }
    else {
        self.darkModeOn = NO;
    }
}

- (void)setImage{
    
    NSString *imageName = @"switch_on.png";
    
    NSImage *img = [NSImage imageNamed:imageName];
    [img setTemplate:YES];
    [_statusItem setImage:img];
}

- (void)toggled:(id)sender {
    
    NSEvent *event = [NSApp currentEvent];
    if([event modifierFlags] & NSControlKeyMask) {
        [self quitApp:nil];
        return;
    }
    
    _darkModeOn = !_darkModeOn;
    [self setImage];
    
    //Change pref
    if (_darkModeOn) {
        CFPreferencesSetValue((CFStringRef)@"AppleInterfaceStyle", @"Dark", kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    }
    else {
        CFPreferencesSetValue((CFStringRef)@"AppleInterfaceStyle", NULL, kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    }
    
    //update listeners
    dispatch_async(dispatch_get_main_queue(), ^{
        CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), (CFStringRef)@"AppleInterfaceThemeChangedNotification", NULL, NULL, YES);
    });
}

- (void)quitApp:(id)sender {
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    [notification setTitle: @"Flick quitting"];
    [notification setSubtitle: @"Control-click quits Flick"];
    [notification setDeliveryDate:nil];
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification: notification];
    [NSApp terminate:self];
}

@end
