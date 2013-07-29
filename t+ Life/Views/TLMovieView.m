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
        _infoBG = [[UIView alloc] init];
        _infoBG.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self addSubview:_infoBG];
        //
        _lblTitle = [[UILabel alloc] init];
        _lblTitle.numberOfLines = 0;
        _lblTitle.backgroundColor = [UIColor clearColor];
        _lblTitle.textColor = [UIColor whiteColor];
        [self addSubview:_lblTitle];
        //
        _lblVotes = [[UILabel alloc] init];
        _lblVotes.numberOfLines = 0;
        _lblVotes.textAlignment = NSTextAlignmentRight;
        _lblVotes.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
        _lblVotes.backgroundColor = [UIColor clearColor];
        _lblVotes.textColor = [UIColor whiteColor];
        [self addSubview:_lblVotes];
        //
        _btnUpvote = [[UIButton alloc] init];
        [_btnUpvote setImage:[UIImage imageNamed:@"btn_upvote.png"] forState:UIControlStateNormal];
        [_btnUpvote sizeToFit];
        [_btnUpvote addTarget:self action:@selector(upvoteTapped:) forControlEvents:UIControlEventTouchUpInside];
        _btnUpvote.alpha = 0.9f;
        [self addSubview: _btnUpvote];
        //
        _btnDownvote = [[UIButton alloc] init];
        [_btnDownvote setImage:[UIImage imageNamed:@"btn_downvote.png"] forState:UIControlStateNormal];
        [_btnDownvote sizeToFit];
        [_btnDownvote addTarget:self action:@selector(downvoteTapped:) forControlEvents:UIControlEventTouchUpInside];
        _btnDownvote.alpha = 0.9f;
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
    
    _lblVotes.text = [NSString stringWithFormat:@"%d (+%d, -%d)", (movie.upvotes - movie.downvotes), movie.upvotes, movie.downvotes];
    
    //_lblVotes.text = [NSString stringWithFormat:@"%d", (movie.upvotes - movie.downvotes)];
}
-(void)layoutSubviews
{
    _imgPoster.backgroundColor = [UIColor redColor];
    [super layoutSubviews];
    _imgPoster.frame = self.bounds;
    
    
    //Votes Label
    [_lblVotes sizeToFit];
    
    //Downvote Button
    _btnDownvote.frame = CGRectMake(self.bounds.size.width - _btnDownvote.frame.size.width,
                                    self.bounds.size.height - _btnDownvote.frame.size.height,
                                    _btnDownvote.frame.size.width, _btnDownvote.frame.size.height);
    //Upvote Button
    _btnUpvote.frame = CGRectMake(_btnDownvote.frame.origin.x - _btnUpvote.frame.size.width,
                                  _btnDownvote.frame.origin.y,
                                  _btnUpvote.frame.size.width, _btnUpvote.frame.size.height);
    //_infoBG
    _infoBG.frame = CGRectMake(0, 0, _imgPoster.frame.size.width, _lblVotes.font.pointSize * 1.45);
    //Title Label
    [_lblVotes sizeToFit];
    _lblVotes.frame = CGRectMake(0, 0, _imgPoster.frame.size.width, _lblVotes.frame.size.height);
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
