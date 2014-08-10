//
//  TRYModel.h
//  LoginTabbedApp
//
//  Created by shruti gupta on 06/08/14.
//  Copyright (c) 2014 Shruti Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRYModel : NSObject <NSCoding>

@property (nonatomic) NSDate *medDate;
@property (nonatomic) bool takeMed;
//(takeMed == true) => (medStatus = 1 taken, medStatus = -1 not taken, medStatus = 0 missed)
@property (nonatomic) int medStatus;


- (instancetype)initWithDate:(NSDate *)date;
- (instancetype)initWithDate:(NSDate *)medDate
                      status:(int)medStatus
                takeMedicine:(bool)takeMedicine;
+ (instancetype)randomItem:(NSDate *)medDate;
- (void)setMedDate:(NSDate *) date;
- (NSDate *)getMedDate;
- (void)setMedStatus:(int)status;
- (int )getMedStatus;
- (void)setTakeMed:(bool)takeMed;
- (BOOL)getTakeMed;





@end
