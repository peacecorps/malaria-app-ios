//
//  TRYSetupScreenViewController.h
//  LoginTabbedApp
//
//  Created by shruti gupta on 27/06/14.
//  Copyright (c) 2014 Shruti Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRYSetupScreenViewController : UIViewController
{
    NSArray *medicines;
    UIDatePicker *datePicker;
    NSDate *currentTime;
    NSString *medName;
    NSUserDefaults *prefs;
    NSDate *startDay;
    
}

@end
