#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  if(![[NSUserDefaults standardUserDefaults]objectForKey:@"Notification"]){
      [[UIApplication sharedApplication] cancelAllLocalNotifications];
      [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Notification"];
  }
  if(@available(iOS 10.0, *)) {
      [UNUserNotificationCenter currentNotificationCenter].delegate = (id<UNUserNotificationCenterDelegate>) self;
  }

  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
