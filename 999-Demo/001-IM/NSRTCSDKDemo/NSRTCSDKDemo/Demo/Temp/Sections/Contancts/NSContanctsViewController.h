//
//  NSContanctsViewController.h
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/11.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSTableViewController.h" 
#import "NSSearchPageController.h"

@interface NSContanctsViewController : NSTableViewController
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *sectionTitles;
@property (nonatomic, strong,readonly) NSSearchPageController *searchCtrlPage;


@end
 
