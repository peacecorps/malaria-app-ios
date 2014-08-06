//
//  TRYModel.h
//  LoginTabbedApp
//
//  Created by shruti gupta on 06/08/14.
//  Copyright (c) 2014 Shruti Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRYModel : NS

@property (nonatomic) NSDate *medDate;
@property (nonatomic) bool takeMed;
//(takeMed == true) => (medStatus = 1 taken, medStatus = -1 not taken, medStatus = 0 missed)
@property (nonatomic) int medStatus;


@end
