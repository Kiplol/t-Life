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
#define KEY_UPVOTES @"upvotes"
#define KEY_DOWNVOTES @"downvotes"

@interface TLMovieModel : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * aboutURL;
@property (nonatomic, retain) NSString * posterURL;
@property (nonatomic, retain) NSNumber * upvotes;
@property (nonatomic, retain) NSNumber * downvotes;
@property (nonatomic, retain) NSData * posterImageData;


-(id)initWithTitle:(NSString*)aTitle aboutURL:(NSString*)aURL posterURL:(NSString*)pURL upvotes:(int)uvotes downvotes:(int)dvotes;
-(id)initWithData:(NSDictionary*)data;
-(void)saveToParse;

@end
