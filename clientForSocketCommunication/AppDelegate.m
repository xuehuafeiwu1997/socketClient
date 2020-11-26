//
//  AppDelegate.m
//  clientForSocketCommunication
//
//  Created by 许明洋 on 2020/11/25.
//

#import "AppDelegate.h"
#import "TcpViewController.h"
#import "UdpViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
//    TcpViewController *vc = [[TcpViewController alloc] init];
    UdpViewController *vc = [[UdpViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    return YES;
}


@end
