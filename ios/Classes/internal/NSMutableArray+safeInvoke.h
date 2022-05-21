//
//  NSMutableArray+safeInvoke.h
//  zim
//
//  Created by 武耀琳 on 2022/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (safeInvoke)

-(void)safeAddObject:(nullable id)object;

@end

NS_ASSUME_NONNULL_END
