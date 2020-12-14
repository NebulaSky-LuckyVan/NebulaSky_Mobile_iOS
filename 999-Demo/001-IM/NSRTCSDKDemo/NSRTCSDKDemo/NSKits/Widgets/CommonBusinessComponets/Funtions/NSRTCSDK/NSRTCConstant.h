//
//  NSRTCConstant.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/2.
//  Copyright © 2020 NebulaSky. All rights reserved.
//



@import UIKit;
typedef void(^NSRTCBaseBlockHandler)(void);
/// Represents state of a manager or client.
typedef NS_ENUM(NSUInteger, ClientStatus) {
    /// The client/manager has never been connected. Or the client has been reset.
    NSRTCClientStatus_NotConnected = 0,
    /// The client/manager was once connected, but not anymore.
    NSRTCClientStatus_Disconnected = 1,
    /// The client/manager is in the process of connecting.
    NSRTCClientStatus_Connecting = 2,
    /// The client/manager is currently connected.
    NSRTCClientStatus_Connected = 3,
};

