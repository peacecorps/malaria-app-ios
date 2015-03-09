//
//  TRYModel.m
//  LoginTabbedApp
//
//  Created by shruti gupta on 06/08/14.
//  Copyright (c) 2014 Shruti Gupta. All rights reserved.
//

#import "TRYModel.h"
NSString *const medDate = @"medDate";
NSString *const medStatus = @"medStatus";


@implementation TRYModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.medDate forKey:medDate];
    [aCoder encodeInteger:self.medStatus forKey:medStatus];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _medDate = [aDecoder decodeObjectForKey:medDate];
        _medStatus = [aDecoder decodeIntForKey:medStatus];
        
          }
    return self;
}
- (instancetype)init
{
    return [self initWithDate:[NSDate date]];
}
- (instancetype)initWithDate:(NSDate *)date
{
    return [self initWithDate:date
                       status:0
                         ];
}

- (instancetype)initWithDate:(NSDate *)medDate
                      status:(int)medStatus

{
     self = [super init];
    
    if (self) {
       
        _medDate = medDate;
        _medStatus = medStatus;
       
        
}
    return self;
}


+(instancetype)randomItem:(NSDate *)medDate
{
    
    TRYModel *newItem = [[TRYModel alloc] initWithDate:medDate
                                            status: 2
                                      ];
    return newItem;
}

- (void)setMedDate:(NSDate *) date
{
    _medDate = date;
}
- (NSDate *)getMedDate
{
    return _medDate;
}

- (void)setMedStatus:(int)status
{
    _medStatus = status;
}

- (int )getMedStatus
{
    return _medStatus;
}



@end
