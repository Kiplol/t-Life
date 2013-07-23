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
#import "TLVoteManager.h"
#import <Parse/Parse.h>

@interface TLMovieListViewController ()

-(void)sizeCollectionCells;
@end

@implementation TLMovieListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	_arrMovies = [[TLMovieManager getInstance] getCachedMovies];
    [self performSelectorInBackground:@selector(refreshMovieData) withObject:nil];
}

-(NSString*)nameBaseForBackgroundImage
{
    return @"movie";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self sizeCollectionCells];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self sizeCollectionCells];
    //[_collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}
-(void)sizeCollectionCells
{
    CGFloat posterWidth = _collectionView.frame.size.width - 90;
    CGFloat posterHeight = posterWidth * 1.50f;
    if(posterHeight > _collectionView.frame.size.height)
    {
        posterHeight = _collectionView.frame.size.height - 60.0f;
        posterWidth = posterHeight * (2.0f/3.0f);
    }
    _flowLayout.itemSize = CGSizeMake(posterWidth, posterHeight);
    CGFloat space = self.view.frame.size.width - _flowLayout.itemSize.width;
    CGFloat cornerPeekWidth = 10.0f;
    _flowLayout.minimumInteritemSpacing = ((space / 2) - (cornerPeekWidth * 2));
    
    CGFloat vertPadding = _collectionView.frame.size.height / 2 - _flowLayout.itemSize.height / 2;
    _flowLayout.sectionInset = UIEdgeInsetsMake(vertPadding, 40, vertPadding, 40);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshMovieData
{
    _arrMovies = [[TLMovieManager getInstance] getAllMovies];
    [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    int nMovies = _arrMovies.count;
    for(int i = 0; i < nMovies; i++)
    {
        TLMovieModel * movie = [_arrMovies objectAtIndex:i];
        [[TLVoteManager getInstance] updateVotesForMovie:movie completion:^(BOOL succeeded, NSError *error) {
            [_collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]];
        }];
    }
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
    [cell updateWithMovie:[_arrMovies objectAtIndex:indexPath.row]];
    [cell setNeedsLayout];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{    
    TLMovieModel * movie = [_arrMovies objectAtIndex:indexPath.row];
    NSURL * aboutURL = [NSURL URLWithString:movie.aboutURL];
    [[UIApplication sharedApplication] openURL:aboutURL];
}

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
