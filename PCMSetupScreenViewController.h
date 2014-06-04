//
//  PCMSetupScreenViewController.h
//  MalariaiOSApp
//
//  Created by shruti gupta on 04/06/14.
//  Copyright (c) 2014 Shruti Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCMSetupScreenViewController : UIViewController
{
    IBOutlet UITextField *txt;
    NSArray *medicines;
    IBOutlet UITextField *time;
    IBOutlet UIButton *done;
    UIDatePicker *datePicker;
    IBOutlet UILabel *nextScreen;
    IBOutlet UILabel *iTake;
    IBOutlet UILabel *ifIFor;
    IBOutlet UILabel *remind;
    IBOutlet UILabel *setup;
    
}

@end
