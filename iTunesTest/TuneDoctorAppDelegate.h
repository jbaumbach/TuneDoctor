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

#import <Cocoa/Cocoa.h>
#import "iTunes.h"

@interface TuneDoctorAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource>
{
    //
    // Member variables
    //
    BOOL _iTunesRunning;
}

//
// User Actions
//
- (IBAction)btnReloadClick:(NSButton *)sender;
- (IBAction)btnGetTrackInfo:(NSButtonCell *)sender;
- (IBAction)btnOuttaHere:(id)sender;

//
// UI Elements to refresh
//
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTableView *selectionTable;
@property (assign) IBOutlet NSButton *btnGetTrackInfo;
@property (assign) IBOutlet NSTextField *statusLabel;
@property (assign) IBOutlet NSProgressIndicator *progressIndicator;

//
// Member properties
//
@property (nonatomic, retain) NSMutableArray *selectedTracks;
@property (nonatomic, retain) iTunesApplication *itunesApp;

//
// Class/Instance methods
//
-(void) getITunesSelections;
-(NSInteger) numberOfRowsInTableView:(NSTableView *)tableView;
- (id) tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;
-(void) setStatus:(NSString *)statusMsg;
-(void) setMainStatus;

//
// Enums
//
enum displayTableColumn {
	kSongtitle = 0,
	kAlbumTitle = 1,
    kSongLocation = 2
};
typedef enum displayTableColumn displayTableColumn;

@end
