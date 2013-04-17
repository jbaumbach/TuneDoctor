/*
 
 Copyright (C) 2011-2013 John Baumbach.
 
 This file is part of TuneDoctor.
 
 TuneDoctor is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 TuneDoctor is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
 
 */

#import "TuneDoctorAppDelegate.h"

@implementation TuneDoctorAppDelegate
@synthesize selectionTable = _selectionTable;
@synthesize btnGetTrackInfo = _btnGetTrackInfo;
@synthesize window = _window;
@synthesize selectedTracks;
@synthesize statusLabel = _statusLabel;
@synthesize progressIndicator = _progressIndicator;
@synthesize itunesApp;

//
// Free up some stuff
//
- (void)dealloc
{
    [selectedTracks release];
    [itunesApp release];
    
    [super dealloc];
}

//
// Program launched - init some ui elements
//
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self setStatus:@"Loading..."];
    [self getITunesSelections];
    
    _selectionTable.dataSource = self;
    
    [self setMainStatus];
}

#pragma mark - Methods

//
// Set the status label based on the state of some app variables
//
-(void) setMainStatus
{
    if (!_iTunesRunning)
    {
        [self setStatus:@"iTunes isn't running."];
    }
    else
    {
        if (selectedTracks.count == 0)
        {
            [self setStatus:@"No songs selected."];
        }
        else
        {
            [self setStatus:[NSString stringWithFormat:@"Found %ld songs.", (unsigned long)selectedTracks.count]];
        }
    }
}

//
// Grab the songs currently selected in iTunes
//
-(void)getITunesSelections
{

    self.selectedTracks = [[NSMutableArray alloc] init];
    _iTunesRunning = NO;
    
    //
    // Get a handle to a running instance of iTunes
    //
    self.itunesApp = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
    
    if ([self.itunesApp isRunning])
    {
        //
        // Great, we have a handle to a running iTunes.
        //
        
        _iTunesRunning = YES;
        iTunesTrack *currentTrack = [self.itunesApp.currentTrack get];
        
        NSLog(@"Current track: %@, and class: %@", currentTrack.name, [currentTrack class]);
        
        SBElementArray *browserWindows = self.itunesApp.browserWindows;
        
        for (iTunesBrowserWindow* browserWindow in browserWindows)
        {
            NSLog(@"Found window: %@, with class: %@", browserWindow.name, [browserWindow class]);
            
            SBObject *selection = browserWindow.selection;
            
            NSLog(@"Found selection: %@, of type: %@", selection, [selection class]);
            
            NSArray *selectedTrackObjects = [selection get];
            
            //
            // Loop through all the tracks we found and add them to our member array for later use.
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
}

//
// Write the passed string to the status label
//
-(void)setStatus:(NSString *)statusMsg
{
    [_statusLabel setStringValue:statusMsg];
    [_statusLabel setNeedsDisplay];
    
    //
    // This odd statement apparently sleeps a bit, allowing the UI to update.
    //
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow: 0.1]];
}

//
// Write the passed string to the status label, and update the progress bar
//
-(void)setStatus:(NSString *)statusMsg withProgress:(double)progressPercent
{
    [_progressIndicator setDoubleValue:progressPercent];
    [self setStatus:statusMsg];
}

#pragma mark - Table stuff

//
// Get the number of rows in the table
//
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [selectedTracks count];
}

//
// Get the object for the indicated row
//
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    if (rowIndex < selectedTracks.count)
    {
        iTunesFileTrack *song = [selectedTracks objectAtIndex:rowIndex];
        int columnId = [aTableColumn.identifier intValue];
        
        switch (columnId)
        {
            case kSongtitle:
                return song.name;
                break;
            case kAlbumTitle:
                return song.album;
                break;
            case kSongLocation:
                return song.location;
                break;
            
            default:
                return [NSString stringWithFormat:@"Unk col id: %d", columnId];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"Invalid index: %ld", (long)rowIndex];
    }
}

#pragma mark - User actions

//
// The user clicked the refresh button
//
- (IBAction)btnReloadClick:(NSButton *)sender {
    NSLog(@"btnReload clicked!");
    
    [self getITunesSelections];
    [self setMainStatus];

    [_selectionTable reloadData];
    
}

//
// The user clicked the "Remove Exclamation Marks!" button
//
- (IBAction)btnGetTrackInfo:(NSButtonCell *)sender {
    NSLog(@"btnGetTrackInfo clicked!");
    
    int currentTrack = 0;
    [_progressIndicator setHidden:NO];
    
    //
    // Loop through the iTunes tracks and play each one a 'lil bit
    //
    for (iTunesFileTrack *selectedTrack in selectedTracks)
    {
        //
        // OK, now we know we have the right class
        //
        NSLog(@"Found track \"%@\" with location \"%@\"", selectedTrack.name, selectedTrack.location);
        
        [self setStatus:[NSString stringWithFormat:@"Refreshing: %@", selectedTrack.name] withProgress:100.0f * ((double) currentTrack++ / (double)selectedTracks.count)];

        //
        // The location value being nil means there's an exlamation point next to the title.  Let's
        // start playing the track.  If it's found by iTunes, the exclamation point goes away.
        //
        if (selectedTrack.location == nil)
        {
            NSLog(@"Playing once!");
            [selectedTrack playOnce:YES];
            [itunesApp stop];
            NSLog(@"Done playing, location is now: %@", selectedTrack.location);
        }
        else
        {
            NSLog(@"Already has a location, don't need to play.");
        }
    }

    [_progressIndicator setHidden:YES];
    [self setStatus:@"Done. Prolly need to restart iTunes."];
    
}

//
// Quit the app
//
- (IBAction)btnOuttaHere:(id)sender {
    NSLog(@"btnOuttaHere clicked!");
    exit(0);
}

@end
