//
//  MJDataModel.h
//  MJAccount
//
//  Created by YXCZ on 17/8/7.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJDataModel : NSObject

@property (copy, nonatomic) NSString *identifier;
@property (copy, nonatomic) NSString *groupName;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *account;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *phoneNumber;
@property (copy, nonatomic) NSString *email;
@property (copy, nonatomic) NSString *dsc;
@property (copy, nonatomic) NSString *groupID;

@end

