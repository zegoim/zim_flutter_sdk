//
//  NSDictionary+safeInvoke.m
//  zim
//
//  Created by 武耀琳 on 2022/5/11.
//

#import "NSDictionary+safeInvoke.h"

@implementation NSDictionary (safeInvoke)

-(nullable id)safeObjectForKey:(nonnull NSString *)key{
    id object = [self objectForKey:key];
    if(object == nil || object == NULL || [object isEqual:[NSNull null]]){
        return nil;
    }
    return object;
}

@end
