//
//  ViewController.m
//  FBDemoApp
//
//  Created by Ismael Saad García on 14/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "ViewController.h"
#import "FBConnect.h"
#import "FriendsView.h"

static NSString* kAppId = @"289441884436725";

@implementation ViewController

@synthesize facebook = _facebook;
@synthesize permissions = _permissions;
@synthesize friendsView = _friendsView;
@synthesize lblAppName = _lblAppName;
@synthesize btnLogin = _btnLogin;
@synthesize btnLogout = _btnLogout;
@synthesize btnShowFriends = _btnShowFriends;
@synthesize activityIndicator = _activityIndicator;
@synthesize navigationController = _navigationController;

#pragma mark - Managing the view
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (!kAppId) {
        NSLog(@"Missing facebook app id");
        exit(1);
        return nil;
    }
    
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        _permissions = [[NSArray alloc] init];
        _facebook = [[Facebook alloc] initWithAppId:kAppId
                                        andDelegate:self];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    // Check whether the token is valid or not. If it is, we do not need to login again
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        _facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        _facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }  
    if ([_facebook isSessionValid]) {        
        [self fbDidLogin];
    } else {
        self.btnLogin.hidden = NO;
    }
}


#pragma mark - Configuring the view orientation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark - Facebook operations
- (void) authorize {
    // Opens a web view to login
    [_facebook authorize:_permissions]; 
}


- (void) fbDidLogin {
    self.btnLogin.hidden = YES;
    self.btnShowFriends.hidden = NO;
    self.btnLogout.hidden = NO;
    
    // Store the access token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[_facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[_facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];  
}


- (void)request:(FBRequest *)request didLoad:(id)result {
    // The request must be the list of friends (the only request performed)
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        
        // We sort the list alphabetically
        NSArray *friends = [[result valueForKey: @"data"] sortedArrayUsingComparator: 
                        (NSComparator)^(NSDictionary *f1, NSDictionary *f2) {
                            return [[f1 valueForKey: @"name"] caseInsensitiveCompare: [f2 valueForKey: @"name"]];
                        }
                        ];
        // Load the view with the list of friends
        [self.activityIndicator stopAnimating];
        FriendsView *friendsView = [[FriendsView alloc] initWithFriends: friends];
        [self presentModalViewController: friendsView animated: YES];
        [friendsView release];
    }
}


- (IBAction) btnLoginTapped:(id)sender {
    [self authorize];
}


- (IBAction) btnShowFriendsTapped:(id)sender {
    [self.activityIndicator startAnimating];
    
    // Request the list of friends
    [_facebook requestWithGraphPath:@"me/friends" andDelegate:self];
}


- (IBAction) btnLogoutTapped:(id)sender {
    [self.activityIndicator startAnimating];
    [_facebook logout];
    self.btnLogout.hidden = YES;
    self.btnShowFriends.hidden = YES;
    self.btnLogin.hidden = NO;
    [self.activityIndicator stopAnimating];
}


#pragma mark - Memory management
- (void) dealloc {
    [super dealloc];
    [_permissions release];
    [_facebook release];
}




@end
