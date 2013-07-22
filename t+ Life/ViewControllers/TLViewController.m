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

- (void)viewDidLoad
{
    [super viewDidLoad];
    _arrBGimages = [[NSMutableArray alloc] init];
    NSString * bgNameBase = [self nameBaseForBackgroundImage];
    int i = 1;
    while (YES)
    {
        NSString * imgName = [NSString stringWithFormat:@"%@%d", bgNameBase, i];
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
    //Set the background
    _imgBackground = [[UIImageView alloc] initWithImage:selectedImage];
    _imgBackground.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:_imgBackground];
    [self.view sendSubviewToBack:_imgBackground];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
