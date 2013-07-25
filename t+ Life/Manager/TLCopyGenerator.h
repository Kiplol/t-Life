//
//  TLCopyGenerator.h
//  t+ Life
//
//  Created by Elliott Kipper on 7/24/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TLMovieModel;
@interface TLCopyGenerator : NSObject

+(TLCopyGenerator*)getInstance;
-(NSString*)errorTitleForMovie:(TLMovieModel*)movie withCode:(int)errCode;
-(NSString*)errorMessageForMovie:(TLMovieModel*)movie withCode:(int)errCode;
@end
