//
//  TRYItemStore.m
//  LoginTabbedApp
//
//  Created by shruti gupta on 06/08/14.
//  Copyright (c) 2014 Shruti Gupta. All rights reserved.
//

#import "TRYItemStore.h"
#import "TRYModel.h"
#import "TRYHomeViewController.h"
@interface TRYItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@end

@implementation TRYItemStore


- (NSString *)itemArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL)saveChanges
{
    NSString *path = [self itemArchivePath];
    
    // Returns YES on success
    return [NSKeyedArchiver archiveRootObject:self.privateItems
                                       toFile:path];
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _privateItems = [[NSMutableArray alloc] init];
        
        NSString *path = [self itemArchivePath];
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If the array hadn't been saved previously, create a new empty one
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (NSArray *)allItems
{
    return self.privateItems;
}

- (TRYModel*)createItem:(NSDate *) medDate
                        
{
    //TO-DO: First check if the data is already saved, if not then add it, else update the existing value
    
    //Check if data is already there:
    TRYHomeViewController *home = [[TRYHomeViewController alloc]init];
    for(TRYModel *item in self.privateItems)
    {
        if([home compareDates:medDate :item.medDate] == 0 )
            return item;
    }
    TRYModel *item = [TRYModel randomItem:medDate];
    [self.privateItems addObject:item];
    return item;
}

+ (instancetype)sharedStore
{
    static TRYItemStore *sharedStore = nil;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[TRYItemStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

    

@end
