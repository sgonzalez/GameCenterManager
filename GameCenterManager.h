//
//  GameCenterManager.h
//  Cyber Pig
//
//  Created by Santiago Gonzalez on 3/30/11.
//  Copyright 2011 Hicaduda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface GameCenterManager : NSObject {
    BOOL gcSuccess;
}
@property (assign) BOOL gcSuccess;
- (void)reportScore: (int64_t) score forCategory: (NSString*) category;
- (void)authenticateLocalPlayer;
- (void)reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent;
+ (GameCenterManager *)sharedGameCenterManager;
@end
