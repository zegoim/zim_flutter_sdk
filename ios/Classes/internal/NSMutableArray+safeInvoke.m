//
//  NSMutableArray+safeInvoke.m
//  zim
//
//  Created by 武耀琳 on 2022/5/11.
//

#import "NSMutableArray+safeInvoke.h"

@implementation NSMutableArray (safeInvoke)

-(void)safeAddObject:(nullable id)object{
    if(object == nil || object == NULL || [object isEqual:[NSNull null]]){
        [self addObject:[NSNull null]];
        return;
    }
    [self addObject:object];
}
@end
