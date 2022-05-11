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


@end
