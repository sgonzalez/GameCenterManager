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
@synthesize gcSuccess;

SYNTHESIZE_SINGLETON_FOR_CLASS(GameCenterManager)

#pragma mark -

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
	[viewController dismissModalViewControllerAnimated:YES];
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
	[viewController dismissModalViewControllerAnimated:YES];
}

- (void)showLeaderboardsFromViewController:(UIViewController *)viewController {
	GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != nil) {
        leaderboardController.leaderboardDelegate = self;
        [viewController presentModalViewController: leaderboardController animated: YES];
    }
	[leaderboardController release];
}

- (void)showAchievementsFromViewController:(UIViewController *)viewController {
	GKAchievementViewController *achievementvc = [[GKAchievementViewController alloc] init];
	if (achievementvc != nil) {
		achievementvc.achievementDelegate = self;
		[viewController presentModalViewController:achievementvc animated:YES];
	}
}

#pragma mark -

- (void)authenticateLocalPlayer {
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError *error) {
		if (error == nil) {
			// Insert code here to handle a successful authentication.
			gcSuccess = YES;
		}
		else
		{
			// Your application can process the error parameter to report the error to the player.
			/*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not connect with Game Center servers." delegate:nil cancelButtonTitle:@"Try Later" otherButtonTitles:nil];
			 [alert show];
			 [alert release];*/
		}
	}];
}

- (void)reportScore:(int64_t)score forCategory:(NSString*)category {
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

- (void)reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent {
	[self reportAchievementIdentifier:identifier percentComplete:percent withBanner:NO];
}

- (void)reportAchievementIdentifier:(NSString*)identifier percentComplete:(float)percent withBanner:(BOOL)banner {
	if (!gcSuccess) return;
	
    GKAchievement *achievement = [[[GKAchievement alloc] initWithIdentifier: identifier] autorelease];
    if (achievement) {
        achievement.percentComplete = percent;
		
		[achievement setShowsCompletionBanner:banner];
		
        [achievement reportAchievementWithCompletionHandler:^(NSError *error)
         {
             if (error != nil) {
                 // Retain the achievement object and try again later (not shown).
				 /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not submit achievement with Game Center." delegate:nil cancelButtonTitle:@"Try Later" otherButtonTitles:nil];
				  [alert show];
				  [alert release];*/
             }
		 }];
    }
}

@end
