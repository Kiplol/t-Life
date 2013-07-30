//
//  TLFirstViewController.h
//  t+ Life
//
//  Created by Kip on 7/12/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLViewController.h"
#import <GooglePlus/GooglePlus.h>

@class TLMovieModel;
@interface TLMovieListViewController : TLViewController <UICollectionViewDataSource, UICollectionViewDelegate, GPPSignInDelegate> {
    IBOutlet UICollectionView * _collectionView;
    IBOutlet UICollectionViewFlowLayout * _flowLayout;
    IBOutlet UIButton * _btnLogout;
    NSArray * _arrMovies;
    TLMovieModel * _currentScrollMovie;
}

-(void)refreshMovieData;
-(IBAction)logoutTapped:(id)sender;

@end
