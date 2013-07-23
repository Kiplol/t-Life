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
#import "TLAppDelegate.h"

@interface TLVoteManager (private)
-(void)actuallyVoteForMovie:(TLMovieModel*)movie isUpvote:(BOOL)bUp withSuccess:(PFBooleanResultBlock)success failure:(PFBooleanResultBlock)failure;
@end
@implementation TLVoteManager
@synthesize currentRound = _currentRound;
@synthesize hasCurrentRound = _bHasCurrentRound;

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
                NSLog(@"%@", firstRoundDic);
                _bHasCurrentRound = YES;
                _currentRound = [[firstRoundDic objectForKey:@"round"] intValue];
            }
        }];
    }
    return self;
}
-(void)voteForMovie:(TLMovieModel *)movie isUpvote:(BOOL)bUp withSuccess:(PFBooleanResultBlock)success failure:(PFBooleanResultBlock)failure
{
    TLMovieVote * existingVote = [self currentUsersVoteForMovie:movie];
    if(existingVote)
    {
        if(bUp == existingVote.isUpvote)
        {
            NSString * errMsg = (bUp ? @"Already upvoted that movie" : @"Already downvoted that movie");
            NSError * error = [[NSError alloc] initWithDomain:errMsg code:1 userInfo:nil];
            failure(NO, error);
            return;
        }
        else
        {
            //They are voting the other direction.  Delete their last vote
            [self deleteVote:existingVote withSuccess:success failure:failure];
        }
    }
    else
    {
        [self actuallyVoteForMovie:movie isUpvote:bUp withSuccess:success failure:failure];
    }
}

-(void)actuallyVoteForMovie:(TLMovieModel*)movie isUpvote:(BOOL)bUp withSuccess:(PFBooleanResultBlock)success failure:(PFBooleanResultBlock)failure
{
    TLMovieVote * vote = [movie addVoteFromUsername:[PFUser currentUser].username isUpvote:bUp];
    if(vote)
    {
        [vote saveToParseSuccess:success failure:failure];
    }
    else
    {
        failure(NO, nil);
    }
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
    PFQuery *query = [PFQuery queryWithClassName:@"TLMovieVote"];
    [query whereKey:@"movie" equalTo:movie.title];
    [query whereKey:@"round" equalTo:[NSNumber numberWithInt:_currentRound]];
    return [query findObjects];
}

-(void)updateVotesForMovie:(TLMovieModel*)movie completion:(PFBooleanResultBlock)completion
{
    PFQuery *query = [PFQuery queryWithClassName:@"TLMovieVote"];
    [query whereKey:@"movie" equalTo:movie.title];
    [query whereKey:@"round" equalTo:[NSNumber numberWithInt:_currentRound]];
    NSArray * voteIDs = [movie.votes valueForKey:@"voteID"];
    [query whereKey:@"voteID" notContainedIn:voteIDs];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (NSDictionary * voteDic in objects) {
            [movie addVoteFromUsername:[voteDic objectForKey:@"username"] isUpvote:[[voteDic objectForKey:@"upvote"] boolValue] voteID:[voteDic objectForKey:@"voteID"]];
        }
        completion((error == nil), error);
    }];
}

-(void)deleteVote:(TLMovieVote *)vote withSuccess:(PFBooleanResultBlock)success failure:(PFBooleanResultBlock)failure
{
    PFQuery *query = [PFQuery queryWithClassName:@"TLMovieVote"];
    [query whereKey:@"voteID" equalTo:vote.voteID];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(!object)
        {
            NSLog(@"The getFirstObject request failed.");
            failure(NO, error);
        }
        else
        {
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded && !error) {
                    NSLog(@"Vote deleted from parse");
                    //Delete from CoreData
                    TLMovieModel * movie = vote.movie;
                    [movie removeVotesObject:vote];
                    TLAppDelegate * delegate = [UIApplication sharedApplication].delegate;
                    [[delegate managedObjectContext] deleteObject:vote];
                    [delegate saveContext];
                    success(succeeded, error);
                } else {
                    NSLog(@"error: %@", error);
                    failure(succeeded, error);
                }
            }];
            
        }
     }];
}

-(TLMovieVote*)currentUsersVoteForMovie:(TLMovieModel*)movie
{
    NSString * username = [PFUser currentUser].username;
    NSArray * votes = [movie.votes allObjects];
    for(TLMovieVote * existingVote in votes)
    {
        if([existingVote.username caseInsensitiveCompare:username] == NSOrderedSame)
        {
            return existingVote;
        }
    }
    
    //They have not voted for this movie locally, but check remotely first
    TLMovieVote * newFoundVote = nil;
    PFQuery *query = [PFQuery queryWithClassName:@"TLMovieVote"];
    [query whereKey:@"movie" equalTo:movie.title];
    [query whereKey:@"round" equalTo:[NSNumber numberWithInt:_currentRound]];
    NSArray * voteIDs = [movie.votes valueForKey:@"voteID"];
    [query whereKey:@"voteID" notContainedIn:voteIDs];
    NSArray * voteDics = [query findObjects];
    for(NSDictionary * voteDic in voteDics)
    {
        TLMovieVote * tempVote = [movie addVoteFromUsername:[voteDic objectForKey:@"username"] isUpvote:[[voteDic objectForKey:@"upvote"] boolValue] voteID:[voteDic objectForKey:@"voteID"]];
        if([username caseInsensitiveCompare:tempVote.username])
        {
            newFoundVote = tempVote;
        }
    }
    return newFoundVote;
}
@end
