//
//  TLVoteManager.h
//  t+ Life
//
//  Created by Kip on 7/20/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TLMovieModel;
@interface TLVoteManager : NSObject {
    int _currentRound;
    BOOL _bHasCurrentRound;
}
@property (nonatomic, readonly) int currentRound;
@property (nonatomic, readonly) BOOL hasCurrentRound;

+(TLVoteManager*)getInstance;
-(void)voteForMovie:(TLMovieModel*)movie withSuccess:(PFBooleanResultBlock)success failure:(PFBooleanResultBlock)failure;
-(NSArray*)votesForUsername:(NSString*)username;
-(NSArray*)votesForUsername:(NSString *)username forRound:(int)round;
-(NSArray*)votesForMovie:(TLMovieModel*)movie;
@end
