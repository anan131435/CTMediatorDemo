//
//  Target_A.m
//  CTMediator
//
//  Created by 韩志峰 on 2019/5/3.
//  Copyright © 2019 韩志峰. All rights reserved.
//

#import "Target_A.h"
#import "DemoModuleADetailViewController.h"

typedef void (^CTUrlRouterCallBackBlock)(NSDictionary *info);

@implementation Target_A
- (UIViewController *)Action_nativeFetchDetailViewController:(NSDictionary *)params{
    //因为action是从属modelA的，所以action可以直接使用ModuleA里面的所有声明
    DemoModuleADetailViewController *viewController = [[DemoModuleADetailViewController alloc] init];
    viewController.valueLabel.text = params[@"key"];
    return viewController;
}
- (id)Action_nativePersentImage:(NSDictionary *)params{
    DemoModuleADetailViewController *viewController = [[DemoModuleADetailViewController alloc] init];
    viewController.valueLabel.text = @"this is image";
    viewController.imageView.image = params[@"image"];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:viewController animated:true completion:nil];
    return nil;
}
- (id)Action_showAlert:(NSDictionary *)params{
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        CTUrlRouterCallBackBlock callback = params[@"cancelAction"];
        if (callback){
            callback(@{@"alertAction":action});
        }
    }];
    return nil;
}
- (UITableViewCell *)Action_cell:(NSDictionary *)params{
    UITableView *tableView = params[@"tableView"];
    NSString *identifier = params[@"identifier"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

@end
