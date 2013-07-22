//
//  TLViewController.h
//  t+ Life
//
//  Created by Kip on 7/21/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLViewController : UIViewController {
    UIImageView * _imgBackground;
    NSMutableArray * _arrBGimages;
}

-(NSString*)nameBaseForBackgroundImage;
@end
