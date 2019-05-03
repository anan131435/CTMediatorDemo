//
//  CTMediator.m
//  CTMediator
//
//  Created by 韩志峰 on 2019/5/2.
//  Copyright © 2019 韩志峰. All rights reserved.
//

#import "CTMediator.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
/*
 CTmediator 这是调度的核心部件  根据获得的target和action信息，通过OC的runtime转换成targe实例和对应的action选择器
 
 CTMediator (ModuleAActions) CTmediator的category，这个模块A需要被其他模块B依赖，模块B才能调用A的 类和函数由业务模块A维护者维护
 
 Target_A  modelAViewController  target-action所在模块，也是业务模块，无需被依赖，其他模块通过A的CTMediator+ Category才能调用这里的功能。
 
 
 CTMediator + CategoryA     <======>   业务A
         ||
         ||
         ||
      CTMediator
 
 
 */
NSString * const kCTMediatorParamsKeySwiftTargetModuleName = @"kCTMediatorParamsKeySwiftTargetModuleName";

@interface CTMediator ()
@property (nonatomic, strong) NSMutableDictionary  *cachedTarget;
@end


@implementation CTMediator
+ (instancetype)shareInstance{
    static CTMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[CTMediator alloc] init];
    });
    return mediator;
}
/*
 scheme://[target]/[action]?[paramas]
 url sample:
 aaa://targetA/actionB?id=123
 */
- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary * _Nonnull))completion{
    NSMutableDictionary *paramas = [[NSMutableDictionary alloc] init];
    NSString *urlString = [url query];
    for (NSString *parama in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [parama componentsSeparatedByString:@"="];
        if ([elts count] < 2) continue;
        [paramas setObject:[elts lastObject] forKey:[elts firstObject]];
    }
    //这么写主要是处于安全考虑，防止黑客通过远程方式调用本地模块
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]){
        return @(NO);
    }
    id result = [self performTarget:url.host action:actionName params:paramas shouldCacheTarget:NO];
    if (completion){
        if (result){
            completion(@{@"result":result});
        }else{
            completion(nil);
        }
    }
    return nil;
    
}
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)paramas shouldCacheTarget:(BOOL)shouldCacheTarget{
    NSString *swiftModuleName = paramas[kCTMediatorParamsKeySwiftTargetModuleName];
    //generate target
    NSString *targetClassString = nil;
    if (swiftModuleName.length > 0 ){
        targetClassString = [NSString stringWithFormat:@"%@.Target_%@",swiftModuleName,targetName];
    }else{
        targetClassString = [NSString stringWithFormat:@"Target_%@",targetName];
    }
    NSObject *target = self.cachedTarget[targetClassString];
    if (target == nil){
        Class targetClass = NSClassFromString(targetClassString);
        target = [[targetClass alloc] init];
    }
    if (shouldCacheTarget){
        self.cachedTarget[targetClassString] = target;
    }
    
    
    //generate action
    NSString *actionString = [NSString stringWithFormat:@"Action_%@:",actionName];
    SEL action = NSSelectorFromString(actionString);
    if (target == nil){
        //这里是处理无响应请求的地方之一，这个demo做的简单，如果没有响应的target就直接return了
        [self noTargetActionResponseWithTargetString:targetClassString selectorString:actionString originParams:paramas];
        return  nil;
    }
    if ([target respondsToSelector:action]){
        return [self safePerformAction:action target:target params:paramas];
    }else{
        //这里是处理无响应请求的地方,如果无响应，则尝试对target的notFound方法统一处理
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]){
            return [self safePerformAction:action target:target params:paramas];
        }else{
           return nil;
        }
        
    }
}
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName{
    NSString *targetClassString = [NSString stringWithFormat:@"Target_%@",targetName];
    [self.cachedTarget removeObjectForKey:targetClassString];
}

#pragma mark - private methods
- (void)noTargetActionResponseWithTargetString:(NSString *)targetString selectorString:(NSString *)selectorString originParams:(NSDictionary *)originParams{
    SEL action = NSSelectorFromString(@"Action_response:");
    NSObject *target = [[NSClassFromString(@"Target_NoTargetAction") alloc] init];
    NSMutableDictionary *paramas = [NSMutableDictionary new];
    paramas[@"originParams"] = originParams;
    paramas[@"targetString"] = targetString;
    paramas[@"selectorString"] = selectorString;
    [self safePerformAction:action target:target params:paramas];
    
}
- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params{
    NSMethodSignature *methodSig = [target methodSignatureForSelector:action];
    if (methodSig == nil){
        return nil;
    }
    const char* retType = [methodSig methodReturnType];
    if (strcmp(retType, @encode(void)) == 0){
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    if(strcmp(retType, @encode(NSInteger)) == 0){
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}
- (NSMutableDictionary *)cachedTarget{
    if (!_cachedTarget) {
        _cachedTarget= [[NSMutableDictionary alloc] init];
    }
    return _cachedTarget;
}

@end
