//
//  NSItemViewModel.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/7.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSBaseViewModel.h"
#import "NSTableViewController.h"
#import "NSCollectionViewController.h"

@interface NSViewItem : NSObject
//Desc:
@property (strong, nonatomic) id Model;
//Desc:
@property (weak, nonatomic) UIView *ItemView;
@property (assign, nonatomic) BOOL IsSelected;
 

+(instancetype)itemWithView:(UIView*)itmView model:(id)md;


@end


@interface NSItemViewModel : NSBaseViewModel

@property (assign, nonatomic) BOOL IsEditing;

- (NSTableViewController*)currTableViewCtrl;

- (NSCollectionViewController*)currCollectionViewCtrl;

- (void)actionAtIndex:(NSIndexPath *)index withItem:(NSViewItem *)itm;
@end
 
