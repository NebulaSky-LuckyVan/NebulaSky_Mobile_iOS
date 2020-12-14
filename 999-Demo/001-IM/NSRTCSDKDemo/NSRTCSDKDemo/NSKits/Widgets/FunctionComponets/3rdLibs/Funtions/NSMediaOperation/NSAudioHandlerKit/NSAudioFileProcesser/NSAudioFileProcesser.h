//
//  NSAudioFileProcesser.h
//  NSRTCSDKDemo
//
//  Created by VanZhang on 2020/12/1.
//  Copyright © 2020 NebulaSky. All rights reserved.
//

#import <Foundation/Foundation.h>
 

@interface NSAudioFileProcesser : NSObject

+ (NSString *)encodeWaveToAmr:(NSString *)waveFile;
+ (NSString *)encodeWaveToAmr:(NSString *)waveFile
                    nChannels:(int)nChannels
               nBitsPerSample:(int)nBitsPerSample;

+ (NSString *)decodeAmrToWave:(NSString *)amrFile;

+ (NSString *)convertedAmrFromWave:(NSString *)waveFile;
+ (NSString *)convertedWaveFromAmr:(NSString *)amrFile;
+ (BOOL)cleanCache;
@end
 
