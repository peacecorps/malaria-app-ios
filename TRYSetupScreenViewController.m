//
//  TRYSetupScreenViewController.m
//  LoginTabbedApp
//
//  Created by shruti gupta on 27/06/14.
//  Copyright (c) 2014 Shruti Gupta. All rights reserved.
//

#import "TRYSetupScreenViewController.h"

@interface TRYSetupScreenViewController ()
@property (strong, nonatomic) IBOutlet UILabel *setUp;
@property (strong, nonatomic) IBOutlet UILabel *iTake;
@property (strong, nonatomic) IBOutlet UILabel *remindAt;
@property (strong, nonatomic) IBOutlet UILabel *ifForgot;
@property (strong, nonatomic) IBOutlet UITextField *txt;
@property (strong, nonatomic) IBOutlet UITextField *time;
@property (strong, nonatomic) IBOutlet UILabel *medWarning;
@property (strong, nonatomic) IBOutlet UILabel *timeWarning;
- (IBAction)doneButton:(id)sender;

@end

@implementation TRYSetupScreenViewController

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

/*- (IBAction)signInAction:(id)sender {
    //TRYAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    //[appDelegate.window setRootViewController:appDelegate.tabBarController];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}*/

- (IBAction)doneButton:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    

}
@end
