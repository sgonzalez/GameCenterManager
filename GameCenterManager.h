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
 copies of the Software, and to permit persons to whom the
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

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@protocol GameCenterManagerDelegate 
- (void)matchStarted;
- (void)inviteReceived;
- (void)matchEnded;
- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID;
@end

@interface GameCenterManager : NSObject <GKMatchmakerViewControllerDelegate, GKMatchDelegate, GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate> {
    BOOL gcSuccess;
	
	UIViewController *presentingViewController;
	GKMatch *match;
	BOOL matchStarted;
	id <GameCenterManagerDelegate> delegate;
	NSMutableDictionary *playersDict;
	GKInvite *pendingInvite;
	NSArray *pendingPlayersToInvite;
}
@property (retain) GKInvite *pendingInvite;
@property (retain) NSArray *pendingPlayersToInvite;
@property (retain) NSMutableDictionary *playersDict;
@property (retain) UIViewController *presentingViewController;
@property (retain) GKMatch *match;
@property (assign) id <GameCenterManagerDelegate> delegate;
@property (assign) BOOL gcSuccess;
- (void)findMatchWithMinPlayers:(int)minPlayers maxPlayers:(int)maxPlayers fromViewController:(UIViewController *)viewController delegate:(id<GameCenterManagerDelegate>)theDelegate;
- (void)showLeaderboardsFromViewController:(UIViewController *)viewController;
- (void)showAchievementsFromViewController:(UIViewController *)viewController;
- (void)reportScore: (int64_t) score forCategory: (NSString*) category;
- (void)authenticateLocalPlayer;
- (void)reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent;
+ (GameCenterManager *)sharedGameCenterManager;
@end
