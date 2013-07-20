//
//  TLMovieViewCell.h
//  t+ Life
//
//  Created by Kip on 7/19/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TLMovieView;
@class TLMovieModel;
@interface TLMovieViewCell : UICollectionViewCell {
    TLMovieView * _movieView;
}

-(void)updateWithMovie:(TLMovieModel*)movie;
@end
