//
//  SchemeManager.h
//  MySecNote
//
//  Created by forrest on 13-5-26.
//  Copyright (c) 2013年 DFA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SchemeManager : NSObject

+ (id)sharedInstance;

- (void)setupSchemeWithColor:(UIColor*)color;
@end
