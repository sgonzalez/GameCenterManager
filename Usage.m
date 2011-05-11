#import "GameCenterManager.h"


//Put in applicationDidFinishLaunching
[[GameCenterManager sharedGameCenterManager] authenticateLocalPlayer];

//Put when you earn an achievement
[[GameCenterManager sharedGameCenterManager] reportAchievementIdentifier:@"myAchievement" percentComplete:1.0f];

//Put when you post a score to a leaderboard
[[GameCenterManager sharedGameCenterManager] reportScore:31415926 forCategory:@"leaderboardID"];


/*Multiplayer*/

//Open matchmaker view controller
[[GameCenterManager sharedGameCenterManager] findMatchWithMinPlayers:2 maxPlayers:2 fromViewController:self delegate:self]; //assumed that self is a delegate and is a view controller

//Sending data
NSError *error;
BOOL success = [[GameCenterManager sharedGameCenterManager].match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
if (!success) {
	NSLog(@"Error sending init packet");
	[self matchEnded];
}

//To recieve invites, in delegate
- (void)inviteReceived {
	//Reset game or whatever and get ready
}


You can figure out the rest! ;-)