//
//  CTMediator.h
//  CTMediator
//
//  Created by 韩志峰 on 2019/5/2.
//  Copyright © 2019 韩志峰. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kCTMediatorParamsKeySwiftTargetModuleName;

@interface CTMediator : NSObject
+ (instancetype) shareInstance;
//远程APP调用入口
- (id)performActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary * info))completion;
//本地组件调用入口
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)paramas shouldCacheTarget:(BOOL)shouldCacheTarget;
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName;

@end

NS_ASSUME_NONNULL_END
