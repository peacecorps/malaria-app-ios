//
//  TRYHomeViewController.m
//  LoginTabbedApp
//
//  Created by shruti gupta on 24/06/14.
//  Copyright (c) 2014 Shruti Gupta. All rights reserved.
//

#import "TRYHomeViewController.h"
#import "TRYSetupScreenViewController.h"

@interface TRYHomeViewController ()
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
@property NSInteger flag;
@property NSTimer *timer;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UILabel *screenNumber;

@end

@implementation TRYHomeViewController

NSString *const prefReminderTime1 = @"reminderTimeFinal";
NSString *const prefReminderTime2 = @"reminderTimeFinal1";
NSString *const prefmedLastTaken = @"medLastTaken";
NSString *const prefhasSetUp = @"hasSetUp";
NSString *const prefDosesInARow = @"dosesInARow";
NSInteger medTaken ;
NSInteger frequency;
//medTaken = 0 no action = 1 taken = 2 not taken
NSString *medName;
NSInteger dosesInARow=0;
bool visited = false;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _flag =0;
    
    
        }


- (void) viewWillAppear:(BOOL)animated{
     [self updation];
  
}




-(void) updation
{
    _preferences = [NSUserDefaults standardUserDefaults];
    BOOL hasSetUp = [_preferences boolForKey:prefhasSetUp];
    
    
    if(hasSetUp)
    {
        
        
        //Update saved date if required

        //Initially saved Date = date when setup screen was created
         _savedDate = [(NSDate*)[_preferences objectForKey:prefReminderTime1] dateByAddingTimeInterval:0];
        
        _nextReminderDate =[(NSDate*)[_preferences objectForKey:prefReminderTime2] dateByAddingTimeInterval:0];
        
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
            [[NSUserDefaults standardUserDefaults] setObject:_nextReminderDate forKey:prefReminderTime2];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
        }
        //if today == saved date
       
        else if(dateCompare == 0)
        {
            [_buttonYes setEnabled:YES];
            [_buttonNo setEnabled:YES];
            
            if(_flag == 0 && !visited)
            {
                visited = true;
            _nextReminderDate = (NSDate*)[[self getNextReminderDate] dateByAddingTimeInterval:0];
            [[NSUserDefaults standardUserDefaults] setObject:_nextReminderDate forKey:prefReminderTime2];
            [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
            else if(_flag==1 )
                _flag=0;
        }
        
        //today > saved date
       
        
        else
        {
            
            NSInteger dateCompareNext;

            dateCompareNext = [self compareDates:[NSDate date] :_nextReminderDate];
            
            //today < nextDate not possible for daily
            
            //today > nextDate => missed count = (today - nextDate), nextdate = today, saved date = next date
            if(dateCompareNext == 1)
            {
                visited = false;
                dosesInARow = (NSInteger)[[NSUserDefaults standardUserDefaults] valueForKey:prefDosesInARow];
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:prefDosesInARow];
                
                _flag = 1;
                _nextReminderDate = [NSDate date];
                
                [[NSUserDefaults standardUserDefaults] setObject:_nextReminderDate forKey:prefReminderTime2];
                
                _savedDate = (NSDate*)[_nextReminderDate dateByAddingTimeInterval:0];
                
                _nextReminderDate = (NSDate*)[[self getNextReminderDate] dateByAddingTimeInterval:0];
                
                [[NSUserDefaults standardUserDefaults] setObject:_nextReminderDate forKey:prefReminderTime2];
                [[NSUserDefaults standardUserDefaults] setObject:_savedDate forKey:prefReminderTime1];
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:prefDosesInARow];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
            }
            
            else if(dateCompareNext == 0)
            {
                [_buttonYes setEnabled:YES];
                [_buttonNo setEnabled:YES];
                
                //_savedDate = (NSDate*)[_nextReminderDate dateByAddingTimeInterval:0];
                
                //_nextReminderDate = (NSDate*)[[self getNextReminderDate] dateByAddingTimeInterval:0];
                
                [[NSUserDefaults standardUserDefaults] setObject:_nextReminderDate forKey:prefReminderTime2];
                [[NSUserDefaults standardUserDefaults] setObject:_savedDate forKey:prefReminderTime1];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
            
            
        }
        //today == saved date => alarm
        [dateFormat setDateFormat:@"dd/MM/yyyy"];
        
        
        _labelDate.text = [dateFormat stringFromDate:_savedDate];
        
        
        [dateFormat setDateFormat:@"EEEE"];
        _labelDay.text = [dateFormat stringFromDate:_savedDate];
        
        [[NSUserDefaults standardUserDefaults] setObject:_savedDate forKey:prefReminderTime1];
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
  
    _nextReminderDate= [(NSDate*)[_preferences objectForKey:prefReminderTime2] dateByAddingTimeInterval:0];
    _nextReminderDate = [_nextReminderDate dateByAddingTimeInterval:+1*24*60*60];
    [[NSUserDefaults standardUserDefaults] setObject:_nextReminderDate forKey:prefReminderTime2];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return _nextReminderDate ;
}

- (IBAction)setupScreenAction:(id)sender {
  
    TRYSetupScreenViewController *loginVC = [[TRYSetupScreenViewController alloc] init];
    [self.view.window.rootViewController presentViewController:loginVC animated:YES completion:nil];
    
}
- (IBAction)medNoAction:(id)sender {
    [self updation];
    dosesInARow = (NSInteger)[[NSUserDefaults standardUserDefaults] valueForKey:prefDosesInARow];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:prefDosesInARow];
    
  }
- (IBAction)medYesAction:(id)sender {
    
    visited = false;
    dosesInARow = (NSInteger)[[NSUserDefaults standardUserDefaults] valueForKey:prefDosesInARow];
    dosesInARow+=1;
    [[NSUserDefaults standardUserDefaults] setInteger:dosesInARow forKey:prefDosesInARow];
    
    _savedDate = _nextReminderDate;
    [[NSUserDefaults standardUserDefaults] setObject:_savedDate forKey:prefReminderTime1];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:prefmedLastTaken];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    
    
    _labelDate.text = [dateFormat stringFromDate:_savedDate];
    
    
    [dateFormat setDateFormat:@"EEEE"];
    _labelDay.text = [dateFormat stringFromDate:_savedDate];
    
    
    
    NSDate *currentTime = (NSDate*)[[NSUserDefaults standardUserDefaults] valueForKey:@"reminderTime"];
    currentTime = [currentTime dateByAddingTimeInterval:+1*24*60*60];
    
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = currentTime;
    localNotification.alertBody = @"Time to take your medicine";
    localNotification.alertAction = @"Show me the item";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
     [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    [[NSUserDefaults standardUserDefaults] setObject:currentTime forKey:@"remiderTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_buttonYes setEnabled:NO];
    [_buttonNo setEnabled:NO];
    
    
    
}
@end
