//
//  NSArray+Log.m
//  AutoTest
//
//  Created by 武耀琳 on 2021/12/31.
//

#import "NSArray+Log.h"

@implementation NSArray (Log)
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *str = [NSMutableString stringWithFormat:@"%lu (\n", (unsigned long)self.count];
    for (id obj in self) {
        [str appendFormat:@"%@, ", obj];
    }
    // 移除最后一个多余的逗号和空格
    if (self.count > 0) {
        [str deleteCharactersInRange:NSMakeRange(str.length - 2, 2)];
    }
    [str appendString:@")"];
    return str;
}
@end
