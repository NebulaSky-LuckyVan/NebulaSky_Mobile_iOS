//
//  AppDelegate.m
//  01-NebulaEncryptDecrypt
//
//  Created by VanZhang on 2020/11/4.
//

#import "AppDelegate.h"
#import "XHEncryptionKit.h"
#import "NSData+AES.h"
#import "NSString+AES.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    NSString *didEncryptStr = @"iVBORw0KGgoAAAANSUhEUgAAASwAAAEsAQAAAABRBrPYAAAFMElEQVR42u2aPY6kSBBGA2GkBxdA4hp4eSW4AEVdoLhSelwDKS9AeRiI2Be01hh6jDUynRWjUWt6+rWUEz9ffBE9ov/l1yYP9mAP9mAP9mD/R+wQaQZtir3p+cPCx/a7tJsTcRmxl7ZbF0/f9H7tpTxF6t3+UpeMWO/aT9e+g27OnjQs5UfKN6/NjM1LfO/l1oHxvLWSo16yY29tP444iMg6LGuxSJEZuwJevsMxSvNa+DRu3r5Rc2Jyldmv338ry2SYkZXEiQKwt8nLvhLn5XcDJsSOylkrTW4dPVk4CpVe4u+ApMUIOxU+uUakpa2K0E4d0ciLVZ1UspL3Xg7aeSb+Xfne4+YyYsPO2w4q3Go7SO/i1q2vpZx8RozgFxq/Wm6u3MiDa4pwCElx+TB+xdNRbzLSULTYvhah/Di0Kx92EARBn4XnUe0yIl+egKDY+TCdrc6JgNBWFSnwUgdeWE4uH3YMShZMMT6+nckFTa1HHe7tnBYryH5XfnUdu2MIzAXGBOIZb29Li/Wd9N1a01C+JPWq7RwoBr2P3ZSYvhc6mhHfjK6pgxQ76rEOKInLiG18lcJWSEJxvHbGLpajGTNiBIR/+3qpVmQUTtbORKY9fUasDu3JuN9NN16BYsPLISXxlqykmJ7+GHFQO0+Kk+eptHMzelosI8bAnbUZdpybeQw+VpSBb6qc2OZxa+0k8eNNRoodKSNE8qeVSovZcK86vA0N1SIjTN5Br0dqRkw6Pa2ko4bG9MTpd4lTd+usxNjoShSDRE8ERK8dZF9rvUtNWkxs6TAfhafaOv0SFld+g/5Zb4mxV8D/K8LFKESvPiKVL3W5pz4tNixx3htrrsALy+/OV4gSGcmH8Soh7x9fzqHB0oyeGaG8sF7yYTyDREjvD/wbwZk8lhW1xMHmwyjppur0vUuNklhzgcU3rsblwxAQbCqigSav9jZqj0HsjpvjSorpJLYvbyR9sY2SXZIBUf1KVlrsFEYtDyMROi+rdIzCBmbOiOHfGjb00evpyo+gY0j0v4Y8G4ZNZepZOvamchhXk5HvjlvOh9kE/AY7gAwB6WDPOmqVUUxCs2GEgl5mytue1XeRaq9sn73v9WmxeqfSItv6xVDncdYVMRmWfJh+1XqKAmAj6B3yVW5mXOOfG2VijPiLMzd+dgDMvhVHx2J78yFpMSaRnX2oOqY8dtGObDxyHTJi175j9xA080pBsI2g735VSFJMcKqeDSt+9/USrnLe+fQYlnwYEwEbQxaYgzSX/X4F26A1J2ZONbB00Estg0muU8zH6+2YkBQjC2wcLUHAXSCYqnESxCRqRgybqjPrecAko8zUGxqCUN83yqSYufHTy3WYbS/HeNjY/eVqkmK8zW5r0tnRsrdbNNOhfIf7ESYpRvApLVb15noekmWTl3a7jd2kmOLDT3JNW7FOurXYfy5dx+0snBZj3xE8G1uPTXn+YOlQbe/bblJsNvUwd7rZULATohWb3RXzYWgUZuY6MSmF17zsh0eRZeSmlmmxl11Kfw7RWOKf0c80XG9vS4uxUWog6TZ2xbFB09R8l7wyYj91TiuJKZhJ9Hqd3I8hI2YaMqFdC3rFqGWTZYeNp7vdQxJj6DO7FX54sp+ktDMFQNlfoz8fRvztpzaLWgE4O+4VKjYEfV6sYOlw1wk64HBsYf+adcyK4Z1YJGHWyq0vtQ1oNnOVEXtd26teTpUBZNbR7l33CZgWE7vdIcjlT9KL/fppr2tqzYc9/zPhwR7swR7swR7sr9g/Y4uyuP5/heMAAAAASUVORK5CYII=";
    
    
    NSLog(@"AES_Decode:%@",[XHEncryptionKit AES_Decrypt:didEncryptStr password:@"multichannelECTIP"]);
//    NSLog(@"AES_Decode:%@",[XHEncryptionKit AES_Decrypt:@"DaXBfpzFWgPOVRzIdwBpFw==" password:@"multichannelECTIP"]);
    
//    NSLog(@"AES_Decode:%@",[XHEncryptionKit AES_Decrypt:@"multichannelECTIP" password:@"DaXBfpzFWgPOVRzIdwBpFw=="]);
 
    // Override point for customization after application launch.
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
