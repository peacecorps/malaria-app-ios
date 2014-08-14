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
NSString *const takeMed = @"takeMed";

@implementation TRYModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.medDate forKey:medDate];
    [aCoder encodeInteger:self.medStatus forKey:medStatus];
    [aCoder encodeBool:self.takeMed forKey:takeMed];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _medDate = [aDecoder decodeObjectForKey:medDate];
        _medStatus = [aDecoder decodeIntForKey:medStatus];
        _takeMed = [aDecoder decodeBoolForKey:takeMed];
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
                         takeMedicine:false];
}

- (instancetype)initWithDate:(NSDate *)medDate
                      status:(int)medStatus
                takeMedicine:(bool)takeMedicine
{
     self = [super init];
    
    // Did the superclass's designated initializer succeed?
    if (self) {
        // Give the instance variables initial values
        _medDate = medDate;
        _medStatus = medStatus;
        _takeMed = takeMedicine;
        
}
    return self;
}


+(instancetype)randomItem:(NSDate *)medDate
{
    
    TRYModel *newItem = [[TRYModel alloc] initWithDate:medDate
                                            status: 2
                                      takeMedicine: true];
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

- (void)setTakeMed:(bool)takeMed
{
    _takeMed = takeMed;
}

- (BOOL)getTakeMed
{
    return _takeMed;
}


@end
