//
//  NSMobileNetworkDataParser.h
//  NSMobileNetwork
//
//  Created by VanZhang on 2020/11/30.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>
 

typedef enum{
    NS_Parser_JSON  = 0,
    NS_Parser_XML  = 1,
    NS_Parser_Plist  = 2
}NS_Parser_File;
typedef enum{
    NS_Parser_Array  = 0,
    NS_Parser_Dict  = 1,
}NS_Parser_Result;

typedef void (^NSMobileNetworkDataResultBlock)(id result);
typedef void (^NSMobileNetworkDataContentBlock)(NSXMLParser * parser ,NSString *elementName ,NSString *namespaceURI ,NSString *qName ,NSDictionary *attributeDict);

@protocol NSMobileNetworkDataDelegate <NSObject>

@optional
- (void)xml_parserDidStartDocument:(NSXMLParser *)parser;
- (void)xml_parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
- (void)xml_parserDidEndDocument:(NSXMLParser *)parser;

- (void)plist_parserDidEndWithArray:(NSArray*)result;
- (void)plist_parserDidEndWithDictionary:(NSDictionary*)result;

- (void)json_parserDidEndWithArray:(NSArray*)result;
- (void)json_parserDidEndWithDictionary:(NSDictionary*)result;
@end



@interface NSMobileNetworkDataParser : NSObject
+ (instancetype)sharedInstance;
@property (weak, nonatomic) id<NSMobileNetworkDataDelegate> delegate;
- (void)parserWithFile:(NSString*)filePath forResultClass:(NS_Parser_Result)result fileType:(NS_Parser_File)fileType;

//JSON
+ (void)json_parserWithFilePath:(NSString*)path readingOptions:(NSJSONReadingOptions)options result:(NSMobileNetworkDataResultBlock)block;
+ (void)json_parserWithContentOfURL:(NSURL*)url readingOptions:(NSJSONReadingOptions)options result:(NSMobileNetworkDataResultBlock)block;
+ (void)json_parserWithData:(NSData*)data readingOptions:(NSJSONReadingOptions)options result:(NSMobileNetworkDataResultBlock)block;
+ (NSString*)json_transformToJSONString:(id)obj;
+ (id)removeAllJsonDataStrSpacePosition:(id)jsonData;

//XML
+ (void)xml_parserWithFilePath:(NSString*)path withResult:(NSMobileNetworkDataContentBlock)block;
//Plist
+ (void)plist_parserWithFilePath:(NSString*)path withResult:(NSMobileNetworkDataResultBlock)block;

@end
 
