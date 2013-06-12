//
//  MoreAppsViewController.m
//  InstaCall
//
//  Created by forrest on 13-6-11.
//  Copyright (c) 2013年 DFA. All rights reserved.
//

#import "MoreAppsViewController.h"
static NSString *const iTellAFriendiOSAppStoreURLFormat2 = @"http://itunes.apple.com/app/id%@?mt=8&ls=1";

@interface MyApp : NSObject
@property (nonatomic,retain) NSString *appName;
@property (nonatomic,retain) NSString *device;
@property (nonatomic,retain) NSString *appLink;
@property (nonatomic,retain) NSString *appInfo;
@property (nonatomic,retain) NSString *developerLink;
@property (nonatomic,retain) NSString *appIconName;
@end

@implementation MyApp
@synthesize appName,device, appLink,developerLink,appInfo,appIconName;
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

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Custom initialization
    NSDictionary *appDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"myApps" ofType:@"plist"]];
    
    if (self.apps == nil ) {
        self.apps = [NSMutableArray array];
    }

    for (NSDictionary *d in [appDict allValues]) {
        MyApp *app = [[MyApp alloc] init];
        app.appName = [d objectForKey:@"name"];
        app.device = [d objectForKey:@"device"];
        
        NSString *appStoreID = [d objectForKey:@"appId"];
        app.appLink = [NSString stringWithFormat:iTellAFriendiOSAppStoreURLFormat2, appStoreID];
        DLog(@"app %@ link %@",app.appName, app.appLink);
        app.appIconName = [d objectForKey:@"icon"];
        app.appInfo = [d objectForKey:@"info"];
        
        // 0 : uni  1 : iphone 2 : ipad 
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            if ([app.device isEqualToString:@"0"] || [app.device isEqualToString:@"1"]  ) {
                [self.apps addObject:app];
            }
        }else{
            if ([app.device isEqualToString:@"0"] || [app.device isEqualToString:@"2"]  ) {
                [self.apps addObject:app];
            }

        }
    }

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView dropShadows];
    
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableCell"];
    
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
    
    static NSString *CellIdentifier = @"cell";
    PrettyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PrettyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.tableViewBackgroundColor = tableView.backgroundColor;
    }    
    if (indexPath.row >= 0 ) {
        MyApp *app = ((MyApp*)[self.apps objectAtIndex:indexPath.row]);
        cell.imageView.image = [UIImage imageNamed:app.appIconName];
        cell.textLabel.text = app.appName;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont flatFontOfSize:22.];
        cell.textLabel.textColor = [UIColor skyeBlueColor];
    }

    return cell;
    
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72.;
}

- (float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 72.;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	// create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
	
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = [UIColor brownColor];
    headerLabel.textAlignment = NSTextAlignmentCenter;
	headerLabel.highlightedTextColor = [UIColor whiteColor];
	headerLabel.font = [UIFont flatFontOfSize:20];
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
    
	// If you want to align the header text as centered
	// headerLabel.frame = CGRectMake(150.0, 0.0, 300.0, 44.0);
    
	headerLabel.text = @"More Apps"; // i.e. array element
	[customView addSubview:headerLabel];
    
	return customView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyApp *app = ((MyApp*)[self.apps objectAtIndex:indexPath.row]);
    DLog(@"click %d link %@  name %@", indexPath.row , app.appLink , app.appName);

    [Flurry logEvent: [NSString stringWithFormat:@"open %@", app.appName]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:app.appLink]];
}


@end
