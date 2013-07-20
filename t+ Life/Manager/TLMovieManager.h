//
//  TLMovieManager.h
//  t+ Life
//
//  Created by Kip on 7/19/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLMovieManager : NSObject

+(TLMovieManager*)getInstance;
-(BOOL)needsUpdate;
-(NSArray*)getCachedMovies;
-(NSArray*)getRemoteMovies;
-(void)deleteLocalMovies;
@end
