//
//  SchemeManager.m
//  MySecNote
//
//  Created by forrest on 13-5-26.
//  Copyright (c) 2013年 DFA. All rights reserved.
//

#import "SchemeManager.h"
#import "UIBarButtonItem+FlatUI.h"
//#import "UIColor+FlatUI.h"
#import "UINavigationBar+FlatUI.h"
#import "UIColor+Colours.h"


@implementation SchemeManager

+ (id)sharedInstance{
    static SchemeManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[SchemeManager alloc] init];
    });
    return _instance;
}


- (void)setupSchemeWithColor:(UIColor*)color{

    if (!color) {
        color = [[NSUserDefaults standardUserDefaults] objectForKey:@"color"];
        if (!color) {
            color = [UIColor skyeBlueColor];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:color forKey:@"color"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[UINavigationBar appearance] setTintColor:color];
    [[UISearchBar appearance] setTintColor:color];
    [UIBarButtonItem configureFlatButtonsWithColor:color
                                  highlightedColor:color
                                      cornerRadius:3];
    [[UINavigationBar appearance] configureFlatNavigationBarWithColor:color];
}
@end
