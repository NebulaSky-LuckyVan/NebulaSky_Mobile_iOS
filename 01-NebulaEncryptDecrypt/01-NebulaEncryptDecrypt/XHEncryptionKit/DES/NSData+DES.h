//
//  NSData+DES.h
//  BasePoroject
//
//  Created by Mac on 2018/10/24.
//  Copyright © 2018 VanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSData+HASH_MD_Digest.h"
#import <CommonCrypto/CommonCryptor.h>
extern NSString * const kCommonCrypto_DES_ErrorDomain;
@interface NSError (DESCommonCryptoErrorDomain)
+ (NSError *) errorWithCCCryptorStatus: (CCCryptorStatus) status;
@end
@interface NSData (DES)
- (NSData *) DESEncryptedDataUsingKey: (id) key error: (NSError **) error;
- (NSData *) decryptedDESDataUsingKey: (id) key error: (NSError **) error;
@end
