//
//  Target_A.h
//  CTMediator
//
//  Created by 韩志峰 on 2019/5/3.
//  Copyright © 2019 韩志峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_A : NSObject
- (UIViewController *)Action_nativeFetchDetailViewController:(NSDictionary *)params;
- (id)Action_nativePersentImage:(NSDictionary *)params;
- (id)Action_showAlert:(NSDictionary *)params;
- (id)Action_nativeNoImage:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
