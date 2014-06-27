//
//  TRYSetupScreenViewController.m
//  LoginTabbedApp
//
//  Created by shruti gupta on 27/06/14.
//  Copyright (c) 2014 Shruti Gupta. All rights reserved.
//

#import "TRYSetupScreenViewController.h"
#define kOFFSET_FOR_KEYBOARD 80.0

@interface TRYSetupScreenViewController ()
@property (strong, nonatomic) IBOutlet UILabel *setUp;
@property (strong, nonatomic) IBOutlet UILabel *iTake;
@property (strong, nonatomic) IBOutlet UILabel *remindAt;
@property (strong, nonatomic) IBOutlet UILabel *ifForgot;
@property (strong, nonatomic) IBOutlet UITextField *txt;
@property (strong, nonatomic) IBOutlet UITextField *time;
@property (strong, nonatomic) IBOutlet UILabel *medWarning;
@property (strong, nonatomic) IBOutlet UILabel *timeWarning;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UIView *collect;
@property (strong, nonatomic) IBOutlet UIButton *done;
- (IBAction)doneButtonAction:(id)sender;


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
    
    //Setting the background using an image view
    
    _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    _background.frame = self.view.bounds;
    [[self view] addSubview:_background];
    [_background.superview sendSubviewToBack:_background];
    
    //Setting the background of the view that has all the labels, and textfields
    
    _collect.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    //Getting the details entered by the user: medicine Name, and setUp time, saved in NSUserDefaults
    
    
    self->prefs = [NSUserDefaults standardUserDefaults];
    self->medName = [prefs stringForKey:@"medicineName"];
    self->startDay = [prefs objectForKey:@"startDay"];
    
    //If the user has already filled in the details, they are populated in the textfields
    
    if(![self->medName isEqualToString:@""]&& self->startDay)
    {
        //Text field with medicine
        _txt.text = self->medName;
        
        //Text fiels with time
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        NSString *currentTimeString = [dateFormatter stringFromDate:self->startDay];
        _time.text = currentTimeString;
        [_done setEnabled:YES];
    }
    
    
    
    
    
    
    
    
    //Code for the medicines Picker
    
    medicines = [NSArray arrayWithObjects:@"Doxycycline",@"Malarone",@"Mefloquine", nil];
    UIPickerView *medPicker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    medPicker.delegate = self;
    medPicker.dataSource = self;
    [medPicker setShowsSelectionIndicator:YES];
    _txt.inputView = medPicker;
    
    
    //Create done button in UIPickerView
    
    UIToolbar* myPickerToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 56)];
    myPickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [myPickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    [barItems addObject:doneBtn];
    
    [myPickerToolbar setItems:barItems animated:YES];
    _txt.inputAccessoryView = myPickerToolbar;
    
    
    //Code for the date picker
    
    self->datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    self->datePicker.datePickerMode = UIDatePickerModeTime;
    _time.inputView = datePicker;
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    //[self.view addSubview:time];
    
    //Done Button in Date Picker
    
    UIToolbar* myDatePickerToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 56)];
    myDatePickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    [myDatePickerToolbar sizeToFit];
    NSMutableArray *barItems1 = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems1 addObject:flexSpace1];
    UIBarButtonItem *doneBtn1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(datePickerDoneClicked)];
    [barItems1 addObject:doneBtn1];
    
    [myDatePickerToolbar setItems:barItems1 animated:YES];
    _time.inputAccessoryView = myDatePickerToolbar;
    
    

}

//Method to get the date selected on the date picker

- (void)dateChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    self->currentTime = self->datePicker.date;
    NSString *currentTimeString = [dateFormatter stringFromDate:currentTime];
    _time.text = currentTimeString;
    
}

//Done Button Function for medicine picker

-(void)pickerDoneClicked
{
    //If the medicine is not entered, warning label is highlighted
    if([_txt.text  isEqual: @""])
    {
        NSLog(@"No medication entered");
        [_medWarning setHidden:NO];
        [_medWarning setText:@"Medication not entered"];
    }
    
    
    BOOL isMedThere = [medicines containsObject: _txt.text];
    
    
    //If a wrong medication is entered, warning label is highlighted
    if(![_txt.text isEqualToString:@""] && !isMedThere )
    {
        [_medWarning setHidden:NO];
        [_medWarning setText:@"Wrong Medication entered"];
        
        
    }
    
    
    isMedThere = [medicines containsObject: _txt.text];
    
    
    //Medicine entered is not empty string, and is also present in the array
    if(![_txt.text isEqualToString:@""] && isMedThere )
    {
        [_medWarning setHidden:YES];
        
    }
    
    
    isMedThere = [medicines containsObject: _txt.text];
    
    //If both the text fields are filled with non-nil correct values, done button is enabled
    if(![_txt.text isEqualToString:@""] && ![_time.text isEqualToString:@""] && isMedThere)
    {
        [_done setEnabled:YES];
    }
    
    [_txt resignFirstResponder];
    
    
}



-(void)datePickerDoneClicked
{
    NSLog(@"Done Clicked");
    
    
    
    
    if([_time.text isEqual: @""])
    {
        
        
        
        [_timeWarning setHidden:NO];
        [_timeWarning setText:@"Continuing with current time"];
        
        
        self->currentTime = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"hh:mm";
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [_time setText:[dateFormatter stringFromDate:self->currentTime]];
        
        
    }
    [_time resignFirstResponder];
    
    if(![_txt.text isEqualToString:@""] && ![_time.text isEqualToString:@""])
    {
        //[timeWarning setHidden:YES];
        [_done setEnabled:YES];
        //[timeWarning setHidden:YES];
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
    _txt.text = (NSString*)[medicines objectAtIndex:row];
    
}

-(IBAction)doneButtonAction:(id)sender
{
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE"];
    
    NSString *medicine = _txt.text;
    NSString *remindTime = _time.text;
    self->startDay = [date dateByAddingTimeInterval:0];
    [[NSUserDefaults standardUserDefaults] setObject:medicine forKey:@"medicineName"];
    [[NSUserDefaults standardUserDefaults] setObject:remindTime forKey:@"reminderTime"];
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"startDay"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSUserDefaults standardUserDefaults] setBool:YES  forKey:@"hasSetUp"];
    
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
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
    
    //Set the background image
    
    //[super viewDidLoad];
    NSLog(@"Inside view DidAppear");
    
    _background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    _background.frame = self.view.bounds;
    [[self view] addSubview:_background];
    [_background.superview sendSubviewToBack:_background];
    
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //self->medName = [self->prefs stringForKey:@"medicineName"];
    //NSDate *startDay = [self->prefs objectForKey:@"startDay"];
    NSLog(@"shruti");
    NSLog(self->medName);
    if(![self->medName isEqualToString:@""])
    {
        NSLog(@"Inside if statement");
        _txt.text = self->medName;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm a"];
        NSString *currentTimeString = [dateFormatter stringFromDate:self->startDay];
        
        _time.text = currentTimeString;
        [_done setEnabled:YES];
    }
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

/*- (IBAction)doneButtonAction:(id)sender:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    

}*/
@end
