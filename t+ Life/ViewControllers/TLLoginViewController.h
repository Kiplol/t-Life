//
//  TLLoginViewController.h
//  t+ Life
//
//  Created by Kip on 7/12/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>

@class GPPSignInButton;
@interface TLLoginViewController : UIViewController <GPPSignInDelegate> {
    
}

@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;

@end
