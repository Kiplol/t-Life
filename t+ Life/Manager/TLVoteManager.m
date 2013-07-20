//
//  TLVoteManager.m
//  t+ Life
//
//  Created by Kip on 7/20/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import "TLVoteManager.h"
#import "TLMovieVote.h"
#import "TLMovieManager.h"
#import "TLMovieModel.h"
@implementation TLVoteManager
@synthesize currentRound = _currentRound;
@synthesize hasCurrentRound = _hasCurrentRound;

+(TLVoteManager*)getInstance
{
    static dispatch_once_t once;
    static TLVoteManager * pVMInstance;
    
    dispatch_once(&once, ^{
        pVMInstance = [[TLVoteManager alloc] init];
    });
    
    return pVMInstance;
}

-(id)init
{
    if((self = [super init]))
    {
        _bHasCurrentRound = NO;
        PFQuery *query = [PFQuery queryWithClassName:@"MovieVotingRound"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSDictionary * firstRoundDic = [objects objectAtIndex:0];
            if(firstRoundDic)
            {
                _bHasCurrentRound = YES;
                _currentRound = [[firstRoundDic objectForKey:@"round"] intValue];
            }
        }];
    }
    return self;
}
-(void)voteForMovie:(TLMovieModel *)movie withSuccess:(PFBooleanResultBlock)success failure:(PFBooleanResultBlock)failure
{
    TLMovieVote * vote = [[TLMovieVote alloc] initWithMovie:movie username:[PFUser currentUser].username round:_currentRound isUpvote:YES];
    [vote saveToParse];
    success(YES, nil);
}

-(NSArray*)votesForUsername:(NSString *)username
{
    return [self votesForUsername:username forRound:_currentRound];
}

-(NSArray*)votesForUsername:(NSString *)username forRound:(int)round
{
    PFQuery *query = [PFQuery queryWithClassName:@"TLMovieVote"];
    [query whereKey:@"username" equalTo:[PFUser currentUser].username];
    [query whereKey:@"round" equalTo:[NSNumber numberWithInt:round]];
    return [query findObjects];
}

-(NSArray*)votesForMovie:(TLMovieModel *)movie
{
    return nil;
}
@end