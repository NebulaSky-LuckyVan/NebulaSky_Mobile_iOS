//
//  main.m
//  DobuleMicroApplications
//
//  Created by VanZhang on 2020/11/17.
//  Copyright © 2020 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef HOTPATCHEXIST
APSecBufferRef APSecGetPKS()
{
    char sig[] = {0x89,0x55,0xec,0x73,0xd3,0xb1,0x98,0x20,0xb4,0xa3,0x2b,0x1,0x6a,0x1,0xc5,0x59,0xd9,0x3,0x48,0x9d,0x90,0x32,0x69,0xab,0x8e,0x61,0xb8,0x26,0xd5,0xbe,0xd2,0x42,0xde,0xf8,0x8a,0x4d,0xe2,0x57,0xa9,0xbc,0xb2,0x5b,0x7,0x56,0xfa,0x16,0x38,0x7c,0x27,0x3b,0x98,0x4b,0x12,0x30,0x2f,0x2,0xc0,0x2a,0x4b,0x57,0xfb,0xba,0x90,0xd5,0x17,0x8a,0x31,0x40,0x5e,0x94,0x35,0x9e,0x11,0x5b,0xb5,0x1c,0x5d,0xdb,0x9e,0x97,0x24,0x59,0x61,0xf,0x3,0xe,0x15,0x9d,0x19,0x4c,0x8a,0xba,0x1e,0x41,0x4e,0x25,0x39,0x72,0x41,0xaf,0xb8,0xc1,0x1c,0x35,0x2f,0x55,0xe1,0xbd,0x78,0x49,0xac,0x34,0x6d,0xe8,0x6,0x6f,0x9b,0x5f,0xda,0xd5,0xe8,0xca,0x86,0x4d,0xb3,0xe3,0xc0,0x8c,0x1c,0x6a,0x6c,0x98,0x72,0xe8,0x4d,0xb2,0x6b,0x88,0x22,0x2,0xb3,0xc8,0x77,0x24,0xc,0x62,0xd,0x3d,0xdf,0xfc,0x3e,0xd4,0xf4,0xf3,0x2b,0x89,0x27,0x23,0x57,0xf6,0x52,0x57,0x56,0x71,0x4a,0x91,0xbc,0x36,0xa3,0x59,0x16,0xb5,0xd4,0xd7,0x1d,0x7b,0xd0,0x72,0xb2,0x7e,0xb0,0x84,0x9,0x93,0x4e,0xcd,0x33,0x4e,0xfc,0x25,0x4a,0x50,0x90,0x7a,0x73,0x4f,0x45,0xb4,0x18,0x40,0xdc,0x92,0xf6,0xa1,0x1f,0x34,0xdf,0x63,0x81,0x26,0xcb,0xd3,0x7,0xfe,0x4a,0x17,0xe9,0xe8,0x8,0x80,0xc,0x1b,0xba,0x38,0xb9,0xfe,0x69,0x78,0xbd,0x9d,0xcf,0xe5,0x12,0xdf,0xbe,0x86,0x86,0x11,0x99,0x36,0xb9,0xb2,0xee,0xfc,0x71,0xf6,0x2f,0xbb,0xd9,0x16,0x67,0x42,0x9f,0xb9,0x58,0x89};
    
    size_t len = sizeof(sig);
    APSecBufferRef buf = (APSecBufferRef)malloc(sizeof(APSecBuffer) + len);
    buf->length = len;
    memcpy(buf->data, sig, len);
    return buf;
}
#endif

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
#ifdef HOTPATCHEXIST
        NSString *path;
        APSecBufferRef buf;
        int ret;
        
        path = [[NSBundle mainBundle] pathForResource:@"pubkey" ofType:@"pem"];
        APSecInitPublicKey([path UTF8String]); // 读取并初始化公钥
        
        buf = APSecGetPKS(); // 读取公钥的签名
        ret = APSecVerifyFile([path UTF8String], buf->data, buf->length); // 验证公钥文件自身是否符合签名
        free(buf);
        if (ret != 0) {
            NSLog(@"The public key is modified.");
        }
#endif
        
        return UIApplicationMain(argc, argv, @"DFApplication", @"DFClientDelegate"); // NOW USE MPAAS FRAMEWORK
    }
}
