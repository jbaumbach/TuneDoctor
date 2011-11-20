//
//  ErgoAppDelegate.h
//  iTunesTest
//
//  Created by John Baumbach on 11/19/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "iTunes.h"

@interface ErgoAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource>
{

}
// User Actions
- (IBAction)btnReloadClick:(NSButton *)sender;
- (IBAction)btnGetTrackInfo:(NSButtonCell *)sender;
- (IBAction)btnOuttaHere:(id)sender;

// UI Elements to refresh
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTableView *selectionTable;
@property (assign) IBOutlet NSButton *btnGetTrackInfo;
@property (nonatomic, retain) NSMutableArray *selectedTracks;
@property (assign) IBOutlet NSTextField *statusLabel;
@property (assign) IBOutlet NSProgressIndicator *progressIndicator;

// Class/Instance methods
-(void)getITunesSelections;
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;
-(void)setStatus:(NSString *)statusMsg;

@end
