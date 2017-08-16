#import <UIKit/UIKit.h>

@interface ChineseToPinyin : NSObject {
    
}
/// 汉语转拼音
+ (NSString *) pinyinFromChiniseString:(NSString *)string;
/// 换成拼音,并获取首字母
+ (char) sortSectionTitle:(NSString *)string; 
char pinyinFirstLetter(unsigned short hanzi);

@end
