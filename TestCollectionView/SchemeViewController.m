//
//  SchemeViewController.m
//  MySecNote
//
//  Created by forrest on 13-5-25.
//  Copyright (c) 2013年 DFA. All rights reserved.
//

#import "SchemeViewController.h"
#import "QBFlatButton.h"
#import "SchemeManager.h"

@interface SchemeViewController (){
    NSArray *schemeBtnArray;
    NSArray *schemeColorArray;
}

@end

@implementation SchemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (QBFlatButton*)newFlatButtonWithFrame:(CGRect)frame{
    QBFlatButton *btn2 = [QBFlatButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = frame;
    btn2.faceColor = [UIColor grapeColor];
    btn2.sideColor = [UIColor lightCreamColor];
    btn2.radius = 0.;
    btn2.margin = 0.0;
    btn2.depth = 0.5;
    btn2.alpha = 1.;
    
    btn2.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[btn2 setTitle:@"Test" forState:UIControlStateNormal];
    return btn2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    schemeColorArray = @[[UIColor grassColor],[UIColor blueberryColor],[UIColor pinkColor],[UIColor grapeColor],[UIColor grassColor],[UIColor grassColor],[UIColor grassColor],[UIColor grassColor]];
    
    float w = self.view.bounds.size.width;
    float h = self.view.bounds.size.height;
    
    for (int i = 0; i  < 8 ; i++) {
        
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(i%2 * w/2, i/2 * h/4, w/2, h/4)];
        btn.tag = i;
        btn.backgroundColor = [schemeColorArray objectAtIndex:i];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        DLog(@"btn frame %@", NSStringFromCGRect(btn.frame));
        [self.view addSubview:btn];
    }
}

- (void)click:(id)sender{
    QBFlatButton* btn = (QBFlatButton*)sender;
    DLog(@"click %d",btn.tag);
    UIColor *selectedColor = [schemeColorArray objectAtIndex:btn.tag];
    [[NSUserDefaults standardUserDefaults] setObject:selectedColor forKey:@"color"];
    [[SchemeManager sharedInstance] setupSchemeWithColor:selectedColor];
    [[UINavigationBar appearance] setTintColor:selectedColor];
    [[UISearchBar appearance] setTintColor:selectedColor];

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        exit(0);

    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
