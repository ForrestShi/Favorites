//
//  PeopleViewController.m
//  InstaCall
//
//  Created by forrest on 13-6-13.
//  Copyright (c) 2013年 DFA. All rights reserved.
//

#import "PeopleViewController.h"

@interface PeopleViewController ()

@end

@implementation PeopleViewController
@synthesize person;


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
    self.view.backgroundColor = [UIColor whiteColor];
    if (person) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        if (person.faceImage) {
            imgView.image = person.faceImage;
//            [imgView sizeToFit];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            [self.view addSubview:imgView];
        }else{
            self.view.backgroundColor = [UIColor grassColor];
        }
    }
    
    UITapGestureRecognizer *tapToBack = [[UITapGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        //
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    [self.view addGestureRecognizer:tapToBack];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
