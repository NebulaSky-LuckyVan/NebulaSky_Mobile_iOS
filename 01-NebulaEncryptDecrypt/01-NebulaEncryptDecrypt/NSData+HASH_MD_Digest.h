//
//  NSData+HASH_MD_Digest.h
//  BasePoroject
//
//  Created by Mac on 2018/10/24.
//  Copyright © 2018 VanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (HASH_MD_Digest)

- (NSData *) MD2Sum;
- (NSData *) MD4Sum;
- (NSData *) MD5Sum;

- (NSData *) SHA1Hash;
- (NSData *) SHA224Hash;
- (NSData *) SHA256Hash;
- (NSData *) SHA384Hash;
- (NSData *) SHA512Hash;
@end
