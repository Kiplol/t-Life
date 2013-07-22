//
//  TLMovieModel.h
//  t+ Life
//
//  Created by Kip on 7/19/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define KEY_TITLE @"title"
#define KEY_ABOUT_URL @"aboutURL"
#define KEY_POSTER_URL @"posterURL"
@class TLMovieVote;

@interface TLMovieModel : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * aboutURL;
@property (nonatomic, retain) NSString * posterURL;
@property (nonatomic, readonly) int upvotes;
@property (nonatomic, readonly) int downvotes;
@property (nonatomic, retain) NSData * posterImageData;
@property (nonatomic, retain) NSSet *votes;

-(id)initWithTitle:(NSString*)aTitle aboutURL:(NSString*)aURL posterURL:(NSString*)pURL;
-(id)initWithData:(NSDictionary*)data;
-(void)saveToParse;
-(TLMovieVote*)addVoteFromUsername:(NSString*)username isUpvote:(BOOL)bUpvote;
-(TLMovieVote*)addVoteFromUsername:(NSString*)username isUpvote:(BOOL)bUpvote voteID:(NSString*)voteID;
-(NSArray*)votesForCurrentRound;
@end

@interface TLMovieModel (CoreDataGeneratedAccessors)

- (void)addVotesObject:(TLMovieVote *)value;
- (void)removeVotesObject:(TLMovieVote *)value;
- (void)addVotes:(NSSet *)values;
- (void)removeVotes:(NSSet *)values;
@end


