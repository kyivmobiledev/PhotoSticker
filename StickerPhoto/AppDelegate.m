//
//  AppDelegate.m
//  StickerPhoto
//
//  Created by KyivMobileDev on 8/10/15.
//  Copyright © 2015 KyivMobileDev. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    bool useAppearance = true;
    
    if (useAppearance) {
         [self initStyles];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)initStyles {
    // Colors
    UIColor *mainThemeColor = [UIColor colorWithRed:93.0f/255.0f green:156.0f/255.0f blue:236.0f/255.0f alpha:1.0f];
    //UIColor *mainBackgroundColor = [UIColor colorWithRed:245.0f/255.0f green:247.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
    //UIColor *secondaryBackgroundColor = [UIColor colorWithRed:204.0f/255.0f green:209.0f/255.0f blue:217.0f/255.0f alpha:1.0f];
    UIColor *mainFontColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    //UIColor *secondaryFontColor = [UIColor colorWithRed:67.0f/255.0f green:74.0f/255.0f blue:84.0f/255.0f alpha:1.0f];
    
    // Fonts
    NSString *mainFontFamily = @"AvenirNext-Bold";
    float mainFontSize = 18.0f;
    //NSString *secondaryFontFamily = @"AvenirNext-Regular";
    //float secondaryFontSize = 18.0f;
    //float buttonFontSize = 14.0f;
    
    // Shadows (Off)
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0.0, 0.0);
    shadow.shadowColor = [UIColor clearColor];
    
    // Navigation Bar
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:mainFontFamily size:mainFontSize], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    [[UINavigationBar appearance] setBackgroundColor:mainThemeColor];
    [[UINavigationBar appearance] setTintColor:mainFontColor];
    [[UINavigationBar appearance] setBarTintColor:mainThemeColor];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    // UIButton
    if ([UIButton instancesRespondToSelector:@selector(appearanceWhenContainedInInstancesOfClasses:)]) {
        [[UIButton appearanceWhenContainedInInstancesOfClasses:@[[ViewController class]]] setTitleColor:mainFontColor forState:UIControlStateNormal];
        [[UIButton appearanceWhenContainedInInstancesOfClasses:@[[ViewController class]]] setBackgroundColor:mainThemeColor];
    }
    else {
        [[UIButton appearanceWhenContainedIn:[ViewController class], nil] setTitleColor:mainFontColor forState:UIControlStateNormal];
        [[UIButton appearanceWhenContainedIn:[ViewController class], nil] setBackgroundColor:mainThemeColor];
    }
    
    // Alert Views
    if ([UIView instancesRespondToSelector:@selector(appearanceWhenContainedInInstancesOfClasses:)]) {
        [[UIView appearanceWhenContainedInInstancesOfClasses:@[[UIAlertController class]]] setTintColor:mainThemeColor];
    }
    else {
        [[UIView appearanceWhenContainedIn:[UIAlertController class], nil] setTintColor:mainThemeColor];
    }
}

@end
