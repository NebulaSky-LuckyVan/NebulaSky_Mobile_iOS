//
//  NSBaseSocketIOOperation.h
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//

#import <Foundation/Foundation.h>
 
@import SocketIO;

typedef void(^DataIOMonitorExcuteHandeler)(NSArray * data, SocketAckEmitter * ack);
typedef void(^DataIOAckExcuteHandeler)(NSArray * data);

@interface NSBaseSocketIOOperation : NSObject
+ (instancetype)shareSocket;
- (NSUInteger)checkStatus;
//Launch Socket
- (NSBaseSocketIOOperation* (^)(NSString* IpAddr,NSDictionary*launchConfig))launchWithSocketServerIPAddr;
//conneect to Server
- (NSBaseSocketIOOperation* (^)(void(^TimeOutResponseHandler)(void)))connectSocketServer;
//close connection 
- (NSBaseSocketIOOperation* (^)(void))connect;
- (NSBaseSocketIOOperation* (^)(void))disconnect;
//Excute
- (NSBaseSocketIOOperation *(^)(NSString*eventToken,NSArray*paramsList))excuteEvent;
//send ack for Identify Authentication
- (NSBaseSocketIOOperation *(^)(NSString*,NSArray*,DataIOAckExcuteHandeler ))sendAckEvent;
//message Monitor register （for 'socket connection status change' or 'data transfer'）
- (NSBaseSocketIOOperation *(^)(DataIOMonitorExcuteHandeler,NSString *))serverEventMonitorRegisterWithEventToken;


@end
 
