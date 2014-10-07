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

//@property (strong, nonatomic) NSPipe * outputPipe;
@property (strong, nonatomic) NSTask * buildTask;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [_statusItem setToolTip:@"Flick to Dark Mode, thanks to coolguy87"];
 
    [_statusItem setAction:@selector(toggled:)];
    [_statusItem setDoubleAction:@selector(quitApp:)];
    
    [self updateDarkMode];
    [self setImage];
}

- (void)updateDarkMode {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * value = [userDefaults objectForKey:@"AppleInterfaceStyle"];
    if ([value isEqualToString:@"Dark"]) {
        self.darkModeOn = YES;
    }
    else {
        self.darkModeOn = NO;
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)setImage{
    
    NSString * imageName = @"switch_off.png";
    
    if (_darkModeOn == YES) {
        imageName = @"switch_on.png";
    }
    
    _statusItem.image = [NSImage imageNamed:imageName];
}

- (void)toggled:(id)sender {
    _darkModeOn = !_darkModeOn;
    [self setImage];
    
    NSString * modeString = @"Light";
    if (_darkModeOn) {
        modeString = @"Dark";
        CFPreferencesSetValue((CFStringRef)@"AppleInterfaceStyle", @"Dark", kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    }
    else {
        CFPreferencesSetValue((CFStringRef)@"AppleInterfaceStyle", NULL, kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    }    
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
