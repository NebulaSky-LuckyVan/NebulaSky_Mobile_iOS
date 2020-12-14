//
//  SearchResultPageController.m
//  TmpTestDemo
//
//  Created by VanZhang on 2019/11/18.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "SearchResultPageController.h"

@interface SearchResultPageController ()
//Desc:
@property (strong, nonatomic) NSMutableArray *items;

//Desc:
@property (copy, nonatomic) SearchPageSelectComplectionHandler private_selectComplection;

//Desc:
@property (copy, nonatomic) SearchPageSearchKeywordsUpdateHandler private_updateHandler;
@end

@implementation SearchResultPageController

- (instancetype)initWithSearchResultSelectComplectionHandler:(SearchPageSelectComplectionHandler)complection{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.private_selectComplection = [complection copy];
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
}
- (SearchResultPageController *  (^)(NSArray * ))updateSearchResultItemsHandler{
    return ^(NSArray *searchResultItems){
        self.items  = [searchResultItems mutableCopy];
        [self.tableView reloadData];
        return self;
    };
}

- (SearchResultPageController *  (^)(SearchPageSearchKeywordsUpdateHandler  ))updateSearchKeyBordsHandler{
    return ^(SearchPageSearchKeywordsUpdateHandler updateHandler){
        self.private_updateHandler = [updateHandler copy];
        return self;
    };
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.items[indexPath.row];
    // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    !self.private_selectComplection?:self.private_selectComplection(indexPath);
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

#pragma - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"%s",__func__);
}                     // called when text starts editing
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}                       // return NO to not resign first responder
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"%s",__func__);
}                       // called when text ends editing
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{ 
    __weak typeof(self) weakSelf = self;
    !self.private_updateHandler?:self.private_updateHandler(searchText,weakSelf);
}   // called when text changes (including clear)
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
} // called before text changes

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"%s",__func__);
}                    // called when keyboard search button pressed

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    NSLog(@"%s",__func__);
}

#pragma - UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController{
//    self.navigationController.navigationBar.translucent = YES;
}
- (void)didPresentSearchController:(UISearchController *)searchController{
    NSLog(@"%s",__func__);
}
- (void)willDismissSearchController:(UISearchController *)searchController{
//    self.navigationController.navigationBar.translucent = NO;
}
- (void)didDismissSearchController:(UISearchController *)searchController{
    NSLog(@"%s",__func__);
}
- (void)presentSearchController:(UISearchController *)searchController{
    NSLog(@"%s",__func__);
}
@end
