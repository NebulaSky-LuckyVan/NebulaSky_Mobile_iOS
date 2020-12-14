//
//  NSBaseSocketIOOperation.m
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//

#import "NSBaseSocketIOOperation.h"
#import <SocketIO/SocketIO-Swift.h>
/*
 Work flow
 1. connection
 
 2. register message Monitor --> We could build Event Notify System with the base of messageIO Monitor mechanism
 
 3. sendMessage ---> We could generate Event Interation with the Base Construction From  messageIO Systems;
 
 */
#pragma SocketIO

@interface NSBaseSocketIOOperation ()

@property (strong, nonatomic) SocketManager * manager;
@property (strong, nonatomic) SocketIOClient * socket;
@end
@implementation NSBaseSocketIOOperation



- (NSUInteger)checkStatus{
    return [NSBaseSocketIOOperation shareSocket].socket.status;
}
//Launch Socket
-(NSBaseSocketIOOperation* (^)(NSString* IpAddr,NSDictionary*launchConfig))launchWithSocketServerIPAddr{
    return ^(NSString* IpAddr,NSDictionary*launchConfig){
        NSLog(@"the server addr is %@", IpAddr);
        //链接服务器
        NSURL* url = [[NSURL alloc] initWithString:IpAddr];
        self->_manager = [[SocketManager alloc] initWithSocketURL:url
                                                           config:launchConfig];
        //        self->_socket = [self->_manager socketForNamespace:@"/"];
        self->_socket = [self->_manager defaultSocket];
        
        return self;
    };
}
//conneect to Server
-(NSBaseSocketIOOperation* (^)(void(^TimeOutResponseHandler)(void)))connectSocketServer{
    return ^(void(^TimeOutResponseHandler)(void)){
        [self->_socket connectWithTimeoutAfter: 15.0 withHandler:^(void){
            NSLog(@"socket connect_timeout 15.0s");
            !TimeOutResponseHandler?:TimeOutResponseHandler();
        }];
        return self;
    };
}
- (NSBaseSocketIOOperation* (^)(void))connect{
    return ^(void){
        [self->_socket connect];
        return self;
    };
}
//close connection
-(NSBaseSocketIOOperation* (^)(void))disconnect{
    return ^(void){
        [self->_socket disconnect];
        return self;
    };
}
//Excute
- (NSBaseSocketIOOperation *(^)(NSString*eventToken,NSArray*paramsList))excuteEvent{
    return ^(NSString*eventToken,NSArray*paramsList){
        if(self->_socket.status == SocketIOStatusConnected) {
            if(paramsList){
                //                NSLog(@"eventToken:%@,json:%@",eventToken, paramsList);
                //                 NSLog(@"json:%@", paramsList.lastObject);
                [self->_socket emit:eventToken with:paramsList];
                
             }else{
                NSLog(@"error: event desption is empty!");
            }
            
        } else {
            NSLog(@"the socket has been disconnect!");
        }
        return self;
    };
}
//send ack for Identify Authentication
- (NSBaseSocketIOOperation *(^)(NSString*,NSArray*,DataIOAckExcuteHandeler ))sendAckEvent{
    return ^(NSString*ack,NSArray*paramsList,DataIOAckExcuteHandeler response){
        if(self->_socket.status == SocketIOStatusConnected) {
            if(paramsList){
                //                NSLog(@"eventToken:%@,json:%@",eventToken, paramsList);
                //                 NSLog(@"json:%@", paramsList.lastObject);
                [[self->_socket emitWithAck:ack with:paramsList]timingOutAfter:15 callback:response];
            }else{
                NSLog(@"error: event desption is empty!");
            }
            
        } else {
            NSLog(@"the socket has been disconnect!");
        }
        return self;
    };
}


//message Monitor register （for 'socket connection status change' or 'data transfer'）
- (NSBaseSocketIOOperation *(^)(DataIOMonitorExcuteHandeler,NSString *))serverEventMonitorRegisterWithEventToken{
    return ^(DataIOMonitorExcuteHandeler response,NSString *eventToken){
        [self->_socket on:eventToken callback:response];
        return self;
    };
}



//=========//
static id _instance;
+ (instancetype)shareSocket{
    return [[self alloc]init];
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance  = [super init];
    });
    return _instance;
}
- (id)copy{
    return _instance;
}
- (id)mutableCopy {
    return _instance;
}
//=========//
@end
