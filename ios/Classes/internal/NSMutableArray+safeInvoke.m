//
//  NSMutableArray+safeInvoke.m
//  zim
//
//  Created by 武耀琳 on 2022/5/11.
//

#import "NSMutableArray+safeInvoke.h"

@implementation NSMutableArray (safeInvoke)

- (void)safeAddObject:(nullable id)object {
    if (object == nil || object == NULL || [object isEqual:[NSNull null]]) {
        [self addObject:[NSNull null]];
        return;
    }
    [self addObject:object];
}

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
