//
//  TRYHomeViewController.m
//  LoginTabbedApp
//
//  Created by shruti gupta on 24/06/14.
//  Copyright (c) 2014 Shruti Gupta. All rights reserved.
//

#import "TRYHomeViewController.h"
#import "TRYAppdelegate.h"
#import "TRYSetupScreenViewController.h"

@interface TRYHomeViewController ()
//- (IBAction)setupScreenAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *background;

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
    //medicine missed till now
    
    NSLog(@"viewDidLoad");
    
    _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    _background.frame = self.view.bounds;
    [[self view] addSubview:_background];
    [_background.superview sendSubviewToBack:_background];
    
    

    self->medTaken = 0;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    self->medName = [prefs stringForKey:@"medicineName"];
    // NSLog(self->medName);
    
    medicineName.text = self->medName;
    
    
    NSDate *startDay = [prefs objectForKey:@"startDay"];
    
    
    
    
    //self->reminderDate = startDay;
    
    self->reminderDate = [[NSDate alloc] initWithTimeInterval:0 sinceDate:startDay];
    [[NSUserDefaults standardUserDefaults] setObject:@"shruti" forKey:@"reminderTimeFinal"];
    

   
}


-(void) updateLabel:(NSDate*) argDate

{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    remindDate.text = [dateFormat stringFromDate:reminderDate];
    

   NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *x = [prefs stringForKey:@"reminderTimeFinal"];
   if(![x isEqualToString:@"shruti"])
    {
        NSLog(@"1");
        self->reminderDate = [(NSDate*)[prefs objectForKey:@"reminderTimeFinal"] dateByAddingTimeInterval:0 ];
       // x = @"gupta";
    }
    
    
    
    [dateFormat setDateFormat:@"EEEE"];
    //NSLog([dateFormat  stringFromDate:startDay]);
    remindDay.text = [dateFormat  stringFromDate:argDate ];
    
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    self->frequency = [self determineMedFrequency:medName.lowercaseString];
    //self->rDate = startDay;
    
    
    
    self->reminderDate = [[self getrDate:frequency] dateByAddingTimeInterval:0];
    [dateFormat setDateFormat:@"EEEE"];
    //NSLog([dateFormat  stringFromDate:startDay]);
    remindDay.text = [dateFormat  stringFromDate:self->reminderDate ];
    
    // NSString *x = [dateFormat stringFromDate:startDay];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    remindDate.text = [dateFormat stringFromDate:reminderDate];
    
    [[NSUserDefaults standardUserDefaults] setObject:reminderDate forKey:@"reminderTimeFinal"];
    
    
    
}



-(NSInteger) determineMedFrequency: (NSString*) mName
{
    if([mName isEqual:@"malarone"]||[mName isEqual:@"doxycycline"])
    {
        //1 = daily
        return 1;
    }
    else
        //0 = weekly
        return 0;
}

-(void) changeLabelColor: (NSDate*) remDate
         givenFrequency : (NSInteger) freq
{
    //rDate is the date when the medicine should be next taken. Implement a function to get the same
    
    NSDate *today = [NSDate date];
    remindDay.textColor = [UIColor blackColor];
    
    //frequency = daily (1)
    
    if([remDate compare:today] == NSOrderedSame);
    //remind
    
    if([remDate compare:today] == NSOrderedDescending);
    {
        //remindDay.textColor = [UIColor redColor];
        //NSLog(@"missed");
    }
    
    if([remDate compare:today] == NSOrderedAscending)
    {
        remindDay.textColor = [UIColor redColor];
       // NSLog(@"missed");
    }
    //do not change
    
    //frequency = weekly (0)
}


-(IBAction)medTakenYES:(id)sender
{
    medTaken = 1;
    //NSLog(@"medTaken",medTaken);
    
    
    self->rDate1 = [self getrDate:frequency];
    [self changeLabelColor:self->reminderDate givenFrequency:self->frequency];
    [self updateLabel:self->reminderDate];
    
    
}

-(IBAction)medTakenNO:(id)sender
{
    self->medTaken = 2;
    
    self->rDate1 = [self getrDate:frequency];
    [self changeLabelColor:self->rDate1 givenFrequency:self->frequency];
    [self updateLabel:self->reminderDate];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSDate*) getrDate: (NSInteger) mfrequency
{
    NSDate *today = [NSDate date];
    
    //&& [rDate compare:today] == NSOrderedDescending
    if(mfrequency == 1 && ([self->reminderDate compare:today] == NSOrderedAscending||[self->reminderDate compare:today]==NSOrderedSame)&&(self->medTaken == 1||self->medTaken == 2))
    {
        //daily
        //get next date
        
        self->reminderDate = [self->reminderDate dateByAddingTimeInterval:+1*24*60*60];
    }
    
    if(mfrequency == 0 && [self->reminderDate compare:today] == NSOrderedAscending)
    {
        //weekly
        //today>=rDate or medicine has been taken
        
        if(self->medTaken == 2)
        {
            //log
            self->reminderDate = [self->reminderDate dateByAddingTimeInterval:+7*24*60*60];
            
        }
        
        
        else if([self->reminderDate compare:today] == NSOrderedDescending||[self->reminderDate compare:today] == NSOrderedSame||self->medTaken==1)
        {
            self->reminderDate = [self->reminderDate dateByAddingTimeInterval:+7*24*60*60];
        }
        
        
        
    }
    
    return self->reminderDate;
}


-(void) todo
{
self.screenNumber.text = [NSString stringWithFormat:@"Screen #%d", self.index];

_background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
_background.frame = self.view.bounds;
[[self view] addSubview:_background];
[_background.superview sendSubviewToBack:_background];

self->frequency = [self determineMedFrequency:medName.lowercaseString];



if(self->frequency == 1)
{
    //daily
    [self updateLabel: self->reminderDate];
    
}

//Function to update label with arguments reminderdate
else
{
    
    [self updateLabel:self->reminderDate];
    
    
    
    [self changeLabelColor:reminderDate givenFrequency:frequency];
}


}



- (void)viewDidAppear:(BOOL)animated

{
    [super viewDidAppear:(BOOL)animated];
    NSLog(@"viewDidAppear");

    [self todo];
   
    
    
}

-(IBAction)settings:(id)sender
{
    TRYSetupScreenViewController *loginVC = [[TRYSetupScreenViewController alloc] init];
    [self.view.window.rootViewController presentViewController:loginVC animated:YES completion:nil];
    
}






- (IBAction)setupScreenAction:(id)sender {
   // TRYAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
   TRYSetupScreenViewController *loginVC = [[TRYSetupScreenViewController alloc] init];
    
    //[appDelegate.window setRootViewController:login];
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
 [self.view.window.rootViewController presentViewController:loginVC animated:YES completion:nil];
    
}
@end
