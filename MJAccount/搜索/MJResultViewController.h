//
//  MJResultViewController.h
//  MJAccount
//
//  Created by YXCZ on 17/8/10.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import "MJBaseViewController.h"

@class MJDataModel;
typedef void(^searchBlock)(MJDataModel * model);
@interface MJResultViewController : MJBaseViewController<UISearchResultsUpdating>
@property (nonatomic,copy) searchBlock selectResult;
@end
