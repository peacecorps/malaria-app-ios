//
//  TRYHomeViewController.m
//  LoginTabbedApp
//
//  Created by shruti gupta on 24/06/14.
//  Copyright (c) 2014 Shruti Gupta. All rights reserved.
//

#import "TRYHomeViewController.h"
#import "TRYAppdelegate.h"
#import "TRYLoginViewController.h"

@interface TRYHomeViewController ()
- (IBAction)setupScreenAction:(id)sender;

@end

@implementation TRYHomeViewController

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

- (IBAction)setupScreenAction:(id)sender {
   // TRYAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
   TRYLoginViewController *loginVC = [[TRYLoginViewController alloc] init];
    
    //[appDelegate.window setRootViewController:login];
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
 [self.view.window.rootViewController presentViewController:loginVC animated:YES completion:nil];
    
}
@end
