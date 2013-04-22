//
//  PopoverVC.h
//  SVNwatch
//
//  Created by Łukasz Domaradzki on 19.04.2013.
//

#import <Cocoa/Cocoa.h>

@interface PopoverVC : NSViewController

@property (strong) IBOutlet NSTextField *repositoryLabel;
@property (nonatomic, strong) NSString *repositoryURL;
@property (nonatomic, strong) NSString *lastCommitRef;
@property (strong) IBOutlet NSButton *stopButton;
@property (nonatomic, strong) NSTimer *timer;

- (IBAction)setAction:(NSButton *)sender;
- (IBAction)stopAction:(NSButton *)sender;
@end
