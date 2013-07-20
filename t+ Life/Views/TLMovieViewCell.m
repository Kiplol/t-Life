//
//  TLMovieViewCell.m
//  t+ Life
//
//  Created by Kip on 7/19/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import "TLMovieViewCell.h"
#import "TLMovieView.h"

@implementation TLMovieViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)updateWithMovie:(TLMovieModel*)movie
{
    if(_movieView == nil)
    {
        _movieView = [[TLMovieView alloc] initWithMovie:movie];
        [self addSubview:_movieView];
        _movieView.frame = self.bounds;
        _movieView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    else
    {
        [_movieView updateWithMovie:movie];
    }
}

@end
