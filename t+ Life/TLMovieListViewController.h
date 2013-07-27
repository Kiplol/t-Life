//
//  TLFirstViewController.h
//  t+ Life
//
//  Created by Kip on 7/12/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLViewController.h"

@class TLMovieModel;
@interface TLMovieListViewController : TLViewController <UICollectionViewDataSource, UICollectionViewDelegate> {
    IBOutlet UICollectionView * _collectionView;
    IBOutlet UICollectionViewFlowLayout * _flowLayout;
    NSArray * _arrMovies;
    TLMovieModel * _currentScrollMovie;
}

-(void)refreshMovieData;

@end
