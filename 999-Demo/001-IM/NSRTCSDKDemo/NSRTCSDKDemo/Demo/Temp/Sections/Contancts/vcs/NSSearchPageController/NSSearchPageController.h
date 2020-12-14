//
//  NSSearchPageController.h
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/18.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
 
typedef void(^NSSearchPageComplectionHandler)(NSString*titles);

@interface NSSearchPageController : UISearchController
- (instancetype)initWithNormalSearchPageWithSearchComplection:(NSSearchPageComplectionHandler)complection;
//Desc:
@property (strong, nonatomic) NSMutableArray *searchOrinalItems;
@end
 
