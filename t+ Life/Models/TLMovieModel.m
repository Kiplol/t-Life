//
//  TLMovieModel.m
//  t+ Life
//
//  Created by Kip on 7/19/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import "TLMovieModel.h"
#import "TLAppDelegate.h"
#import "TLMovieVote.h"
#import "TLVoteManager.h"

@implementation TLMovieModel

@dynamic title;
@dynamic aboutURL;
@dynamic posterURL;
@synthesize downvotes, upvotes;
@dynamic posterImageData;
@dynamic votes;

-(id)initWithTitle:(NSString*)aTitle aboutURL:(NSString*)aURL posterURL:(NSString*)pURL
{
    TLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TLMovieModel" inManagedObjectContext:context];
    self = [self initWithEntity:entity insertIntoManagedObjectContext:nil];
    if (self != nil) {
        self.title = aTitle;
        self.aboutURL = aURL;
        self.posterURL = pURL;
        NSURL *url = [NSURL URLWithString:self.posterURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.posterImageData = data;
        if (context != nil)
            [context insertObject:self];
    }
    return self;
}

-(id)initWithData:(NSDictionary*)data
{
    return [self initWithTitle:[data objectForKey:KEY_TITLE]
                      aboutURL:[data objectForKey:KEY_ABOUT_URL]
                     posterURL:[data objectForKey:KEY_POSTER_URL]];
}

-(int)upvotes
{
    int nUps = 0;
    for(TLMovieVote * vote in self.votes)
    {
        if([vote.upvote boolValue])
        {
            nUps++;
        }
    }
    return nUps;
}

-(int)downvotes
{
    int nDowns = 0;
    for(TLMovieVote * vote in self.votes)
    {
        if([vote.upvote boolValue] == NO)
        {
            nDowns++;
        }
    }
    return nDowns;
}

-(TLMovieVote*)addVoteFromUsername:(NSString*)username isUpvote:(BOOL)bUpvote
{
    return [self addVoteFromUsername:username isUpvote:bUpvote voteID:nil];
}
-(TLMovieVote*)addVoteFromUsername:(NSString*)username isUpvote:(BOOL)bUpvote voteID:(NSString*)voteID
{
    if([TLVoteManager getInstance].hasCurrentRound)
    {
        TLMovieVote * vote = [[TLMovieVote alloc] initWithMovie:self username:username round:[TLVoteManager getInstance].currentRound isUpvote:YES voteID:voteID];
        TLAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate saveContext];
        return vote;
    }
    else
    {
        //Not ready yet
        return nil;
    }
}
-(void)saveToParse
{
    PFObject *testObject = [PFObject objectWithClassName:@"TLMovieModel"];
    [testObject setObject:self.title forKey:KEY_TITLE];
    [testObject setObject:self.aboutURL forKey:KEY_ABOUT_URL];
    [testObject setObject:self.posterURL forKey:KEY_POSTER_URL];
    [testObject saveInBackgroundWithBlock:nil];
}

@end
