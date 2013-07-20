//
//  TLMovieModel.m
//  t+ Life
//
//  Created by Kip on 7/19/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import "TLMovieModel.h"
#import "TLAppDelegate.h"

@implementation TLMovieModel

@dynamic title;
@dynamic aboutURL;
@dynamic posterURL;
@dynamic upvotes;
@dynamic downvotes;
@dynamic posterImageData;

-(id)initWithTitle:(NSString*)aTitle aboutURL:(NSString*)aURL posterURL:(NSString*)pURL upvotes:(int)uvotes downvotes:(int)dvotes
{
    TLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TLMovieModel" inManagedObjectContext:context];
    self = [self initWithEntity:entity insertIntoManagedObjectContext:nil];
    if (self != nil) {
        self.title = aTitle;
        self.aboutURL = aURL;
        self.posterURL = pURL;
        self.upvotes = [NSNumber numberWithInt:uvotes];
        self.downvotes = [NSNumber numberWithInt:dvotes];
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
                     posterURL:[data objectForKey:KEY_POSTER_URL]
                       upvotes:[[data objectForKey:KEY_UPVOTES] intValue]
                     downvotes:[[data objectForKey:KEY_DOWNVOTES] intValue]];
}
-(void)saveToParse
{
    PFObject *testObject = [PFObject objectWithClassName:@"TLMovieModel"];
    [testObject setObject:self.title forKey:KEY_TITLE];
    [testObject setObject:self.aboutURL forKey:KEY_ABOUT_URL];
    [testObject setObject:self.posterURL forKey:KEY_POSTER_URL];
    [testObject setObject:self.upvotes forKey:KEY_UPVOTES];
    [testObject setObject:self.downvotes forKey:KEY_DOWNVOTES];
    [testObject saveInBackgroundWithBlock:nil];
}

@end
