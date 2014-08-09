//
//  TRYLoginViewController.m
//  LoginTabbedApp
//
//  Created by shruti gupta on 24/06/14.
//  Copyright (c) 2014 Shruti Gupta. All rights reserved.
//

#import "TRYSetupViewController.h"
#import "TRYAppDelegate.h"

@interface TRYSetupViewController ()

@end

@implementation TRYSetupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)signInAction:(id)sender {
    //TRYAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    //[appDelegate.window setRootViewController:appDelegate.tabBarController];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];

}
@end
