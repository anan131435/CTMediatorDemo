//
//  CTMediator+ModuleAActions.h
//  CTMediator
//
//  Created by 韩志峰 on 2019/5/3.
//  Copyright © 2019 韩志峰. All rights reserved.
//

#import "CTMediator.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (ModuleAActions)

- (UIViewController *)CTMediator_viewControllerForDetail;
- (void)CTMediator_showAlertWithMessage:(NSString *)message cancelAction:(void(^)(NSDictionary *info))cancelAction confirmAction:(void(^)(NSDictionary *infor))confirmAction;
- (void)CTMediator_presentMessage:(UIImage *)image;
- (UITableViewCell *)CTMediator_tableViewCellWithIdentifier:(NSString *)identifier tableView:(UITableView *)tableView;
- (void)CTMediator_configCell:(UITableViewCell *)cell title:(NSString *)title indexPath:(NSIndexPath *)indexPath;

- (void)CTMediator_cleanTableViewCellTarget;

@end

NS_ASSUME_NONNULL_END
