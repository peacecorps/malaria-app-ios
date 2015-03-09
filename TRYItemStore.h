//
//  TRYItemStore.h
//  LoginTabbedApp
//
//  Created by shruti gupta on 06/08/14.
//  Copyright (c) 2014 Shruti Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRYModel.h"

@interface TRYItemStore : NSObject
+ (instancetype)sharedStore;
- (BOOL)saveChanges;
- (TRYModel*)createItem:(NSDate*) medDate;
- (NSArray *)allItems;

@end
