//
//  AppDelegate.h
//  SVNwatch
//
//  Created by Łukasz Domaradzki on 19.04.2013.
//

#import <Cocoa/Cocoa.h>
#import "PopoverVC.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSPopoverDelegate>
{
    NSStatusItem *statusItem;
    PopoverVC *popoverVC;
}

@property (nonatomic, strong) NSPopover *popover;
@property (assign) IBOutlet NSWindow *window;

@end
