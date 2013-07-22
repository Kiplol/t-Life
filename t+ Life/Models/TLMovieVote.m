//
//  TLMovieVote.m
//  t+ Life
//
//  Created by Kip on 7/20/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import "TLMovieVote.h"
#import "TLMovieModel.h"
#import "TLAppDelegate.h"

@implementation TLMovieVote

@dynamic upvote;
@dynamic username;
@dynamic movie;
@dynamic isUpvote;
@dynamic round;
@dynamic voteID;

-(id)initWithMovie:(TLMovieModel*)movie username:(NSString*)username round:(int)round isUpvote:(BOOL)bUpvote voteID:(NSString*)voteID;
{
    TLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TLMovieVote" inManagedObjectContext:context];
    self = [self initWithEntity:entity insertIntoManagedObjectContext:nil];
    if (self != nil) {
        self.username = username;
        self.upvote = [NSNumber numberWithBool:bUpvote];
        self.round = [NSNumber numberWithInt:round];
        if(voteID)
        {
            self.voteID = voteID;
        }
        else
        {
            self.voteID = [NSString stringWithFormat:@"%@-%@-%f", [PFUser currentUser].username, movie.title, [[NSDate date] timeIntervalSince1970]];
        }
        if (context != nil)
            [context insertObject:self];
        self.movie = movie;
    }
    return self;
}
-(BOOL)isUpvote
{
    return [self.upvote boolValue];
}
-(void)saveToParse
{
    [self saveToParseSuccess:nil failure:nil];
}
-(void)saveToParseSuccess:(PFBooleanResultBlock)success failure:(PFBooleanResultBlock)failure
{
    PFObject *testObject = [PFObject objectWithClassName:@"TLMovieVote"];
    [testObject setObject:self.username forKey:@"username"];
    [testObject setObject:self.movie.title forKey:@"movie"];
    [testObject setObject:self.upvote forKey:@"upvote"];
    [testObject setObject:self.voteID forKey:@"voteID"];
    [testObject setObject:self.round forKey:@"round"];
    [testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error)
        {
            failure(succeeded, error);
        }
        else
        {
            success(succeeded, error);
        }
    }];
}

@end
