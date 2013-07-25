//
//  TLMovieView.m
//  t+ Life
//
//  Created by Kip on 7/19/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import "TLMovieView.h"
#import "TLMovieModel.h"
#import "TLVoteManager.h"
@implementation TLMovieView
@synthesize upvoteAction = _upvoteAction;
@synthesize downvoteAction = _downvoteAction;
@synthesize upvoteTarget = _upvoteTarget;
@synthesize downvoteTarget = _downvoteTarget;
@synthesize movie =_movie;

-(id)initWithMovie:(TLMovieModel*)movie
{
    if((self = [super init]))
    {
        _movie = nil;
        //
        _imgPoster = [[UIImageView alloc] initWithFrame:self.bounds];
        _imgPoster.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:_imgPoster];
        //
        _darkBottom = [[UIView alloc] init];
        _darkBottom.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:_darkBottom];
        //
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.numberOfLines = 0;
        _lblTitle.backgroundColor = [UIColor clearColor];
        _lblTitle.textColor = [UIColor whiteColor];
        [self addSubview:_lblTitle];
        //
        _lblVotes = [[UILabel alloc] init];
        _lblVotes.numberOfLines = 0;
        _lblVotes.backgroundColor = [UIColor clearColor];
        _lblVotes.textColor = [UIColor whiteColor];
        [self addSubview:_lblVotes];
        //
        _btnUpvote = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 44, 44)];
        [_btnUpvote addTarget:self action:@selector(upvoteTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview: _btnUpvote];
        //
        _btnDownvote = [[UIButton alloc] initWithFrame:CGRectMake(75, 0, 44, 44)];
        [_btnDownvote addTarget:self action:@selector(downvoteTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnDownvote];
        //
        _shield = [[UIView alloc] initWithFrame:self.bounds];
        _shield.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _shield.userInteractionEnabled = NO;
        [self addSubview:_shield];
        //
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_shield addSubview:_spinner];
        _spinner.center = _shield.center;
        _spinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |  UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        if(movie)
            [self updateWithMovie:movie];
    }
    return self;
}

-(void)updateWithMovie:(TLMovieModel *)movie
{
    _movie = movie;
    UIImage *img = [[UIImage alloc] initWithData:movie.posterImageData];
    _imgPoster.image = img;
    [_imgPoster sizeToFit];
    
    _lblTitle.text = [NSString stringWithFormat:@"%d (+%d, -%d)", (movie.upvotes - movie.downvotes), movie.upvotes, movie.downvotes];
    
    //_lblVotes.text = [NSString stringWithFormat:@"%d", (movie.upvotes - movie.downvotes)];
}
-(void)layoutSubviews
{
    _imgPoster.backgroundColor = [UIColor redColor];
    [super layoutSubviews];
    _imgPoster.frame = self.bounds;
    
    //Title Label
    CGRect tempTitleFrame = _lblTitle.frame;
    tempTitleFrame.size.width = _imgPoster.bounds.size.width - 10;
    _lblTitle.frame = tempTitleFrame;
    [_lblTitle sizeToFit];
    _lblTitle.frame = CGRectMake(5, CGRectGetMaxY(_imgPoster.frame) - _lblTitle.frame.size.height - 10,
                                 _lblTitle.frame.size.width, _lblTitle.frame.size.height);
    
    //Votes Label
    [_lblVotes sizeToFit];
    
    //Dark Bottom
    _darkBottom.frame = CGRectMake(0, _lblTitle.frame.origin.y - 10, _imgPoster.frame.size.width,
                                   CGRectGetMaxY(_imgPoster.frame) - _lblTitle.frame.origin.y + 10);
    
    //Upvote Button
    _btnUpvote.backgroundColor = [UIColor orangeColor];
    [_btnUpvote setTitle:@"^" forState:UIControlStateNormal];
    
    //Downvote Button
    _btnDownvote.backgroundColor = [UIColor blueColor];
    [_btnDownvote setTitle:@"v" forState:UIControlStateNormal];

}

-(void)upvoteTapped:(id)sender
{
    if(_upvoteTarget && _upvoteAction)
    {
        [_upvoteTarget performSelector:_upvoteAction withObject:self];
    }
}

-(void)downvoteTapped:(id)sender
{
    if(_downvoteTarget && _downvoteAction)
    {
        [_downvoteTarget performSelector:_downvoteAction withObject:self];
    }
}

-(void)startBusyAnimation
{
    _btnUpvote.enabled = NO;
    _btnDownvote.enabled = NO;
    _shield.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [_spinner startAnimating];
}
-(void)endBusyAnimation
{
        [_spinner stopAnimating];
        _shield.backgroundColor = [UIColor clearColor];
        _btnUpvote.enabled = YES;
        _btnDownvote.enabled = YES;
}

//-(void)voteForMovieIsUpvote:(BOOL)bUp
//{
//    _btnUpvote.enabled = NO;
//    _btnDownvote.enabled = NO;
//    _shield.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//    [_spinner startAnimating];
//    [[TLVoteManager getInstance] voteForMovie:_movie isUpvote:bUp withSuccess:^(BOOL succeeded, NSError *error) {
//        //Success
//        [_spinner stopAnimating];
//        _shield.backgroundColor = [UIColor clearColor];
//        _btnUpvote.enabled = YES;
//        _btnDownvote.enabled = YES;
//        [self updateWithMovie:_movie];
//    } failure:^(BOOL succeeded, NSError *error) {
//        //Failure
//        [_spinner stopAnimating];
//        _shield.backgroundColor = [UIColor redColor];
//        [UIView animateWithDuration:0.2
//                         animations:^{
//                             _shield.backgroundColor = [UIColor clearColor];
//                         }];
//        _btnUpvote.enabled = YES;
//        _btnDownvote.enabled = YES;
//    }];
//}

@end
