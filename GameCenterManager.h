//
//  GameCenterManager.m
//
//  Created by Santiago Gonzalez on 3/30/11.
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
