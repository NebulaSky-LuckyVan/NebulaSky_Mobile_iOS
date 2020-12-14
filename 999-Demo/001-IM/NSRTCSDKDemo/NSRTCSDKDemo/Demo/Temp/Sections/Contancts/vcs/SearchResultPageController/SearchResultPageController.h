//
//  SearchResultPageController.h
//  TmpTestDemo
//
//  Created by VanZhang on 2019/11/18.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SearchResultPageController;

typedef void(^SearchPageSelectComplectionHandler)(NSIndexPath*indexPath);

typedef void(^SearchPageSearchKeywordsUpdateHandler)(NSString*keywords,SearchResultPageController*weakSearChPage);

@interface SearchResultPageController : UITableViewController <UISearchControllerDelegate,UISearchBarDelegate>

- (instancetype)initWithSearchResultSelectComplectionHandler:(SearchPageSelectComplectionHandler)complection;
 
//Desc:
@property (weak, nonatomic) UISearchController *searchPageController;
- (SearchResultPageController*(^)(NSArray*searchResultItems))updateSearchResultItemsHandler;

- (SearchResultPageController*(^)(SearchPageSearchKeywordsUpdateHandler updateHandler))updateSearchKeyBordsHandler;





@end

NS_ASSUME_NONNULL_END
