//
//  NSDictionary+safeInvoke.h
//  zim
//
//  Created by 武耀琳 on 2022/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableDictionary (safeInvoke)

-(void)safeSetObject:(nullable id)object
              forKey:(nonnull NSString *)key;

@end

NS_ASSUME_NONNULL_END
