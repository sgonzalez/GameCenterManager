//
//  GameCenterManager.m
//
//  Copyright 2011 Hicaduda. All rights reserved.
//
/*
 
 hicaduda.com || http://github.com/sgonzalez/GameCenterManager
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software in binary form, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "GameCenterManager.h"
#import "SynthesizeSingleton.h"

@implementation GameCenterManager
@synthesize playersDict;
@synthesize presentingViewController;
@synthesize match;
@synthesize delegate;
@synthesize gcSuccess;

SYNTHESIZE_SINGLETON_FOR_CLASS(GameCenterManager)

#pragma mark -

- (void)authenticateLocalPlayer {
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
		if (error == nil)
		{
			// Insert code here to handle a successful authentication.
			gcSuccess = YES;
		}
		else
		{
			// Your application can process the error parameter to report the error to the player.
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not connect with Game Center servers." delegate:nil cancelButtonTitle:@"Try Later" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
	}];
}

- (void) reportScore: (int64_t) score forCategory: (NSString*) category {
	if (!gcSuccess) return;
	
	GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
	scoreReporter.value = score;
	
	[scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
		if (error != nil) {
			// handle the reporting error
			/*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not submit score with Game Center." delegate:nil cancelButtonTitle:@"Try Later" otherButtonTitles:nil];
			 [alert show];
			 [alert release];*/
		}
	}];
}

- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent {
	if (!gcSuccess) return;
	
    GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier: identifier] autorelease];
    if (achievement)
    {
        achievement.percentComplete = percent;
        [achievement reportAchievementWithCompletionHandler:^(NSError *error)
         {
             if (error != nil){
                 // Retain the achievement object and try again later (not shown).
				 /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not submit achievement with Game Center." delegate:nil cancelButtonTitle:@"Try Later" otherButtonTitles:nil];
				  [alert show];
				  [alert release];*/
             }
		 }];
    }
}

#pragma mark -

- (void)lookupPlayers {
	
    NSLog(@"Looking up %d players...", match.playerIDs.count);
    [GKPlayer loadPlayersForIdentifiers:match.playerIDs withCompletionHandler:^(NSArray *players, NSError *error) {
		
        if (error != nil) {
            NSLog(@"Error retrieving player info: %@", error.localizedDescription);
            matchStarted = NO;
            [delegate matchEnded];
        } else {
			
            // Populate players dict
            self.playersDict = [NSMutableDictionary dictionaryWithCapacity:players.count];
            for (GKPlayer *player in players) {
                NSLog(@"Found player: %@", player.alias);
                [playersDict setObject:player forKey:player.playerID];
            }
			
            // Notify delegate match can begin
            matchStarted = YES;
            [delegate matchStarted];
			
        }
    }];
	
}

- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers withViewController:(UIViewController *)viewController delegate:(id<GameCenterManagerDelegate>)theDelegate {
	
    if (!gcSuccess) return;
	
    matchStarted = NO;
    self.match = nil;
    self.presentingViewController = viewController;
    delegate = theDelegate;               
    [presentingViewController dismissModalViewControllerAnimated:NO];
	
    GKMatchRequest *request = [[[GKMatchRequest alloc] init] autorelease]; 
    request.minPlayers = minPlayers;     
    request.maxPlayers = maxPlayers;
	
    GKMatchmakerViewController *mmvc = 
	[[[GKMatchmakerViewController alloc] initWithMatchRequest:request] autorelease];    
    mmvc.matchmakerDelegate = self;
	
    [presentingViewController presentModalViewController:mmvc animated:YES];
	
}

#pragma mark -

// The user has cancelled matchmaking
- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController {
    [presentingViewController dismissModalViewControllerAnimated:YES];
}

// Matchmaking has failed with an error
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error {
    [presentingViewController dismissModalViewControllerAnimated:YES];
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Error finding match: %@", error.localizedDescription] delegate:nil cancelButtonTitle:@"Try Later" otherButtonTitles:nil] autorelease];
	[alert show];    
}

// A peer-to-peer match has been found, the game should start
- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)theMatch {
    [presentingViewController dismissModalViewControllerAnimated:YES];
    self.match = theMatch;
    match.delegate = self;
    if (!matchStarted && match.expectedPlayerCount == 0) {
		NSLog(@"Ready to start match!");
		[self lookupPlayers];
//		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Ready to Start Match" message:nil delegate:nil cancelButtonTitle:@"Done" otherButtonTitles:nil] autorelease];
//		[alert show]; 
    }
}

#pragma mark -

// The match received data sent from the player.
- (void)match:(GKMatch *)theMatch didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {    
    if (match != theMatch) return;
	
    [delegate match:theMatch didReceiveData:data fromPlayer:playerID];
}

// The player state changed (eg. connected or disconnected)
- (void)match:(GKMatch *)theMatch player:(NSString *)playerID didChangeState:(GKPlayerConnectionState)state {   
    if (match != theMatch) return;
	
    switch (state) {
        case GKPlayerStateConnected: 
            // handle a new player connection.
            NSLog(@"Player connected!");
			
            if (!matchStarted && theMatch.expectedPlayerCount == 0) {
                NSLog(@"Ready to start match!");
				[self lookupPlayers];
            }
			
            break; 
        case GKPlayerStateDisconnected:
            // a player just disconnected. 
            NSLog(@"Player disconnected!");
            matchStarted = NO;
            [delegate matchEnded];
            break;
    }                     
}

// The match was unable to connect with the player due to an error.
- (void)match:(GKMatch *)theMatch connectionWithPlayerFailed:(NSString *)playerID withError:(NSError *)error {
	
    if (match != theMatch) return;
	
    NSLog(@"Failed to connect to player with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded];
}

// The match was unable to be established with any players due to an error.
- (void)match:(GKMatch *)theMatch didFailWithError:(NSError *)error {
	
    if (match != theMatch) return;
	
    NSLog(@"Match failed with error: %@", error.localizedDescription);
    matchStarted = NO;
    [delegate matchEnded];
}

@end
