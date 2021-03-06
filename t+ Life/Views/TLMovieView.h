//
//  TLMovieView.h
//  t+ Life
//
//  Created by Kip on 7/19/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TLMovieModel;
@interface TLMovieView : UIView {
    UIImageView * _imgPoster;
    UILabel * _lblTitle;
    UIView * _infoBG;
    UILabel * _lblVotes;
    
    UIButton * _btnUpvote;
    UIButton * _btnDownvote;
    TLMovieModel * _movie;
    
    UIView * _shield;
    UIActivityIndicatorView * _spinner;
    
    SEL _upvoteAction;
    SEL _downvoteAction;
    id _upvoteTarget;
    id _downvoteTarget;
}

@property (nonatomic, readonly) TLMovieModel * movie;

@property (nonatomic) SEL upvoteAction;
@property (nonatomic) SEL downvoteAction;
@property (nonatomic) id upvoteTarget;
@property (nonatomic) id downvoteTarget;

-(id)initWithMovie:(TLMovieModel*)movie;
-(void)updateWithMovie:(TLMovieModel*)movie;
-(void)upvoteTapped:(id)sender;
-(void)downvoteTapped:(id)sender;

-(void)startBusyAnimation;
-(void)endBusyAnimation;
@end
