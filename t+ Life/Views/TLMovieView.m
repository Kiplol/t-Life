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
        [self addSubview:_darkBottom];
        _lblTitle = [[UILabel alloc] init];
        [self addSubview:_lblTitle];
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
}
-(void)layoutSubviews
{
    _imgPoster.backgroundColor = [UIColor redColor];
    [super layoutSubviews];
    [_lblTitle sizeToFit];
    _imgPoster.frame = self.bounds;
}

@end
