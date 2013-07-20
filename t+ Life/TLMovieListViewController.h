//
//  TLFirstViewController.h
//  t+ Life
//
//  Created by Kip on 7/12/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLMovieListViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate> {
    IBOutlet UICollectionView * _collectionView;
    IBOutlet UICollectionViewFlowLayout * _flowLayout;
    NSArray * _arrMovies;
    CGFloat _lastMovieOffset;
    int _currentPage;
}

@end
