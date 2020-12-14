//
//  XHEncryptionKit.h
//  BasePoroject
//
//  Created by Mac on 2018/10/24.
//  Copyright © 2018 VanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XHEncryptionKit : NSObject

+ (NSString*)getSysTimeStamp;
#pragma mark-AES
//加密
+ (NSString *)AES_Encrypt:(NSString *)message password:(NSString *)password;
//解密
+ (NSString *)AES_Decrypt:(NSString *)base64EncodedString password:(NSString *)password;
#pragma mark-DES

//要加密的字符串,加密的约定Key
//加密方法
+ (NSString *)DES_EncryptUseDES:(NSString *)plainText key:(NSString *)key;
//要解密的字符串,解密约定的Key(也就是加密的约定key)
//解密方法
+ (NSString *)DES_DecryptUseDES:(NSString *)cipherText key:(NSString *)key;
#pragma mark-RSA
//一般都是 公钥加密 ，私钥解密的方案
//公钥加密
// return base64 encoded string
+ (NSString *)RSA_EncryptString:(NSString *)str publicKey:(NSString *)pubKey;
// return raw datax
+ (NSData *)RSA_EncryptData:(NSData *)data publicKey:(NSString *)pubKey;
// return base64 encoded string
// enc with private key NOT working YET!
//私钥加密
+ (NSString *)RSA_EncryptString:(NSString *)str privateKey:(NSString *)privKey;
// return raw data
+ (NSData *)RSA_EncryptData:(NSData *)data privateKey:(NSString *)privKey;

// decrypt base64 encoded string, convert result to string(not base64 encoded)
//公钥解密
+ (NSString *)RSA_DecryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSData *)RSA_DecryptData:(NSData *)data publicKey:(NSString *)pubKey;
//私钥解密
+ (NSString *)RSA_DecryptString:(NSString *)str privateKey:(NSString *)privKey;
+ (NSData *)RSA_DecryptData:(NSData *)data privateKey:(NSString *)privKey;
#pragma mark-MD5
+ (NSString *)MD5_EncryptStr:(NSString *)str;
@end
