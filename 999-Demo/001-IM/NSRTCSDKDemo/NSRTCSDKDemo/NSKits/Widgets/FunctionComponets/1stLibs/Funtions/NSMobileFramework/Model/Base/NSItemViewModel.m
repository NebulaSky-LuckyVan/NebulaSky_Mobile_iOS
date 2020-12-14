//
//  NSItemViewModel.m
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/7.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSItemViewModel.h"

@implementation  NSViewItem
+(instancetype)itemWithView:(UIView *)itmView model:(id)md{
    NSViewItem *itm = [[NSViewItem alloc]init];
    itm.ItemView = itmView;
    itm.Model = md;
    return itm;
}
@end
@implementation NSItemViewModel

-(NSTableViewController*)currTableViewCtrl{
    return self.viewController;
}

-(NSCollectionViewController*)currCollectionViewCtrl{
    return self.viewController;
}
-(void)actionAtIndex:(NSIndexPath *)index withItem:(NSViewItem *)itm{}
@end
