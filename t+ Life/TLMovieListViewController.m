//
//  TLFirstViewController.m
//  t+ Life
//
//  Created by Kip on 7/12/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import "TLMovieListViewController.h"
#import "TLMovieManager.h"
#import "TLMovieModel.h"
#import "TLMovieViewCell.h"
#import <Parse/Parse.h>

@interface TLMovieListViewController ()

@end

@implementation TLMovieListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	_arrMovies = [[TLMovieManager getInstance] getCachedMovies];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGFloat posterWidth = self.view.frame.size.width - 100;
    CGFloat posterHeight = posterWidth * 1.50f;
    _flowLayout.itemSize = CGSizeMake(posterWidth, posterHeight);
    CGFloat space = self.view.frame.size.width - _flowLayout.itemSize.width;
    CGFloat cornerPeekWidth = 10.0f;
    _flowLayout.minimumLineSpacing = ((space / 2) - (cornerPeekWidth * 2));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return _arrMovies.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TLMovieViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieCell" forIndexPath:indexPath];
    //cell.backgroundColor = [UIColor greenColor];
    [cell updateWithMovie:[_arrMovies objectAtIndex:indexPath.row]];
    [cell setNeedsLayout];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    return nil;
//}

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    if (_lastMovieOffset > scrollView.contentOffset.x)
//        _currentPage = MAX(_currentPage - 1, 0);
//    else if (_lastMovieOffset < scrollView.contentOffset.x)
//        _currentPage = MIN(_currentPage + 1, 5);
//    
//    float questionOffset = (_flowLayout.itemSize.width + (2 * _flowLayout.minimumLineSpacing)) * _currentPage;
//    _lastMovieOffset = questionOffset;
//    [_collectionView setContentOffset:CGPointMake(questionOffset, 0) animated:YES];
//}

@end
