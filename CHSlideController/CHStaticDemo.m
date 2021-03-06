//
//  UIStaticDemo.m
//  CHSlideController
//
//  Created by Clemens Hammerl on 19.10.12.
//  Copyright (c) 2012 appingo mobile e.U. All rights reserved.
//

#import "CHStaticDemo.h"


@implementation CHStaticDemo

@synthesize delegate;
@synthesize data = _data;

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

        // Create some dummy data
        _data = @[@"Test 1",@"Test 2",@"Test 3",@"Hide Statusbar",@"Hide Navigationbar", @"Shadow ON/OFF",@"Change Width",@"DIM ON/OFF",@"Toggle Bottom View"];
        
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        //self.searchController.searchResultsUpdater = self;
        
        self.searchController.dimsBackgroundDuringPresentation = NO;

        self.definesPresentationContext = YES;
        
        self.tableView.tableHeaderView = self.searchController.searchBar;
        

        
    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    
   
   
    
    [_searchController.searchBar sizeToFit];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor grayColor];
    (self.tableView).backgroundView = bgView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DemoCell"];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DemoCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DemoCell"];
        

    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    
    cell.textLabel.text = _data[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // inform the delegate that something has been selected
    if ([delegate respondsToSelector:@selector(staticDemoDidSelectText:)]) {
        [delegate staticDemoDidSelectText:_data[indexPath.row]];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
