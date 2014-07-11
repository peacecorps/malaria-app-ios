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

//medTaken = 0 no action = 1 taken = 2 not taken
NSInteger medTaken ;
NSInteger frequency;

NSString *medName;
}
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UILabel *screenNumber;


@end
