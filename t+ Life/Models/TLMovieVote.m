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

-(id)initWithMovie:(TLMovieModel*)movie username:(NSString*)username round:(int)round isUpvote:(BOOL)bUpvote
{
    TLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TLMovieVote" inManagedObjectContext:context];
    self = [self initWithEntity:entity insertIntoManagedObjectContext:nil];
    if (self != nil) {
        self.username = username;
        self.upvote = [NSNumber numberWithBool:bUpvote];
        self.round = [NSNumber numberWithInt:round];
        [movie addVotesObject:self];
    }
    return self;
}
-(BOOL)isUpvote
{
    return [self.upvote boolValue];
}

-(void)saveToParse
{
    PFObject *testObject = [PFObject objectWithClassName:@"TLMovieVote"];
    [testObject setObject:self.username forKey:@"username"];
    [testObject setObject:self.movie.title forKey:@"movie"];
    [testObject setObject:self.upvote forKey:@"upvote"];
    [testObject saveInBackgroundWithBlock:nil];
}

@end
