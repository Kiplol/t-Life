//
//  TLViewController.m
//  t+ Life
//
//  Created by Kip on 7/21/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import "TLViewController.h"
#import "UIImage+ImageBlur.h"

@interface TLViewController ()
-(void)setupBackground;
@end

@implementation TLViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _arrBGimages = [[NSMutableArray alloc] init];
    [self setupBackground];
}

-(void)setupBackground
{
    //return;
    NSString * bgNameBase = [self nameBaseForBackgroundImage];
    int i = 1;
    while (YES)
    {
        NSString * imgName = [NSString stringWithFormat:@"%@%d.png", bgNameBase, i];
        i++;
        UIImage * tempImg = [UIImage imageNamed:imgName];
        if(!tempImg)
            break;
        else
            [_arrBGimages addObject:tempImg];
    }
    UIImage * selectedImage = nil;
	if(_arrBGimages.count == 0)
    {
        //Grab default background
    }
    else
    {
        int randIdx = (arc4random() % _arrBGimages.count);
        selectedImage = [_arrBGimages objectAtIndex:randIdx];
        //Grab random image from _arrBGImages
    }
    
    if(selectedImage)
    {
        //Set the background
        _imgBackground = [[UIImageView alloc] initWithImage:selectedImage];
        _imgBackground.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [_imgBackground sizeToFit];
        
        CGFloat maxContainerDimension = MAX(self.view.bounds.size.width, self.view.bounds.size.height);
        CGRect newBounds = CGRectMake(0, 0, 0, 0);
        if(_imgBackground.frame.size.width > _imgBackground.frame.size.height)
        {
            CGFloat ratio = _imgBackground.frame.size.width / _imgBackground.frame.size.height;
            newBounds = CGRectMake(0, 0, maxContainerDimension * ratio, maxContainerDimension);
        }
        else
        {
            CGFloat ratio = _imgBackground.frame.size.height / _imgBackground.frame.size.width;
            newBounds = CGRectMake(0, 0, maxContainerDimension, maxContainerDimension * ratio);
        }
        
        _imgBackground.frame = newBounds;
        _imgBackground.center = CGPointMake(self.view.frame.size.width * 0.5f, self.view.frame.size.width * 0.5f);
        [self.view addSubview:_imgBackground];
        [self.view sendSubviewToBack:_imgBackground];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    _imgBackground.center = CGPointMake(self.view.bounds.size.width * 0.5f, self.view.bounds.size.height * 0.5);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)nameBaseForBackgroundImage
{
    NSLog(@"[TLViewController nameBaseForBackgoundImage] must override");
    return nil;
}
@end
