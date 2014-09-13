//
//  TRYAppDelegate.m
//  LoginTabbedApp
//
//  Created by shruti gupta on 24/06/14.
//  Copyright (c) 2014 Shruti Gupta. All rights reserved.
//

#import "TRYAppDelegate.h"
#import "TRYHomeViewController.h"

#import "TRYSetupScreenViewController.h"
#import "TRYPageViewController.h"
#import "TRYInfoHubViewController.h"
#import "TRYItemStore.h"

@implementation TRYAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


TRYPageViewController *homeVC;
NSString *const prefMedicine = @"medicineName";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    //init the view controllers for the tabs, Home and settings
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    homeVC = [[TRYPageViewController alloc] init];
    homeVC.tabBarItem.title = @"Home";

    //Settings controller
    TRYInfoHubViewController *settingsVC = [[TRYInfoHubViewController alloc]init];
    settingsVC.tabBarItem.title = @"Info Hub";
    
    //init the UITabBarController
    
    self.tabBarController = [[UITabBarController alloc]init];
    self.tabBarController.viewControllers = @[homeVC,settingsVC];
    
    //Add the tab bar controller to the window
    [self.window setRootViewController:self.tabBarController];
    
    [self.window makeKeyAndVisible];
    
    if (![[NSUserDefaults standardUserDefaults] valueForKey:@"hasSetUp"]) {
        // first time in
        // create the set up view controller
        // present set up vc
        TRYSetupScreenViewController *setupVC = [[TRYSetupScreenViewController alloc]init];
        [self.window.rootViewController presentViewController:setupVC animated:NO completion:nil];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    BOOL success = [[TRYItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the Items");
        int count = [[[TRYItemStore sharedStore] allItems] count];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        NSArray *x  = [[TRYItemStore sharedStore]allItems];
        for (int i = 0; i < count; i++) {
            TRYModel *y = x[i];
            NSString *dateString = [dateFormat stringFromDate:[y medDate]];
            NSLog(dateString,nil);
            NSLog([NSString stringWithFormat:@"%d", y.getMedStatus],nil);
        }

    }
    else {
        NSLog(@"Could not save any of the Items");}
         // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        

    }
    
    
}





@end
