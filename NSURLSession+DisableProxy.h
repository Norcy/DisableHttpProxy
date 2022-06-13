//
//  NSURLSession+DisableProxy.h
//  iRead
//
//  Created by Nx on 2022/6/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSession (DisableProxy)

+ (void)disableHttpProxy;

+ (void)enableHttpProxy;

@end

NS_ASSUME_NONNULL_END
