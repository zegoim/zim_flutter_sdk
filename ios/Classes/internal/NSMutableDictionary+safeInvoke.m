//
//  NSDictionary+safeInvoke.m
//  zim
//
//  Created by 武耀琳 on 2022/5/11.
//

#import "NSMutableDictionary+safeInvoke.h"

@implementation NSMutableDictionary (safeInvoke)

-(void)safeSetObject:(nullable id)object
              forKey:(nonnull NSString *)key{
    if(object == nil || object == NULL || [object isEqual:[NSNull null]]){
        [self setObject:[NSNull null] forKey:key];
        return;
    }
    [self setObject:object forKey:key];
}

- (NSString *)descriptionWithLocale:(id)locale {
    NSArray *allKeys = [self allKeys];
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{"];
    for (NSString *key in allKeys) {
        id value = self[key];
        [str appendFormat:@" \"%@\" = %@,", key, value];
    }
    // 移除最后一个多余的逗号
    if (allKeys.count > 0) {
        [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
    }
    [str appendString:@"}"];
    return str;
}
@end
