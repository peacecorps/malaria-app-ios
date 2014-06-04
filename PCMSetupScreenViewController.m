//
//  PCMSetupScreenViewController.m
//  MalariaiOSApp
//
//  Created by shruti gupta on 04/06/14.
//  Copyright (c) 2014 Shruti Gupta. All rights reserved.
//

#import "PCMSetupScreenViewController.h"

@interface PCMSetupScreenViewController ()

@end

@implementation PCMSetupScreenViewController


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
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];

    // Do any additional setup after loading the view from its nib.
    medicines = [NSArray arrayWithObjects:@"Doxycycline",@"Malarone",@"Mefloquine", nil];
    UIPickerView *medPicker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    medPicker.delegate = self;
    medPicker.dataSource = self;
    [medPicker setShowsSelectionIndicator:YES];
    txt.inputView = medPicker;
    
    
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
    txt.inputAccessoryView = myPickerToolbar;
    
    
    self->datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    // self->datePicker.frame = CGRectMake(0, 0, self.view.frame.size.width, 180.0f); // set frame as your need
    self->datePicker.datePickerMode = UIDatePickerModeTime;
    //[self.view addSubview: self->datePicker];
    time.inputView = datePicker;
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    
    //UILabel  * label1 = [[UILabel alloc] initWithFrame:CGRectMake(40, 70, 300, 50)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *currentTime = [dateFormatter stringFromDate:self->datePicker.date];
    // time.text = currentTime;
    [self.view addSubview:time];
    
    
    UIToolbar* myDatePickerToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 56)];
    myDatePickerToolbar.barStyle = UIBarStyleBlackTranslucent;
    [myDatePickerToolbar sizeToFit];
    NSMutableArray *barItems1 = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems1 addObject:flexSpace1];
    UIBarButtonItem *doneBtn1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(datePickerDoneClicked)];
    [barItems1 addObject:doneBtn1];
    
    [myDatePickerToolbar setItems:barItems1 animated:YES];
    time.inputAccessoryView = myDatePickerToolbar;
    
    
}

- (void)dateChanged:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *currentTime = [dateFormatter stringFromDate:self->datePicker.date];
    NSLog(@"%@", currentTime);
    
    time.text = currentTime;
    
    
    //[self->datePicker setHidden:YES];
    
}


-(void)pickerDoneClicked
{
    NSLog(@"Done Clicked");
    [txt resignFirstResponder];
}

-(void)datePickerDoneClicked
{
    NSLog(@"Done Clicked");
    [time resignFirstResponder];
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
    txt.text = (NSString*)[medicines objectAtIndex:row];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)done:(id)sender
{
    
    
    if([time.text isEqual: @""])
    {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time Not Entered"
                                                        message:@"Continuing with current time"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        NSDate *now = [NSDate date];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"hh:mm";
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
        [time setText:[dateFormatter stringFromDate:now]];
    }
    
    
    if([txt.text  isEqual: @""])
    {
        NSLog(@"No medication entered");
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Medication Not Entered"
                                                        message:@"You must select a medication to continue"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
    else{
        [time setText:@"shruti"];
        [nextScreen setHidden:NO];
        [txt setHidden:YES];
        [time setHidden:YES];
        [iTake setHidden:YES];
        [remind setHidden:YES];
        [ifIFor setHidden:YES];
        [setup setHidden:YES];
        [done setHidden:YES];
    }
}
@end
