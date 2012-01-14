//
//  ViewController.h
//  FBDemoApp
//
//  Created by Ismael Saad García on 14/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"
#import "FriendsView.h"

@interface ViewController : UIViewController <FBRequestDelegate, FBDialogDelegate, FBSessionDelegate>

@property (readonly) Facebook *facebook;
@property (nonatomic, retain) NSArray *permissions;
@property (nonatomic, retain) FriendsView *friendsView;
@property (nonatomic, retain) IBOutlet UILabel *lblAppName;
@property (nonatomic, retain) IBOutlet UIButton *btnLogin;
@property (nonatomic, retain) IBOutlet UIButton *btnShowFriends;
@property (nonatomic, retain) IBOutlet UIButton *btnLogout;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UINavigationController *navigationController;


@end
