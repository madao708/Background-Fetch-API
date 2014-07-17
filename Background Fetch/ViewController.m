//
//  ViewController.m
//  Background Fetch
//
//  Created by Bilal ARSLAN on 17/07/14.
//  Copyright (c) 2014 Bilal ARSLAN. All rights reserved.
//

#import "ViewController.h"
#import "XMLParser.h"

@interface ViewController ()

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray *arrNewsData;
@property (nonatomic, strong) NSString *dataFilePath;

-(void)refreshData;
-(void)performNewFetchedDataActionsWithDataArray:(NSArray *)dataArray;
@end

@implementation ViewController

#define NewsFeed @"http://feeds.reuters.com/reuters/technologyNews"

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //  Specify the data stroge file path.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    self.dataFilePath = [NSString stringWithFormat:@"%@newsdata", [paths objectAtIndex:0]];

    //  Initialize the refresh control.
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.dataFilePath])
    {
        self.arrNewsData = [[NSMutableArray alloc] initWithContentsOfFile:self.dataFilePath];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)removeDataFile:(id)sender
{
    
}

#pragma mark - Private Methods
-(void)refreshData
{
    XMLParser *xmlParser = [[XMLParser alloc] initWithXMLURLString:NewsFeed];
    [xmlParser startParsingWithCompletionHandler:
     ^(BOOL success, NSArray *dataArray, NSError *error)
    {
        if (success) {
            [self performNewFetchedDataActionsWithDataArray:dataArray];
            
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"Error!! : %@", [error localizedDescription]);
        }
    }];
}

-(void)performNewFetchedDataActionsWithDataArray:(NSArray *)dataArray
{
    //  Initialize the arrNewsData array with the parsed data array.
    if (self.arrNewsData != nil) {
        self.arrNewsData = nil;
    }
    self.arrNewsData = [[NSArray alloc] initWithArray:dataArray];
    
    //  Reload the tableView
    [self.tableView reloadData];
    
    //  Save the data permanently to file.
    if (![self.arrNewsData writeToFile:self.dataFilePath atomically:YES]) {
        NSLog(@"Couldn't save data to file!");    }
}

#pragma mark - TableView methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellNewsTitle"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"idCellNewsTitle"];
    }
    
    NSDictionary *dict = [self.arrNewsData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dict objectForKey:@"title"];
    cell.detailTextLabel.text = [dict objectForKey:@"pubDate"];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrNewsData.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 80.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.arrNewsData objectAtIndex:indexPath.row];
    
    NSString *newsLink = [dict objectForKey:@"link"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newsLink]];
}


@end
