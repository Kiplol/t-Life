//
//  TLCopyGenerator.m
//  t+ Life
//
//  Created by Elliott Kipper on 7/24/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import "TLCopyGenerator.h"
#import "TLMovieModel.h"

@implementation TLCopyGenerator

+(TLCopyGenerator*)getInstance
{
    static dispatch_once_t once;
    static TLCopyGenerator * pCGInstance;
    
    dispatch_once(&once, ^{
        pCGInstance = [[TLCopyGenerator alloc] init];
    });
    
    return pCGInstance;
}

-(NSString*)errorTitleForMovie:(TLMovieModel*)movie withCode:(int)errCode
{
    switch (errCode) {
        case movieVoteErrorAlreadyUpvoted:
        {
            int idx = arc4random() % 3;
            switch (idx) {
                case 0:
                {
                    return @"You already upvoted that movie.";
                }
                    break;
                    
                case 1:
                {
                    return [NSString stringWithFormat:@"You already upvoted %@.", movie.title];
                }
                    break;
                    
                case 2:
                {
                    return @"Yes, thank you. That's plenty.";
                }
                    break;
                    
                case 3:
                {
                    
                }
                    break;
                    
                case 4:
                {
                    
                }
                    break;
                    
                default:
                {
                    return nil;
                }
                    break;
            }
            return nil;
        }
            break;
        case movieVoteErrorAlreadyDownvoted:
        {
            int idx = arc4random() % 3;
            switch (idx) {
                case 0:
                {
                    return @"You've already downvoted that movie.";
                }
                    break;
                    
                case 1:
                {
                    return [NSString stringWithFormat:@"You already downvoted %@.", movie.title];
                }
                    break;
                    
                case 2:
                {
                    return [NSString stringWithFormat:@"We understand:  You don't want to watch %@.", movie.title];
                }
                    break;
                    
                case 3:
                {
                    
                }
                    break;
                    
                case 4:
                {
                    
                }
                    break;
                    
                default:
                {
                    return nil;
                }
                    break;
            }
            return nil;
        }
    }
    return nil;
}

-(NSString*)errorMessageForMovie:(TLMovieModel*)movie withCode:(int)errCode
{
    switch (errCode) {
        case movieVoteErrorAlreadyUpvoted:
        {
            int idx = arc4random() % 4;
            switch (idx) {
                case 0:
                {
                    return @"Calm down.";
                }
                    break;
                    
                case 1:
                {
                    return [NSString stringWithFormat:@"%@ must be very good.", movie.title];
                }
                    break;
                    
                case 2:
                {
                    return @"Stop that.";
                }
                    break;
                    
                case 3:
                {
                    return nil;
                }
                    break;
                    
                case 4:
                {
                    
                }
                    break;
                    
                default:
                {
                    return nil;
                }
                    break;
            }
            return nil;
        }
            break;
        case movieVoteErrorAlreadyDownvoted:
        {
            int idx = arc4random() % 4;
            switch (idx) {
                case 0:
                {
                    return @"Calm down.";
                }
                    break;
                    
                case 1:
                {
                    return [NSString stringWithFormat:@"You must really hate %@.", movie.title];
                }
                    break;
                    
                case 2:
                {
                    return @"Please stop it.";
                }
                    break;
                    
                case 3:
                {
                    return nil;
                }
                    break;
                    
                case 4:
                {
                    
                }
                    break;
                    
                default:
                {
                    return nil;
                }
                    break;
            }
            return nil;
        }
    }
    return nil;
}
@end
