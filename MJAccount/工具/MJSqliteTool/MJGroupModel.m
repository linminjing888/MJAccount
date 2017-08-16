//
//  MJGroupModel.m
//  MJAccount
//
//  Created by YXCZ on 17/8/7.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJGroupModel.h"
#import "MJStringTool.h"

@implementation MJGroupModel

-(NSString*)groupName{
    if (_groupName == nil) {
        return @"默认分组";
    }
    return _groupName;
}
-(NSString*)identifier{
    if (_identifier == nil) {
        _identifier = [MJStringTool creatRedomMD5String];
    }
    return _identifier;
}
@end
