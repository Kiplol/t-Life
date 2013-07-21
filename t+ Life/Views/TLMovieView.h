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
    UIView * _darkBottom;
    UILabel * _lblVotes;
}

-(id)initWithMovie:(TLMovieModel*)movie;
-(void)updateWithMovie:(TLMovieModel*)movie;
@end
