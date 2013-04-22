//
//  AppDelegate.m
//  SVNwatch
//
//  Created by Łukasz Domaradzki on 19.04.2013.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [NSApp setActivationPolicy: NSApplicationActivationPolicyProhibited];
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setHighlightMode:YES];
    [statusItem setImage:[NSImage imageNamed:@"subversion"]];
    [statusItem setEnabled:YES];
    [statusItem setToolTip:@"IPMenulet"];
    
    [statusItem setAction:@selector(menuClick:)];
    [statusItem setTarget:self];
    
    popoverVC = [[PopoverVC alloc] init];
    
    self.popover = [[NSPopover alloc] init];
    self.popover.behavior = NSPopoverBehaviorSemitransient;
    self.popover.contentViewController = popoverVC;
    self.popover.delegate = self;
    self.popover.animates = YES;
    self.popover.appearance = NSPopoverAppearanceHUD;
}

-(void)menuClick:(id)sender
{
    
    if (!self.popover.isShown)
    {
        [self.popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
    }
    else
        [self.popover performClose:nil];
}

@end
