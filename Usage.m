//
//  Usage.m
//
//  Copyright 2011 Hicaduda. All rights reserved.
//

#import "GameCenterManager.h"


//Put in applicationDidFinishLaunching
[[GameCenterManager sharedGameCenterManager] authenticateLocalPlayer];

//Put when you earn an achievement
[[GameCenterManager sharedGameCenterManager] reportAchievementIdentifier:@"myAchievement" percentComplete:1.0f];

//Put when you post a score to a leaderboard
[[GameCenterManager sharedGameCenterManager] reportScore:31415926 forCategory:@"leaderboardID"];