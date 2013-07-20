//
//  TLMovieManager.m
//  t+ Life
//
//  Created by Kip on 7/19/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import "TLMovieManager.h"
#import "TLMovieModel.h"
#import "TLAppDelegate.h"
#define KEY_MOVIE_VERSION @"movieVersion"

@implementation TLMovieManager

+(TLMovieManager*)getInstance
{
    static dispatch_once_t once;
    static TLMovieManager * pInstance;
    
    dispatch_once(&once, ^{
        pInstance = [[TLMovieManager alloc] init];
        pInstance->_lastCheckedVersion = -1;
    });
    
    return pInstance;
}
-(BOOL)needsUpdate
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSNumber * currentVersion = nil;
    if([defaults objectForKey:KEY_MOVIE_VERSION])
    {
        currentVersion = [defaults objectForKey:KEY_MOVIE_VERSION];
    }
    else
    {
        currentVersion = [NSNumber numberWithInt:0];
    }
    
    if(_lastCheckedVersion < 0)
    {
        _lastCheckedVersion = [currentVersion intValue];
    }
    PFQuery *query = [PFQuery queryWithClassName:@"MovieUpdateVersion"];
    NSError * error;
    NSArray * versions = [query findObjects:&error];
    if(!error)
    {
        for(NSDictionary * versionDic in versions)
        {
            NSNumber * version = [versionDic objectForKey:@"Version"];
            _lastCheckedVersion = [version intValue];
            if(_lastCheckedVersion > [currentVersion intValue])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        return NO;
    }
    else
    {
        return YES;
    }
    return NO;
}
-(NSArray*)getCachedMovies
{
    TLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"TLMovieModel"
                                                  inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    [request setReturnsObjectsAsFaults:NO];  //Is there a way to get around doing this?
    //request.sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO]];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    if ([objects count] == 0) {
        return nil;
    } else {
        return objects;
    }
}

-(NSArray*)getRemoteMovies;
{
    PFQuery *query = [PFQuery queryWithClassName:@"TLMovieModel"];
    NSError * error;
    NSArray * movies = [query findObjects:&error];
    NSMutableArray * remoteMovies = nil;
    if(movies)
    {
        remoteMovies = [[NSMutableArray alloc] initWithCapacity:movies.count];
        [self deleteLocalMovies];
        for(NSDictionary * movieDic in movies)
        {
            TLMovieModel * tempMovie = [[TLMovieModel alloc] initWithData:movieDic];
            [remoteMovies addObject:tempMovie];
        }
    }
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithInt:_lastCheckedVersion] forKey:KEY_MOVIE_VERSION];
    TLAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate saveContext];
    return remoteMovies;
}

-(NSArray*)getAllMovies
{
    if([self needsUpdate])
    {
        return [self getRemoteMovies];
    }
    else
    {
        return [self getCachedMovies];
    }
}
-(void)deleteLocalMovies
{
    NSArray * movies = [self getCachedMovies];
    TLAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSError * error;
    for (NSManagedObject *managedObject in movies) {
    	[appDelegate.managedObjectContext deleteObject:managedObject];
    }
    if (![appDelegate.managedObjectContext save:&error]) {
    	NSLog(@"Error deleting movies - error:%@",error);
    }
}
@end
