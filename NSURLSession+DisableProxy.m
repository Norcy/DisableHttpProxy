//
//  NSURLSession+DisableProxy.m
//  iRead
//
//  Created by Nx on 2022/6/13.
//

#import "NSURLSession+DisableProxy.h"
#import <objc/runtime.h>

static BOOL isDisableHttpProxy = NO;

@implementation NSURLSession (DisableProxy)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleMethod(object_getClass(self), @selector(sessionWithConfiguration:delegate:delegateQueue:), @selector(dp_sessionWithConfiguration:delegate:delegateQueue:));
        swizzleMethod(object_getClass(self), @selector(sessionWithConfiguration:), @selector(dp_sessionWithConfiguration:));
    });
}

+ (void)disableHttpProxy
{
    isDisableHttpProxy = YES;
}

+ (void)enableHttpProxy
{
    isDisableHttpProxy = NO;
}

+ (NSURLSession *)dp_sessionWithConfiguration:(NSURLSessionConfiguration *)configuration
                                     delegate:(nullable id<NSURLSessionDelegate>)delegate
                                delegateQueue:(nullable NSOperationQueue *)queue
{
    if (!configuration)
    {
        configuration = [[NSURLSessionConfiguration alloc] init];
    }
    if (isDisableHttpProxy)
    {
        configuration.connectionProxyDictionary = @{};
    }
    return [self dp_sessionWithConfiguration:configuration delegate:delegate delegateQueue:queue];
}

+ (NSURLSession *)dp_sessionWithConfiguration:(NSURLSessionConfiguration *)configuration
{
    if (configuration && isDisableHttpProxy)
    {
        configuration.connectionProxyDictionary = @{};
    }
    return [self dp_sessionWithConfiguration:configuration];
}

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    // 获取 Method
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // 确保这两个方法一定存在（要么在本类，要么在其父类里）
    if (originalMethod && swizzledMethod)
    {
        // 如果本类没有 origin 方法，则给 originalSelector 添加 swizzled 实现（origin 方法在父类，因为 originalMethod 不为空），返回 YES
        // 如果本类有 origin 方法，则添加失败，返回 NO
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod)
        {
            // 添加成功，表示已实现 originalSelector -> swizzledIMP
            // 接下来实现 swizzledSelector -> originalIMP
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        }
        else
        {
            // 添加失败，表示类里原本就有 originalIMP，只需要交换这两个方法的实现即可
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}

@end
