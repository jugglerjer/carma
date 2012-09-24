//
//  CarmaSearchViewController.h
//  Carma
//
//  Created by Jeremy Lubin on 7/5/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLDataDownloader.h"

@interface CarmaSearchViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, LLDataDownloaderDelegate>
{
    UISearchBar *searchBar;
    UITableView *searchTable;
    NSMutableArray *searchResults;
    NSIndexPath *selectedIndex;
    int latestSearch;
}

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITableView *searchTable;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) NSIndexPath *selectedIndex;
@property int latestSearch;

@end
