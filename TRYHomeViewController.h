//
//  TRYHomeViewController.h
//  LoginTabbedApp
//
//  Created by shruti gupta on 24/06/14.
//  Copyright (c) 2014 Shruti Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRYHomeViewController : UIViewController
{
IBOutlet UIButton *medYes;
IBOutlet UIButton *medNo;
IBOutlet UILabel *remindDay;
IBOutlet UILabel *remindDate;
IBOutlet UILabel *medicineName;
//medTaken = 0 no action = 1 taken = 2 not taken
NSInteger medTaken ;
NSInteger frequency;
NSDate *rDate;
NSDate *rDate1;
NSDate *reminderDate;
NSString *medName;
}

-(NSInteger) determineMedFrequency:(NSString*) mName;
-(void) changeLabelColor:(NSDate*) rDate
          givenFrequency:(NSInteger) frequency;

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UILabel *screenNumber;


@end
