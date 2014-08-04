//
//  TRYAnalyticsIViewController.m
//  LoginTabbedApp
//
//  Created by shruti gupta on 17/07/14.
//  Copyright (c) 2014 Shruti Gupta. All rights reserved.
//

#import "TRYAnalyticsIViewController.h"

@interface TRYAnalyticsIViewController ()
@property (strong, nonatomic) IBOutlet UILabel *labelMedLastTaken;
@property (strong, nonatomic) IBOutlet UILabel *labelDosesMissing;
@property (strong, nonatomic) IBOutlet UILabel *labelAdherence;

@end

@implementation TRYAnalyticsIViewController

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

- (void) viewWillAppear:(BOOL)animated{

    NSDate *dateMedLastTaken = (NSDate*) [[NSUserDefaults standardUserDefaults] valueForKey:@"medLastTaken"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM"];
    [_labelMedLastTaken setText:[dateFormat stringFromDate:dateMedLastTaken]];
    NSInteger dosesMissing =(NSInteger)[[NSUserDefaults standardUserDefaults] valueForKey:@"dosesInARow"];
    NSString *number = [[NSString alloc] initWithFormat:@"%d", dosesMissing];

    [_labelDosesMissing setText:number];
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
