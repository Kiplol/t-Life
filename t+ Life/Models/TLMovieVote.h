//
//  TLMovieVote.h
//  t+ Life
//
//  Created by Kip on 7/20/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TLMovieModel;

@interface TLMovieVote : NSManagedObject

@property (nonatomic, retain) NSNumber * upvote;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) TLMovieModel *movie;
@property (nonatomic, retain) NSNumber * round;

@property (nonatomic, readonly) BOOL isUpvote;

-(id)initWithMovie:(TLMovieModel*)movie username:(NSString*)username round:(int)round isUpvote:(BOOL)bUpvote;
-(void)saveToParse;
@end