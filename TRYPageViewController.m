///
//  TRYPageViewController.m
//  LoginTabbedApp
//
//  Created by shruti gupta on 25/06/14.
//  Copyright (c) 2014 Shruti Gupta. All rights reserved.
//

#import "TRYPageViewController.h"
#import "TRYHomeViewController.h"
#import "TRYAnalyticsIViewController.h"
#import "TRYAnalyticsScreenIIViewController.h"

@interface TRYPageViewController () <UIPageViewControllerDataSource>
@property (nonatomic) NSUInteger pageIndex;

@end

@implementation TRYPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        TRYHomeViewController *initialViewController = [[TRYHomeViewController alloc] init];
        TRYAnalyticsIViewController *vc2 = [[TRYAnalyticsIViewController alloc ]init];
        TRYAnalyticsScreenIIViewController *vc3 = [[TRYAnalyticsScreenIIViewController alloc ]init];
        self.pageViewControllers = @[initialViewController, vc2, vc3];
        self.pageIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
      self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    
    self.pageController.dataSource = self;
    NSArray *viewControllers = @[self.pageViewControllers[0]];
    [self.pageController setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    for (UIView *subview in self.pageController.view.subviews) {
        if ([subview isKindOfClass:[UIPageControl class]]) {
            UIPageControl *pageControl = (UIPageControl *)subview;
            pageControl.pageIndicatorTintColor = [UIColor blackColor];
            pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
            pageControl.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.0f];
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    self.pageIndex = [self indexOfViewController:viewController];
    if ((self.pageIndex == 0) || (self.pageIndex == NSNotFound)) {
        return nil;
    }
    --self.pageIndex;
    return [self viewControllerAtIndex:self.pageIndex];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController
{
    self.pageIndex = [self indexOfViewController:viewController];
    if ((self.pageIndex == 2) || (self.pageIndex == NSNotFound)) {
        return nil;
    }
    ++self.pageIndex;
    return [self viewControllerAtIndex:self.pageIndex];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return self.pageViewControllers[index];
}

- (NSUInteger)indexOfViewController:(UIViewController *)viewController
{
    return [self.pageViewControllers indexOfObject:viewController];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    // The number of items reflected in the page indicator.
    return [self.pageViewControllers count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    // The selected item reflected in the page indicator.
    return self.pageIndex;
}

@end
