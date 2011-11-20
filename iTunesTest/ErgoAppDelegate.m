//
//  ErgoAppDelegate.m
//  iTunesTest
//
//  Created by John Baumbach on 11/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ErgoAppDelegate.h"

@implementation ErgoAppDelegate
@synthesize selectionTable = _selectionTable;
@synthesize btnGetTrackInfo = _btnGetTrackInfo;
@synthesize window = _window;
@synthesize selectedTracks;
@synthesize statusLabel = _statusLabel;
@synthesize progressIndicator = _progressIndicator;

- (void)dealloc
{
    [selectedTracks release];
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    // Hmmmm... not working
    [_btnGetTrackInfo becomeFirstResponder];
        
    [self setStatus:@"Loading..."];
    
    [self getITunesSelections];
    
    _selectionTable.dataSource = self;
    
    /*
     This is a neat idea to get the main window to appear while data is gathing...
     But alas, it has some really strange autorelease behavior scrolling by in 
     the debug window with scary "leaking" messages.  Perhaps figure out someday.
     
    NSThread *dataThread = [[NSThread alloc] initWithTarget:self selector:@selector(getITunesSelections) object:nil];
    [dataThread start];
     */

    if (selectedTracks.count > 0)
    {
        [self setStatus:@"Ready"];
    }
    
}

#pragma mark - Methods

-(void)getITunesSelections
{

    self.selectedTracks = [[NSMutableArray alloc] init];

    iTunesApplication *iTunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    
    if ([iTunes isRunning]) 
    {
        iTunesTrack *currentTrack = [iTunes.currentTrack get];
        
        NSLog(@"Current track: %@, and class: %@", currentTrack.name, [currentTrack class]);
        
        SBElementArray *browserWindows = iTunes.browserWindows;
        
        for (iTunesBrowserWindow* browserWindow in browserWindows) {
            NSLog(@"Found window: %@, with class: %@", browserWindow.name, [browserWindow class]);
            
            SBObject *selection = browserWindow.selection;
            
            NSLog(@"Found selection: %@, of type: %@", selection, [selection class]);
            
            
            NSArray *selectedTrackObjects = [selection get];
            
            //
            // Potentially unsafe cast, but we know what we're doing
            //
            for (iTunesFileTrack *selectedTrack in selectedTrackObjects)
            {
                NSLog(@"Found item with class: %@", [selectedTrack class]);
                if ([[selectedTrack className] isEqualToString:@"ITunesFileTrack"]) 
                {
                    [selectedTracks addObject:selectedTrack];
                }
            }
        }
    }
    else
    {
        [self setStatus:@"iTunes isn't running!"];
    }
}

-(void)setStatus:(NSString *)statusMsg
{
    [_statusLabel setStringValue:statusMsg];
    [_statusLabel setNeedsDisplay];
    
    //
    // This odd statement apparently sleeps a bit, allowing the UI to update.
    //
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow: 0.1]];
}

-(void)setStatus:(NSString *)statusMsg withProgress:(double)progressPercent
{
    [_progressIndicator setDoubleValue:progressPercent];
    [self setStatus:statusMsg];
}

#pragma mark - Table stuff

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [selectedTracks count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    if (rowIndex < selectedTracks.count)
    {
        iTunesFileTrack *song = [selectedTracks objectAtIndex:rowIndex];
        
        if ([aTableColumn.identifier isEqualTo:@"song"])
        {
            return song.name;
        }
        else
        {
            return song.album;
        }
    }
    else
    {
        return [NSString stringWithFormat:@"Invalid index: %d", rowIndex];
    }
}

#pragma mark - User actions

- (IBAction)btnReloadClick:(NSButton *)sender {
    NSLog(@"btnReload clicked!");
    
    [self getITunesSelections];

    [_selectionTable reloadData];
    
}

- (IBAction)btnGetTrackInfo:(NSButtonCell *)sender {
    NSLog(@"btnGetTrackInfo clicked!");
    
    int currentTrack = 0;
    [_progressIndicator setHidden:NO];
    
    //
    // Potentially unsafe cast, but we know what we're doing
    //
    for (iTunesFileTrack *selectedTrack in selectedTracks)
    {
        //
        // OK, now we know we have the right class
        //
        NSLog(@"Found track \"%@\" with location \"%@\".  Refreshing...", selectedTrack.name, selectedTrack.location);
        
        [self setStatus:[NSString stringWithFormat:@"Refreshing: %@", selectedTrack.name] withProgress:100.0f * ((double) currentTrack++ / (double)selectedTracks.count)];

        [selectedTrack refresh];
    }

    [_progressIndicator setHidden:YES];
    [self setStatus:@"Done."];
    
}

- (IBAction)btnOuttaHere:(id)sender {
    NSLog(@"btnOuttaHere clicked!");
    exit(0);
}
@end
