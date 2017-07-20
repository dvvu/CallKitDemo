//
//  AppDelegate.m
//  CallKitDemo
//
//  Created by Doan Van Vu on 7/19/17.
//  Copyright © 2017 Doan Van Vu. All rights reserved.
//

#import "AppDelegate.h"
#import <Intents/Intents.h>
#import "CallViewController.h"
#import <PushKit/PushKit.h>

@interface AppDelegate () <PKPushRegistryDelegate>

@end

@implementation AppDelegate

+ (AppDelegate *)shared {
    
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    PKPushRegistry* pushRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
    pushRegistry.delegate = self;
    pushRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(nonnull void (^)(NSArray * _Nullable))restorationHandler {
    
    if ([userActivity.interaction.intent isKindOfClass:[INStartAudioCallIntent class]]) {
        
        INPerson* inperson = [[(INStartAudioCallIntent *)userActivity.interaction.intent contacts] firstObject];
        
        NSString* phoneNumber = inperson.personHandle.value;
        
        CallViewController* callViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CallViewController"];
        callViewController.phoneNumber = phoneNumber;
        
        UIViewController* mainViewController = self.window.rootViewController;
        
        [mainViewController presentViewController:callViewController animated:YES completion:nil];
    }
    
    return YES;
}

#pragma mark - PKPushRegistryDelegate

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(NSString *)type {
    
    if([credentials.token length] == 0) {
        
        NSLog(@"voip token NULL");
        return;
    }
}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(NSString *)type {
    
    NSString* uuidString = payload.dictionaryPayload[@"UUID"];
    NSUUID* uuid = [[NSUUID alloc] initWithUUIDString:uuidString];
    NSString* phoneNumber = payload.dictionaryPayload[@"PhoneNumber"];
    
    CallViewController* callViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CallViewController"];
    
    callViewController.phoneNumber = phoneNumber;
    callViewController.isIncoming = YES;
    callViewController.uuid = uuid;
    
    UIViewController* mainViewController = self.window.rootViewController;
    [mainViewController presentViewController:callViewController animated:YES completion:nil];
}

-(void)display {
    
}

@end
