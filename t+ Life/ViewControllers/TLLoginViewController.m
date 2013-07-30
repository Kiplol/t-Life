//
//  TLLoginViewController.m
//  t+ Life
//
//  Created by Kip on 7/12/13.
//  Copyright (c) 2013 Supernovacaine Interactive. All rights reserved.
//

#import "TLLoginViewController.h"
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import <Parse/Parse.h>

static NSString * const kClientID = @"912963317070.apps.googleusercontent.com";

@interface TLLoginViewController ()
-(void)refreshInterfaceBasedOnSignIn;
-(BOOL)loginWithUsername:(NSString*)username email:(NSString*)email password:(NSString*)pword;
@end

@implementation TLLoginViewController
@synthesize signInButton;

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

-(NSString*)nameBaseForBackgroundImage
{
    return @"login";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientID;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin, // defined in GTLPlusConstants.h
                     nil];
    signIn.delegate = self;
    
    if([signIn trySilentAuthentication])
    {
        NSLog(@"They can be logged in automatically");
        self.signInButton.enabled = NO;
    }
    else
    {
        [self.signInButton setBackgroundImage:[UIImage imageNamed:@"btn_signin.png"] forState:UIControlStateNormal];
        [self.signInButton setBackgroundImage:[UIImage imageNamed:@"btn_signin_pressed.png"] forState:UIControlStateHighlighted];
        [self.signInButton sizeToFit];
        [self.signInButton addTarget:signIn action:@selector(authenticate) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshInterfaceBasedOnSignIn
{
    if ([[GPPSignIn sharedInstance] authentication]) {
        // The user is signed in.
        self.signInButton.hidden = YES;
        // Perform other actions here, such as showing a sign-out button
    } else {
        self.signInButton.hidden = NO;
        // Perform other actions here
    }
}

-(void)getMeData
{
    GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
    plusService.retryEnabled = YES;
    [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
    GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
    
    [plusService executeQuery:query
            completionHandler:^(GTLServiceTicket *ticket,
                                GTLPlusPerson *person,
                                NSError *error) {
                if (error) {
                    GTMLoggerError(@"Error: %@", error);
                } else {
                    // Retrieve the display name and "about me" text
                    [self performSegueWithIdentifier:@"loginToHome" sender:nil];
                }
            }];
}
-(BOOL)loginWithUsername:(NSString*)username email:(NSString*)email password:(NSString*)pword;
{
    BOOL success = NO;
    NSError * error = nil;
    PFUser * user =[PFUser logInWithUsername:username password:pword error:&error];
    if(error)
    {
        user = [[PFUser alloc] init];
        user.username = username;
        user.email = email;
        user.password = pword;
        success = [user signUp];
    }
    else
    {
        success = YES;
    }
    if(success)
    {
        [user save];
    }
    return success;
    
}
- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        // Do some error handling here.
        self.signInButton.enabled = YES;
    } else {
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
        NSString * textPlusEmail = [signIn.authentication.userEmail lowercaseString];
        if([textPlusEmail rangeOfString:@"gogii.net"].location == NSNotFound && [textPlusEmail rangeOfString:@"textplusteam.com"].location == NSNotFound)
        {
            //This is not a textPlus person
            UIAlertView * al = [[UIAlertView alloc] initWithTitle:@"Go away"
                                                          message:@"You can only use this app with a textPus email"
                                                         delegate:nil
                                                cancelButtonTitle:@"Fine"
                                                otherButtonTitles: nil];
            [al show];
            [signIn signOut];
            self.signInButton.enabled = YES;
            [self refreshInterfaceBasedOnSignIn];
            return;
        }
        NSString * username = [textPlusEmail substringToIndex:[textPlusEmail rangeOfString:@"@"].location];
        [self refreshInterfaceBasedOnSignIn];
        if([self loginWithUsername:username email:textPlusEmail password:textPlusEmail])
        {
            NSLog(@"Successfully logged in as %@.", username);
            [self getMeData];
        }
    }
}

@end
