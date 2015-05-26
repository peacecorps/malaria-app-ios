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
}
@property (strong, nonatomic) IBOutlet UILabel *labelDay;
-(void)updation;
-(NSInteger) compareDates:(NSDate*)date1
                         :(NSDate*)date2;


@end
