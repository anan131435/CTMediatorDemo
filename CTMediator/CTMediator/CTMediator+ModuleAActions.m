//
//  CTMediator+ModuleAActions.m
//  CTMediator
//
//  Created by 韩志峰 on 2019/5/3.
//  Copyright © 2019 韩志峰. All rights reserved.
//

#import "CTMediator+ModuleAActions.h"
NSString *const kCTMediatorTargetA = @"A";
NSString * const kCTMediatorActionNativFetchDetailViewController = @"nativeFetchDetailViewController";
NSString * const kCTMediatorActionNativePresentImage = @"nativePresentImage";
NSString * const kCTMediatorActionNativeNoImage = @"nativeNoImage";
NSString * const kCTMediatorActionShowAlert = @"showAlert";
NSString * const kCTMediatorActionCell = @"cell";
NSString * const kCTMediatorActionConfigCell = @"configCell";



@implementation CTMediator (ModuleAActions)

- (UIViewController *)CTMediator_viewControllerForDetail{
    UIViewController *viewController = [self performTarget:kCTMediatorTargetA action:kCTMediatorActionNativFetchDetailViewController params:@{@"key":@"value"} shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]){
        // viewController交付出去后 push  present 取决于产品
        return  viewController;
    }else{
        //这里处理异常场景，具体如果处理取决于产品
        return [[UIViewController alloc] init];
    }
}
- (void)CTMediator_presentMessage:(UIImage *)image{
    if (image){
        [self performTarget:kCTMediatorTargetA action:kCTMediatorActionNativePresentImage params:@{@"image":image} shouldCacheTarget:NO];
    }else{
        [self performTarget:kCTMediatorTargetA action:kCTMediatorActionNativeNoImage params:@{@"image":[UIImage imageNamed:@"noImage"]} shouldCacheTarget:NO];
    }
}
- (void)CTMediator_showAlertWithMessage:(NSString *)message cancelAction:(void (^)(NSDictionary * _Nonnull))cancelAction confirmAction:(void (^)(NSDictionary * _Nonnull))confirmAction{
    NSMutableDictionary *paramsToSend = [[NSMutableDictionary alloc] init];
    if(message){
        paramsToSend[@"message"] = message;
    }
    if (cancelAction){
        paramsToSend[@"cancelAction"] = cancelAction;
    }
    if (confirmAction){
        paramsToSend[@"confirmAction"] = confirmAction;
    }
    [self performTarget:kCTMediatorTargetA action:kCTMediatorActionShowAlert params:paramsToSend shouldCacheTarget:NO];
}
- (UITableViewCell *)CTMediator_tableViewCellWithIdentifier:(NSString *)identifier tableView:(UITableView *)tableView{
    return [self performTarget:kCTMediatorTargetA action:kCTMediatorActionCell params:@{@"identifier":identifier,@"tableView":tableView} shouldCacheTarget:NO];
}
- (void)CTMediator_configCell:(UITableViewCell *)cell title:(NSString *)title indexPath:(NSIndexPath *)indexPath{
    [self performTarget:kCTMediatorTargetA action:kCTMediatorActionConfigCell params:@{@"cell":cell,@"title":title,@"indexPath":indexPath} shouldCacheTarget:YES];
}
- (void)CTMediator_cleanTableViewCellTarget{
    [self releaseCachedTargetWithTargetName:kCTMediatorTargetA];
}
@end
