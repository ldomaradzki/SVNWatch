//
//  PopoverVC.m
//  SVNwatch
//
//  Created by Łukasz Domaradzki on 19.04.2013.
//

#import "PopoverVC.h"
#import "XMLReader.h"

@implementation PopoverVC

- (id)init
{
    self = [super init];
    if (self) {
    
        self.repositoryURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"repositoryURL"];
    }
    return self;
}

-(void)awakeFromNib
{
    if (self.repositoryURL.length > 0)
    {
        [self.repositoryLabel setStringValue:[NSString stringWithFormat:@"URL: %@", self.repositoryURL]];
        [self addTimer];
    }
}

#pragma mark - Timer methods

-(void)addTimer
{
    if (!self.timer)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
        [self.timer fire];
    }
}

-(void)timerTick:(id)sender
{
    NSString *path = @"/Applications/Xcode.app/Contents/Developer/usr/bin/svn";
    NSArray *args = @[@"log", @"-l", @"1", self.repositoryURL, @"--xml", @"-v"];
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = path;
    task.arguments = args;

    NSPipe *outPipe = [NSPipe pipe];
    [task setStandardOutput:outPipe];
    [task launch];
    [task waitUntilExit];
    
    NSFileHandle * read = [outPipe fileHandleForReading];
    NSData * dataRead = [read readDataToEndOfFile];
    NSString * stringRead = [[NSString alloc] initWithData:dataRead encoding:NSUTF8StringEncoding];
    
    NSDictionary *svnXMLDictionary = [XMLReader dictionaryForXMLString:[stringRead stringByReplacingOccurrencesOfString:@"\n" withString:@""] error:nil];
    
    [task interrupt];
    [task terminate];
    task = nil;
    
    [self sendNotificationWithDictionary:svnXMLDictionary[@"log"][@"logentry"]];

}

-(void)sendNotificationWithDictionary:(NSDictionary*)msgDictionary
{
    NSString *revisionString = msgDictionary[@"revision"];
    if (![self.lastCommitRef isEqualToString:revisionString])
    {
        self.lastCommitRef = revisionString;
        NSString *msgString = msgDictionary[@"msg"][@"text"];
        NSString *userString = msgDictionary[@"author"][@"text"];
        
        NSUserNotification *notif = [[NSUserNotification alloc] init];
        notif.title = [NSString stringWithFormat:@"[%@] %@", revisionString, userString];
        notif.informativeText = msgString;
        
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notif];
    }
}

- (IBAction)setAction:(NSButton *)sender
{
    if ([self getStringFromClipboard].length > 0 && [self validateUrl:[self getStringFromClipboard]])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[self getStringFromClipboard] forKey:@"repositoryURL"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        self.repositoryURL = [self getStringFromClipboard];
        [self.repositoryLabel setStringValue:[NSString stringWithFormat:@"URL: %@", self.repositoryURL]];
        [self addTimer];
    }
}

- (IBAction)stopAction:(NSButton *)sender
{
    [NSApp terminate:self];
}

-(NSString*)getStringFromClipboard
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    return [pasteboard stringForType:NSPasteboardTypeString];
}

- (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

@end
