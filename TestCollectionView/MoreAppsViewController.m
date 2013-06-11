//
//  MoreAppsViewController.m
//  InstaCall
//
//  Created by forrest on 13-6-11.
//  Copyright (c) 2013年 DFA. All rights reserved.
//

#import "MoreAppsViewController.h"

@interface MyApp : NSObject
@property (nonatomic,retain) NSString *appName;
@property (nonatomic,retain) NSString *appLink;
@property (nonatomic,retain) NSString *appInfo;
@property (nonatomic,retain) NSString *developerLink;
@property (nonatomic,retain) NSString *appIconName;
@end

@implementation MyApp
@synthesize appName, appLink,developerLink,appInfo,appIconName;
@end

@interface MoreAppsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *apps;
@end

@implementation MoreAppsViewController
@synthesize apps;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSDictionary *appDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"myApps" ofType:@"plist"]];
        
        for (NSDictionary *d in [appDict allValues]) {
            MyApp *app = [[MyApp alloc] init];
            app.appName = [d objectForKey:@"name"];
            app.appLink = [d objectForKey:@"link"];
            app.appIconName = [d objectForKey:@"icon"];
            app.appInfo = [d objectForKey:@"info"];
            if (!self.apps) {
                self.apps = [NSMutableArray array];
            }
            [self.apps addObject:app];
        }

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableCell"];    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.apps.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    MyApp *app = ((MyApp*)[self.apps objectAtIndex:indexPath.row]);
    cell.imageView.image = [UIImage imageNamed:app.appIconName];
    cell.textLabel.text = app.appName;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont flatFontOfSize:22.];
    cell.textLabel.textColor = [UIColor skyeBlueColor];

    return cell;
    
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72.*2;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyApp *app = ((MyApp*)[self.apps objectAtIndex:indexPath.row]);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:app.appLink]];
}


@end
