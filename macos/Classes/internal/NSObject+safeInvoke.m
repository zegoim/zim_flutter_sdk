//
//  NSObject+safeInvoke.m
//  zim
//
//  Created by 武耀琳 on 2022/5/11.
//

#import "NSObject+safeInvoke.h"

@implementation NSObject (safeInvoke)

-(void)safeSetValue:(nullable id)value
             forKey:(nonnull NSString *)key{
    if(value == nil || value == NULL || [value isEqual:[NSNull null]]){
        return;
    }
    [self setValue:value forKey:key];
}

@end
