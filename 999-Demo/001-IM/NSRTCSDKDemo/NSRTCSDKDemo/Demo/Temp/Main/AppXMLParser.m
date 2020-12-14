//
//  AppXMLParser.m
//  BasePoroject
//
//  Created by Mac on 2018/9/16.
//  Copyright © 2018年 VanZhang. All rights reserved.
//

#import "AppXMLParser.h"
//#import "ChildVcObj.h"

@interface AppXMLParser ()<NSXMLParserDelegate>
@property (strong, nonatomic) NSMutableArray * childVcs ;

@end
@implementation AppXMLParser
static id _instance;
+(instancetype)shareInstance{
    return [[self alloc]init];
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
-(instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
//    if (_instance) {
//        NSString *configFilePath = [[NSBundle mainBundle]pathForResource:@"App.config" ofType:@"xml"];
//        NSURL *url = [NSURL fileURLWithPath:configFilePath];
//        NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithContentsOfURL:url];
//        xmlParser.delegate = self;
//        [xmlParser parse];
//    }
    return _instance;
}
-(id)copyWithZone:(NSZone *)zone{
    return _instance;
}
-(id)copy{
    return _instance;
}



-(NSMutableArray*)parser;{
    
    NSString *configFilePath = [[NSBundle mainBundle]pathForResource:@"App.config" ofType:@"xml"];
    NSURL *url = [NSURL fileURLWithPath:configFilePath];
    NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithContentsOfURL:url];
    xmlParser.delegate = self;
    [xmlParser parse];
    
    
    
    return _childVcs;
}

-(NSMutableArray *)parserWithFileName:(NSString *)fileName{
    NSString *configFilePath = [[NSBundle mainBundle]pathForResource:fileName ofType:@"xml"];
    NSURL *url = [NSURL fileURLWithPath:configFilePath];
    NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithContentsOfURL:url];
    xmlParser.delegate = self;
    [xmlParser parse];
    
    return _childVcs;
}
#pragma mark - NSXMLParserDelegate
//step 1 :准备解析
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"开始解析------");
    _childVcs = [NSMutableArray array];
    
}
//step 2：准备解析节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    //    NSLog(@"elementName:%@",elementName);
    //    NSLog(@"attributes:%@",attributeDict);
    if ([elementName isEqualToString:@"vc"]) {
        ChildVcObj *childVc = [[ChildVcObj alloc]init];
        childVc.className = attributeDict[@"className"];
        childVc.navTitle = attributeDict[@"navTitle"];
        childVc.tabTitle = attributeDict[@"tabTitle"];
        childVc.tabBarItemNormalImage = attributeDict[@"tabBarItemNormalImage"];
        childVc.tabBarItemSelImage = attributeDict[@"tabBarItemSelImage"];
        [_childVcs addObject:childVc];
    }
}
//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
}
/**
 step 4 ：解析完当前节点
 
 @param parser 解析器对象
 @param elementName 节点名称
 @param namespaceURI xx
 @param qName xx
 */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
}
//step 5：解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    
    NSLog(@"------解析结束");
}

//step 6：获取cdata块数据
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    
}




@end
