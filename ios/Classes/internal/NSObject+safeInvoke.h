//
//  NSObject+safeInvoke.h
//  zim
//
//  Created by 武耀琳 on 2022/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (safeInvoke)

-(void)safeSetValue:(nullable id)value
             forKey:(nonnull NSString *)key;

@end

NS_ASSUME_NONNULL_END
