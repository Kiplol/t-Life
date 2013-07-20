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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    CGFloat posterWidth = _collectionView.frame.size.width - 120;
    CGFloat posterHeight = posterWidth * 1.50f;
    if(posterHeight > _collectionView.frame.size.height)
    {
        posterHeight = _collectionView.frame.size.height - 60.0f;
        posterWidth = posterHeight * (2.0f/3.0f);
    }
    _flowLayout.itemSize = CGSizeMake(posterWidth, posterHeight);
    CGFloat space = self.view.frame.size.width - _flowLayout.itemSize.width;
    CGFloat cornerPeekWidth = 10.0f;
    //_flowLayout.minimumLineSpacing = ((space / 2) - (cornerPeekWidth * 2));
    _flowLayout.minimumInteritemSpacing = ((space / 2) - (cornerPeekWidth * 2));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshMovieData
{
    _arrMovies = [[TLMovieManager getInstance] getAllMovies];
    NSIndexSet * set = [NSIndexSet indexSetWithIndex:0];
    [_collectionView reloadSections:set];
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
    cell.backgroundColor = [UIColor greenColor];
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

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{    
    TLMovieModel * movie = [_arrMovies objectAtIndex:indexPath.row];
    _collectionView.backgroundColor = [UIColor grayColor];
    [[TLVoteManager getInstance] voteForMovie:movie withSuccess:^(BOOL succeeded, NSError *error) {
        //Success
        _collectionView.backgroundColor = [UIColor greenColor];
    } failure:^(BOOL succeeded, NSError *error) {
        //Failure
        _collectionView.backgroundColor = [UIColor redColor];
    }];
    return;
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
