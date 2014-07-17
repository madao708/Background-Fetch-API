//
//  ViewController.h
//  Background Fetch
//
//  Created by Bilal ARSLAN on 17/07/14.
//  Copyright (c) 2014 Bilal ARSLAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource>
- (IBAction)removeDataFile:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
