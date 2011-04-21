//
//  GameCenterManager.m
//
//  Created by Santiago Gonzalez on 3/30/11.
//

#import "GameCenterManager.h"
#import "SynthesizeSingleton.h"

@implementation GameCenterManager

@synthesize gcSuccess;

SYNTHESIZE_SINGLETON_FOR_CLASS(GameCenterManager)

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
	if (gcSuccess) {
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
}

- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent {
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

@end
