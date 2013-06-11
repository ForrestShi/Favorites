//
//  People.h
//  InstaCall
//
//  Created by forrest on 13-6-11.
//  Copyright (c) 2013年 DFA. All rights reserved.
//

#import "BaseModel.h"

@interface People : BaseModel

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) UIImage *faceImage;
//For future
@property (nonatomic,strong) NSNumber *callCount;
@property (nonatomic,strong) NSNumber *callTimeLength;
@property (nonatomic,strong) NSString *emailAddress;
@property (nonatomic,strong) NSString *mobile;

@end
