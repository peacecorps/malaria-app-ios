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
@property (strong, nonatomic) IBOutlet UILabel *labelDay;
@property (strong, nonatomic) IBOutlet UILabel *labelDate;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UIButton *buttonNo;
- (IBAction)medNoAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *buttonYes;
- (IBAction)medYesAction:(id)sender;

@property(strong,nonatomic)NSDate *savedDate;
@property(strong,nonatomic)NSDate *nextReminderDate;
@property(strong,nonatomic)NSUserDefaults *preferences;
@property NSInteger missedCount;
@property NSInteger takenCount;
@property NSInteger notTakenCount;

@end

@implementation TRYHomeViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
}


- (void) viewWillAppear:(BOOL)animated{
    
    [self updation];
    
}



-(void) updation
{
    _preferences = [NSUserDefaults standardUserDefaults];
    BOOL hasSetUp = [_preferences boolForKey:@"hasSetUp"];
    
    
    if(hasSetUp)
    {
        
        
        //Update saved date if required

        //Initially saved Date = date when setup screen was created
         _savedDate = [(NSDate*)[_preferences objectForKey:@"reminderTimeFinal"] dateByAddingTimeInterval:0];
        
        _nextReminderDate =[(NSDate*)[_preferences objectForKey:@"reminderTimeFinal1"] dateByAddingTimeInterval:0];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        
        
        
        //today < saved date => do nothing
      
        NSInteger dateCompare = [self compareDates:[NSDate date] :_savedDate];
        
        if(dateCompare == -1)
        {
            
            [_buttonYes setEnabled:NO];
            [_buttonNo setEnabled:NO];
            [dateFormat setDateFormat:@"dd/MM/yyyy"];
            _labelDate.text = [dateFormat stringFromDate:_savedDate];
            
            
            [dateFormat setDateFormat:@"EEEE"];
            _labelDay.text = [dateFormat stringFromDate:_savedDate];
            
            _nextReminderDate = (NSDate*)[[self getNextReminderDate] dateByAddingTimeInterval:0];
            
            [[NSUserDefaults standardUserDefaults] setObject:_nextReminderDate forKey:@"reminderTimeFinal1"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
        }
       
        else if(dateCompare == 0)
        {
            
            
            _nextReminderDate = (NSDate*)[[self getNextReminderDate] dateByAddingTimeInterval:0];
            
           // _savedDate = (NSDate*)[_nextReminderDate dateByAddingTimeInterval:0];
            
            [[NSUserDefaults standardUserDefaults] setObject:_nextReminderDate forKey:@"reminderTimeFinal1"];
           // [[NSUserDefaults standardUserDefaults] setObject:_savedDate forKey:@"reminderTimeFinal"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [_buttonYes setEnabled:YES];
            [_buttonNo setEnabled:YES];

        }
        
        //today > saved date
       
        
        else
        {
            
            NSInteger dateCompareNext;

            dateCompareNext = [self compareDates:[NSDate date] :_nextReminderDate];
            
            //today < nextDate not possible for weekly
            
            //today > nextDate => missed count = (today - nextDate), nextdate = today, saved date = next date
            if(dateCompareNext == 1)
            {
                _nextReminderDate = [NSDate date];
                
                _savedDate = (NSDate*)[_nextReminderDate dateByAddingTimeInterval:0];
                
                _nextReminderDate = (NSDate*)[[self getNextReminderDate] dateByAddingTimeInterval:0];
                
                [[NSUserDefaults standardUserDefaults] setObject:_nextReminderDate forKey:@"reminderTimeFinal1"];
                [[NSUserDefaults standardUserDefaults] setObject:_savedDate forKey:@"reminderTimeFinal"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
            }
            
            else if(dateCompareNext == 0)
            {
                
                _savedDate = (NSDate*)[_nextReminderDate dateByAddingTimeInterval:0];
                
                _nextReminderDate = (NSDate*)[[self getNextReminderDate] dateByAddingTimeInterval:0];
                
                [[NSUserDefaults standardUserDefaults] setObject:_nextReminderDate forKey:@"reminderTimeFinal1"];
                [[NSUserDefaults standardUserDefaults] setObject:_savedDate forKey:@"reminderTimeFinal"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
            
            
        }
        //today == saved date => alarm
        
       
        
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        
        
        _labelDate.text = [dateFormat stringFromDate:_savedDate];
        
        
        [dateFormat setDateFormat:@"EEEE"];
        _labelDay.text = [dateFormat stringFromDate:_savedDate];
        
        [[NSUserDefaults standardUserDefaults] setObject:_savedDate forKey:@"reminderTimeFinal"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //get next date
        
       
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        
       
      
    }
}


-(NSInteger) compareDates:(NSDate*)date1
                         :(NSDate*)date2
{
    
    //date1<date2 = -1 ; date1 == date2 = 0 ; date1 > date2 = 1
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date1];
    
    NSInteger day1 = [components1 day];
    NSInteger month1 = [components1 month];
    NSInteger year1 = [components1 year];
    
    
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date2];
    
    NSInteger day2 = [components2 day];
    NSInteger month2 = [components2 month];
    NSInteger year2 = [components2 year];
    
    if(year1 < year2)
    
        return -1;
        
    else if(year1 > year2)
            return 1;
        
            else
            {
                //year1 = year2
                
                if(month1 < month2)
                    return -1;
                
                else if(month1 > month2)
                        return 1;
                
                else
                {
                    //year1 = year2 && month1 = month2
                    
                    if(day1 < day2)
                        return -1;
                    
                    else if(day1 > day2)
                        return 1;
                    
                    else
                        
                        return 0;
                }
            }
    
    
    return 0;
    
    
}

-(NSDate*)getNextReminderDate
{
   // NSLog(@"shruti");
    _nextReminderDate= [(NSDate*)[_preferences objectForKey:@"reminderTimeFinal1"] dateByAddingTimeInterval:0];
    
    
    _nextReminderDate = [_nextReminderDate dateByAddingTimeInterval:+1*24*60*60];
    
    [[NSUserDefaults standardUserDefaults] setObject:_nextReminderDate forKey:@"reminderTimeFinal1"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return _nextReminderDate ;
}

- (IBAction)setupScreenAction:(id)sender {
   // TRYAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
   TRYSetupScreenViewController *loginVC = [[TRYSetupScreenViewController alloc] init];
    
    //[appDelegate.window setRootViewController:login];
    //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
 [self.view.window.rootViewController presentViewController:loginVC animated:YES completion:nil];
    
}
- (IBAction)medNoAction:(id)sender {
    
   // _nextReminderDate = (NSDate*)[[self getNextReminderDate] dateByAddingTimeInterval:0];
    //[[NSUserDefaults standardUserDefaults] setObject:_nextReminderDate forKey:@"reminderTimeFinal1"];
    //_savedDate = (NSDate*)[_nextReminderDate dateByAddingTimeInterval:0];
    //[[NSUserDefaults standardUserDefaults] setObject:_savedDate forKey:@"reminderTimeFinal"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [self updation];
    

}



- (IBAction)medYesAction:(id)sender {
    
   // NSLog(@"shruti");
   /* _nextReminderDate = (NSDate*)[[self getNextReminderDate] dateByAddingTimeInterval:0];
    [[NSUserDefaults standardUserDefaults] setObject:_nextReminderDate forKey:@"reminderTimeFinal1"];
    _savedDate = (NSDate*)[_nextReminderDate dateByAddingTimeInterval:0];
    [[NSUserDefaults standardUserDefaults] setObject:_savedDate forKey:@"reminderTimeFinal"];
    [[NSUserDefaults standardUserDefaults] synchronize];*/
    _savedDate = _nextReminderDate;
    [[NSUserDefaults standardUserDefaults] setObject:_savedDate forKey:@"reminderTimeFinal"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    [self updation];
    
    
    
}
@end
