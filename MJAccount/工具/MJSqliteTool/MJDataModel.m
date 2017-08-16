//
//  MJDataModel.m
//  MJAccount
//
//  Created by YXCZ on 17/8/7.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJDataModel.h"
#import "MJStringTool.h"

@implementation MJDataModel

-(instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)groupID {
    if (_groupID == nil) {
        _groupID = @"";
    }
    
    return _groupID;
}

- (NSString *)dsc {
    if (_dsc == nil) {
        _dsc = @"";
    }
    
    return _dsc;
}

- (NSString *)email {
    if (_email == nil) {
        _email = @"";
    }
    
    return _email;
}
- (NSString *)phoneNumber {
    if (_phoneNumber == nil) {
        _phoneNumber = @"";
    }
    
    return _phoneNumber;
}
- (NSString *)password {
    if (_password == nil) {
        _password = @"";
    }
    
    return _password;
}
- (NSString *)account {
    if (_account == nil) {
        _account = @"";
    }
    
    return _account;
}
- (NSString *)title {
    if (_title == nil) {
        _title = @"";
    }
    
    return _title;
}
-(NSString *)groupName {
    if (_groupName == nil) {
        _groupName = @"";
    }
    
    return _groupName;
}
- (NSString *)identifier {
    
    if (_identifier == nil) {
        _identifier = [MJStringTool creatRedomMD5String];
    }
    
    return _identifier;
}

@end
