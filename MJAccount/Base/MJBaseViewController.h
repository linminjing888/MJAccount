//
//  MJBaseViewController.h
//  MJAccount
//
//  Created by YXCZ on 17/8/7.
//  Copyright © 2017年 JingJing_Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MJButtonBlock)(UIButton* button);

@interface MJBaseViewController : UIViewController

@property (nonatomic,strong)UIButton *leftButon;
@property (nonatomic,strong)UIButton *rightButton;
@property (nonatomic,strong)UILabel *customTitleLabel;
@property (nonatomic,copy)NSString *flog;

- (void)MJSetNavigationTitle:(NSString*)title;
- (void)MJSetLeftButtonWithTitle:(NSString*)title
                   selectedImage:(NSString*)selectImageName
                     normalImage:(NSString*)normalImage
                     actionBlock:(MJButtonBlock)block;
- (void)MJSetRightButtonWithTitle:(NSString*)title
                    selectedImage:(NSString*)selectImageName
                      normalImage:(NSString*)normalImage
                      actionBlock:(MJButtonBlock)block;
- (void)MJHiddenNavigationBar:(BOOL)hidden;

@end
