//
//  SplashViewController.m
//  InstaCall
//
//  Created by forrest on 13-6-11.
//  Copyright (c) 2013年 DFA. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor snowColor];
    
    UIImageView *centerLogoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon-72.png"]];
    centerLogoView.center = self.view.center;
    centerLogoView.alpha = 0.;
    [self.view addSubview:centerLogoView];
    [UIView animateWithDuration:.5 animations:^{
        centerLogoView.alpha = 1.;
    } completion:^(BOOL finished) {
        
    }];
    
    UILabel *copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44., self.view.bounds.size.width, 44.)];
    copyrightLabel.backgroundColor = [UIColor clearColor];
    copyrightLabel.text = @"@2013 DESIGN4APPLE ";
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    copyrightLabel.textColor = [UIColor goldColor];
    copyrightLabel.font = [UIFont fontWithName:@"TeluguSangamMN" size:14];
    [self.view addSubview:copyrightLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
