//
//  NSUnReadMessageModel.h
//  NSRTCMarketingProj
//
//  Created by VanZhang on 2019/11/20.
//  Copyright © 2019 VanZhang. All rights reserved.
//

#import "NSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSUnReadConversationModel : NSBaseModel
@property (nonatomic,strong) NSString* _id;
@property (nonatomic,strong) NSString* bodies;
@property (nonatomic,strong) NSString* msg_id;
@property (nonatomic,strong) NSNumber* unReadNum;
@property (nonatomic,strong) NSString* from_user;
@property (nonatomic,strong) NSString* to_user;
@property (nonatomic,strong) NSString* chat_type;

@property (nonatomic,strong) NSNumber* timestamp;
@end

NS_ASSUME_NONNULL_END
