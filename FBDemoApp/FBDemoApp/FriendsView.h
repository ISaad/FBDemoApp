//
//  FriendsView.h
//  FBDemoApp
//
//  Created by Ismael Saad García on 14/01/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsView : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSArray *friends;
@property (nonatomic, retain) NSMutableArray *indexValues;
@property (nonatomic, retain) NSMutableArray *index;
@property (nonatomic, retain) IBOutlet UITableView *tableFriends;

- (id) initWithFriends: (NSArray *) friends;

@end
