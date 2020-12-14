//
//  NSData+AES.h
//  BasePoroject
//
//  Created by Mac on 2018/10/24.
//  Copyright © 2018 VanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonCryptor.h>

#import "NSData+HASH_MD_Digest.h"
extern NSString * const kCommonCrypto_AES_ErrorDomain;
@interface NSError (AESCommonCryptoErrorDomain)
+ (NSError *) errorWithCCCryptorStatus: (CCCryptorStatus) status;
@end
@interface NSData (AES) 
+ (NSData *) base64DataFromString:(NSString *)string;
- (NSData *) AES256EncryptedDataUsingKey: (id) key error: (NSError **) error;
- (NSData *) decryptedAES256DataUsingKey: (id) key error: (NSError **) error;
@end
