//
//  TRYSetupScreenViewController.m
//  LoginTabbedApp
//
//  Created by shruti gupta on 27/06/14.
//  Copyright (c) 2014 Shruti Gupta. All rights reserved.
//

#import "TRYSetupScreenViewController.h"
#import "TRYModel.h"
#import "TRYItemStore.h"
#define kOFFSET_FOR_KEYBOARD 80.0

@interface TRYSetupScreenViewController ()
@property (strong, nonatomic) IBOutlet UILabel *setUp;
@property (strong, nonatomic) IBOutlet UILabel *iTake;
@property (strong, nonatomic) IBOutlet UILabel *remindAt;
@property (strong, nonatomic) IBOutlet UILabel *ifForgot;
@property (strong, nonatomic) IBOutlet UITextField *medField;
@property (strong, nonatomic) IBOutlet UITextField *timeField;
@property (strong, nonatomic) IBOutlet UILabel *medWarning;
@property (strong, nonatomic) IBOutlet UILabel *timeWarning;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UIView *collect;
@property (strong, nonatomic) IBOutlet UIButton *done;
- (IBAction)doneButtonAction:(id)sender;

@end

@implementation TRYSetupScreenViewController
NSString *const prefReminderTimeSetup = @"reminderTimeFinal";
NSString *const prefReminderTimeSetup2 = @"reminderTimeFinal1";
NSArray *medicines;
UIDatePicker *datePicker;
NSDate *currentTime;
NSString *medName;
NSUserDefaults *prefs;
NSDate *startDay;
TRYModel *xyz;



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
    _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    _background.frame = self.view.bounds;
    [[self view] addSubview:_background];
    [_background.superview sendSubviewToBack:_background];
    
    
    _collect.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    prefs = [NSUserDefaults standardUserDefaults];
    medName = [prefs stringForKey:@"medicineName"];
    startDay = [prefs objectForKey:@"startDay"];
    
    
    if(![medName isEqualToString:@""]&& startDay)
    {
        [_medField setText:medName];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        NSString *currentTimeString = [dateFormatter stringFromDate:startDay];
        [_timeField setText:currentTimeString];
        [_done setEnabled:YES];
    }
  
    //Code for the medicines Picker
    
    medicines = [NSArray arrayWithObjects:@"Doxycycline",@"Malarone",@"Mefloquine", nil];
    UIPickerView *medPicker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    [medPicker setDelegate:self];
    [medPicker setDataSource:self];
    [medPicker setShowsSelectionIndicator:YES];
    [_medField setInputView:medPicker];
    
    
    //Create done button in UIPickerView
    
    UIToolbar* myPickerToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 56)];
    [myPickerToolbar setBarStyle:UIBarStyleBlackOpaque];
    [myPickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    [barItems addObject:doneBtn];
    
    [myPickerToolbar setItems:barItems animated:YES];
    [_medField setInputAccessoryView:myPickerToolbar];
    
    
    //Code for the date picker
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    [datePicker setDatePickerMode:UIDatePickerModeTime];
    [_timeField setInputView:datePicker];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    //[self.view addSubview:time];
    
    //Done Button in Date Picker
    
    UIToolbar* myDatePickerToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 56)];
    [myDatePickerToolbar setBarStyle:UIBarStyleBlackTranslucent];
    [myDatePickerToolbar sizeToFit];
    NSMutableArray *barItems1 = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems1 addObject:flexSpace1];
    UIBarButtonItem *doneBtn1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(datePickerDoneClicked)];
    [barItems1 addObject:doneBtn1];
    
    [myDatePickerToolbar setItems:barItems1 animated:YES];
    [_timeField setInputAccessoryView:myDatePickerToolbar];
  }


- (void)dateChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    currentTime = datePicker.date;
    NSString *currentTimeString = [dateFormatter stringFromDate:currentTime];
    [_timeField setText:currentTimeString];
}


-(void)pickerDoneClicked
{
    if([_medField.text  isEqual: @""])
    {
        [_medWarning setHidden:NO];
        [_medWarning setText:@"Medication not entered"];
        [_medField setText:@"Doxycycline"];
    }
    
    
    BOOL isMedThere = [medicines containsObject: _medField.text];
    if(![_medField.text isEqualToString:@""] && !isMedThere )
    {
        [_medWarning setHidden:NO];
        [_medWarning setText:@"Wrong Medication entered"];
      }
    isMedThere = [medicines containsObject: _medField.text];
    if(![_medField.text isEqualToString:@""] && isMedThere )
    {
        [_medWarning setHidden:YES];
        
    }
     isMedThere = [medicines containsObject: _medField.text];
    
    if(![_medField.text isEqualToString:@""] && ![_timeField.text isEqualToString:@""] && isMedThere)
    {
        [_done setEnabled:YES];
    }
    
    [_medField resignFirstResponder];
    
    
}
-(void)datePickerDoneClicked
{
    if([_timeField.text isEqual: @""])
    {
        [_timeWarning setHidden:NO];
        [_timeWarning setText:@"Continuing with current time"];
        
        
        currentTime = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [_timeField setText:[dateFormatter stringFromDate:currentTime]];
        
        
    }
    [_timeField resignFirstResponder];
    
    if(![_medField.text isEqualToString:@""] && ![_timeField.text isEqualToString:@""])
    {
        [_done setEnabled:YES];
    }
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return medicines.count;
}

-(NSString*)pickerView: (UIPickerView*) pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [medicines objectAtIndex:row];
}

-(void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_medField setText:(NSString*)[medicines objectAtIndex:row]] ;
    
}

-(IBAction)doneButtonAction:(id)sender
{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE"];
    
    NSString *medicine = _medField.text;
   
     [[NSUserDefaults standardUserDefaults] setObject:medicine forKey:@"medicineName"];
  //Store reminder time only once
    if(![prefs boolForKey:@"hasSetUp"])
    {
    startDay = [date dateByAddingTimeInterval:0];
    [[NSUserDefaults standardUserDefaults] setObject:currentTime forKey:@"reminderTime"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:prefReminderTimeSetup];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:prefReminderTimeSetup2];
    [[NSUserDefaults standardUserDefaults] setObject:startDay forKey:@"startDay"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"dosesInARow"];
    [[NSUserDefaults standardUserDefaults] setInteger:[self determineMedFrequency] forKey:@"medFrequency"];
        
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = currentTime;
        localNotification.alertBody = @"Time to take your medicine";
        localNotification.alertAction = @"Show me the item";
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES  forKey:@"hasSetUp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}
-(NSInteger) determineMedFrequency
{
    NSString *mName = (NSString*)[prefs stringForKey:@"medicineName"];
    mName = mName.lowercaseString;
    if([mName isEqual:@"malarone"]||[mName isEqual:@"doxycycline"])
    {
        //1 = daily
        return 1;
    }
    else
        //7 = weekly
        return 7;
}


-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}


//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                    object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    _background.frame = self.view.bounds;
    [[self view] addSubview:_background];
    [_background.superview sendSubviewToBack:_background];
    
    if(![medName isEqualToString:@""]&& startDay)
    {
       
        _medField.text = medName;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        NSString *currentTimeString = [dateFormatter stringFromDate:startDay];
        _timeField.text = currentTimeString;

        [_done setEnabled:YES];
    }
}



@end
