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
    [_statusItem setToolTip:@"Switch between Dark and Light mode"];
 
    [_statusItem setAction:@selector(toggled:)];
    [_statusItem setDoubleAction:@selector(quitApp:)];
    _statusItem.highlightMode = NO;
    
    [self updateDarkMode];
    [self setImage];
}

- (void)updateDarkMode {
    NSString * value = (__bridge NSString *)(CFPreferencesCopyValue((CFStringRef)@"AppleInterfaceStyle", kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost));
    if ([value isEqualToString:@"Dark"]) {
        self.darkModeOn = YES;
    }
    else {
        self.darkModeOn = NO;
    }
}

- (void)setImage{
    
    NSString * imageName = @"switch_off.png";

    //Something is going wrong here
    if (_darkModeOn == YES) {
        imageName = @"switch_on.png";
    }
    
    _statusItem.image = [NSImage imageNamed:imageName];
}

- (void)toggled:(id)sender {
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
    [self toggled:nil];
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    [notification setTitle: @"Flick quitting"];
    [notification setSubtitle: @"Double clicking quits Flick"];
    [notification setDeliveryDate:nil];
    [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification: notification];
    [NSApp terminate:self];
}

@end
