//
//  TLMovieView.m
//  t+ Life
//
//  Created by Kip on 7/19/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import "TLMovieView.h"
#import "TLMovieModel.h"
@implementation TLMovieView

-(id)initWithMovie:(TLMovieModel*)movie
{
    if((self = [super init]))
    {
        _imgPoster = [[UIImageView alloc] initWithFrame:self.bounds];
        _imgPoster.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_imgPoster];
        _darkBottom = [[UIView alloc] init];
        _darkBottom.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:_darkBottom];
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.backgroundColor = [UIColor clearColor];
        _lblTitle.textColor = [UIColor whiteColor];
        [self addSubview:_lblTitle];
        _lblVotes = [[UILabel alloc] init];
        _lblVotes.backgroundColor = [UIColor clearColor];
        _lblVotes.textColor = [UIColor whiteColor];
        [self addSubview:_lblVotes];
        if(movie)
            [self updateWithMovie:movie];
    }
    return self;
}

-(void)updateWithMovie:(TLMovieModel *)movie
{
    UIImage *img = [[UIImage alloc] initWithData:movie.posterImageData];
    _imgPoster.image = img;
    [_imgPoster sizeToFit];
    
    _lblTitle.text = movie.title;
    
    _lblVotes.text = [NSString stringWithFormat:@"%d", movie.votes.count];
}
-(void)layoutSubviews
{
    _imgPoster.backgroundColor = [UIColor redColor];
    [super layoutSubviews];
    _imgPoster.frame = self.bounds;
    
    //Title Label
    [_lblTitle sizeToFit];
    _lblTitle.frame = CGRectMake(10, CGRectGetMaxY(_imgPoster.frame) - _lblTitle.frame.size.height - 10,
                                 _lblTitle.frame.size.width, _lblTitle.frame.size.height);
    
    //Votes Label
    [_lblVotes sizeToFit];
    
    //Dark Bottom
    _darkBottom.frame = CGRectMake(0, _lblTitle.frame.origin.y - 10, _imgPoster.frame.size.width,
                                   CGRectGetMaxY(_imgPoster.frame) - _lblTitle.frame.origin.y + 10);
}

@end
