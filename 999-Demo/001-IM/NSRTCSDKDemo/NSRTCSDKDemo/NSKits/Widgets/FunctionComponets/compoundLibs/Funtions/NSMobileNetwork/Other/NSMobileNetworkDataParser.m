//
//  NSMobileNetworkDataParser.m
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import "NSMobileNetworkDataParser.h"
#import <MJExtension/MJExtension.h>
@interface  NSMobileNetworkDataParser()<NSXMLParserDelegate>
@property (assign, nonatomic) NS_Parser_Result resultMainClass;
@property (copy, nonatomic) NSMobileNetworkDataResultBlock parserResultBlock;
@property (copy, nonatomic) NSMobileNetworkDataContentBlock parserContentBlock;


@end
@implementation NSMobileNetworkDataParser


- (void)parserWithFile:(NSString *)filePath forResultClass:(NS_Parser_Result)result fileType:(NS_Parser_File)fileType{
    self.resultMainClass = result;
    switch (fileType) {
        case NS_Parser_JSON:{
            [self json_parserWithFilePath:filePath];
        }break;
        case NS_Parser_XML:{
            [self xml_parserWithFilePath:filePath];
        }break;
        case NS_Parser_Plist:{
            [self plist_parserWithFilePath:filePath];
        }break;
            
        default:
            break;
    }
}

- (void)plist_parserWithFilePath:(NSString *)filePath{ 
    [NSMobileNetworkDataParser plist_parserWithFilePath:filePath withResult:NULL];
}
+ (void)plist_parserWithFilePath:(NSString *)path withResult:(NSMobileNetworkDataResultBlock)block{
    NSString *configFilePath = [path copy];
    if (![[NSFileManager defaultManager]fileExistsAtPath:configFilePath]) {
        NSLog(@"当前路径不存在文件\n路径:%@",configFilePath);
        return;
    }
    if ([NSMobileNetworkDataParser sharedInstance].resultMainClass == NS_Parser_Array) {
        NSArray *array = [NSArray arrayWithContentsOfFile:configFilePath];
        if ([[NSMobileNetworkDataParser sharedInstance].delegate respondsToSelector:@selector(plist_parserDidEndWithArray:)]) {
            [[NSMobileNetworkDataParser sharedInstance].delegate plist_parserDidEndWithArray:array];
        }
        !block?:block(array);
    }else if ([NSMobileNetworkDataParser sharedInstance].resultMainClass == NS_Parser_Dict) {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:configFilePath];
        if ([[NSMobileNetworkDataParser sharedInstance].delegate respondsToSelector:@selector(plist_parserDidEndWithDictionary:)]) {
            [[NSMobileNetworkDataParser sharedInstance].delegate plist_parserDidEndWithDictionary:dict];
        }
        !block?:block(dict);
    }
}






- (void)json_parserWithFilePath:(NSString *)filePath{
//    NSString *configFilePath = [[NSBundle mainBundle]pathForResource:fileName ofType:@"xml"];
    NSString *configFilePath = [filePath copy];
    if (![[NSFileManager defaultManager]fileExistsAtPath:configFilePath]) {
        NSLog(@"当前路径不存在文件\n路径:%@",configFilePath);
        return;
    }
    __weak typeof(self)  weakSelf = self;
    [NSMobileNetworkDataParser json_parserWithFilePath:filePath readingOptions:NSJSONReadingMutableLeaves result:^(id result) {
        if (weakSelf.resultMainClass == NS_Parser_Dict) {
             if ([weakSelf.delegate respondsToSelector:@selector(json_parserDidEndWithDictionary:)]) {
                [weakSelf.delegate json_parserDidEndWithDictionary:result];
             }
        }else if(weakSelf.resultMainClass == NS_Parser_Array){
            if ([weakSelf.delegate respondsToSelector:@selector(json_parserDidEndWithArray:)]) {
                [weakSelf.delegate json_parserDidEndWithArray:result];
            }
        }
    }];
}
- (void)xml_parserWithFilePath:(NSString *)filePath{
//    NSString *configFilePath = [[NSBundle mainBundle]pathForResource:fileName ofType:@"xml"];
    NSString *configFilePath = [filePath copy];
    if (![[NSFileManager defaultManager]fileExistsAtPath:configFilePath]) {
        NSLog(@"当前路径不存在文件\n路径:%@",configFilePath);
        return;
    }
    NSURL *url = [NSURL fileURLWithPath:configFilePath];
    NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithContentsOfURL:url];
    xmlParser.delegate = self;
    [xmlParser parse];
}
#pragma mark private - JSONParserHandler


+ (void)json_parserWithFilePath:(NSString*)path readingOptions:(NSJSONReadingOptions)options result:(NSMobileNetworkDataResultBlock)block{
    [self json_parserWithContentOfURL:[NSURL fileURLWithPath:path] readingOptions:options result:block];
}
+ (void)json_parserWithContentOfURL:(NSURL*)url readingOptions:(NSJSONReadingOptions)options result:(NSMobileNetworkDataResultBlock)block{
    if (!url) {return;}
    NSData *data = [NSData dataWithContentsOfURL:url];
    [self json_parserWithData:data readingOptions:options result:block];
}
+ (void)json_parserWithData:(NSData*)data readingOptions:(NSJSONReadingOptions)options result:(NSMobileNetworkDataResultBlock)block{
    if(!data||data.length<=0){ !block?:block([NSNull null]);return;}
    NSError *err = nil;
    id parserResult =  [NSJSONSerialization JSONObjectWithData:data options:options error:&err];
    if (err){
        if (options==NSJSONReadingAllowFragments) {
            !block?:block(parserResult);
        }else if(options==NSJSONReadingMutableContainers){
            [self json_parserWithData:data readingOptions:NSJSONReadingMutableLeaves result:block];
        }else if(options==NSJSONReadingMutableLeaves){
            [self json_parserWithData:data readingOptions:NSJSONReadingAllowFragments result:block];
        }else{
             [self json_parserWithData:data readingOptions:NSJSONReadingMutableContainers result:block];
        }
    }else{
        if (!parserResult) {
            if (options==NSJSONReadingAllowFragments) {
                !block?:block(parserResult);
            }else if(options==NSJSONReadingMutableContainers){
                [self json_parserWithData:data readingOptions:NSJSONReadingMutableLeaves result:block];
            }else if(options==NSJSONReadingMutableLeaves){
                [self json_parserWithData:data readingOptions:NSJSONReadingAllowFragments result:block];
            }else{
                [self json_parserWithData:data readingOptions:NSJSONReadingMutableContainers result:block];
            }
        }else{
            !block?:block(parserResult);
        }
    }
}

#pragma mark - Json解析
+ (id)removeAllJsonDataStrSpacePosition:(id)jsonData{
    NSString *string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    if (![string containsString:@"html"]) {
        string = [string stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        data = [string dataUsingEncoding:NSUTF8StringEncoding];
    }
    //    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];//Json解析
    return data;
}

+ (NSString *)json_transformToJSONString:(id)obj{
    if ([obj isKindOfClass:[NSString class]]) {
        return (NSString *)obj;
    } else if ([obj isKindOfClass:[NSData class]]) {
        return [[NSString alloc] initWithData:(NSData *)obj encoding:NSUTF8StringEncoding];
    }
    return [[NSString alloc] initWithData:[self toJSONData:obj] encoding:NSUTF8StringEncoding];
}
#pragma mark - 转换为JSON
+ (NSData *)toJSONData:(id)obj
{
    if ([obj isKindOfClass:[NSString class]]) {
        return [((NSString *)obj) dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([self isKindOfClass:[NSData class]]) {
        return (NSData *)obj;
    }
    
    return [NSJSONSerialization dataWithJSONObject:[self toJSONObject:obj] options:kNilOptions error:nil];
}
+ (id)toJSONObject:(id)obj
{
    if ([obj isKindOfClass:[NSString class]]) {
        return [NSJSONSerialization JSONObjectWithData:[((NSString *)obj) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    } else if ([obj isKindOfClass:[NSData class]]) {
        return [NSJSONSerialization JSONObjectWithData:(NSData *)obj options:kNilOptions error:nil];
    }
    return self.mj_keyValues;
}



#pragma mark - NSXMLParserDelegate
+ (void)xml_parserWithFilePath:(NSString *)path withResult:(NSMobileNetworkDataContentBlock)block{
    [NSMobileNetworkDataParser sharedInstance].parserContentBlock = [block copy];
    [[NSMobileNetworkDataParser sharedInstance]xml_parserWithFilePath:path];
}
//step 1 :准备解析
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"开始解析------");
    if ([self.delegate respondsToSelector:@selector(xml_parserDidStartDocument:)]) {
        [self.delegate xml_parserDidStartDocument:parser];
    }
}
//step 2：准备解析节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    //    NSLog(@"elementName:%@",elementName);
    //    NSLog(@"attributes:%@",attributeDict);
    if ([self.delegate respondsToSelector:@selector(xml_parser:didStartElement:namespaceURI:qualifiedName:attributes:)]) {
        [self.delegate xml_parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
    }
    ![NSMobileNetworkDataParser sharedInstance].parserContentBlock?:[NSMobileNetworkDataParser sharedInstance].parserContentBlock(parser,elementName,namespaceURI,qName,attributeDict);

}
//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{}
/**
 step 4 ：解析完当前节点
 
 @param parser 解析器对象
 @param elementName 节点名称
 @param namespaceURI xx
 @param qName xx
 */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{}
//step 5：解析结束
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"------解析结束");
    if ([self.delegate respondsToSelector:@selector(xml_parserDidEndDocument:)]) {
        [self.delegate xml_parserDidEndDocument:parser];
    }
}

//step 6：获取cdata块数据
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{}







//===============SingleTon====================//
static id _instance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
- (instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone{
    return _instance;
}
- (id)mutableCopy{
    return _instance;
}
- (id)copy{
    return _instance;
}
+ (instancetype)sharedInstance{
    return [[self alloc]init];
}
//===================================//
@end
