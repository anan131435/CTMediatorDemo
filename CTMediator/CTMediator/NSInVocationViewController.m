//
//  NSInVocationViewController.m
//  CTMediator
//
//  Created by 韩志峰 on 2019/5/3.
//  Copyright © 2019 韩志峰. All rights reserved.
//

#import "NSInVocationViewController.h"
/*
 
 ios中，可以直接调用某个对象的消息方式有2种
 [self performSelector:<#(SEL)#> withObject:<#(id)#>] 对于参数较多和带返回值的就需要额外处理，可以用NSInvocation搞定
 NSInvocation
 */
@interface NSInVocationViewController ()

@end

@implementation NSInVocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //NSInvocation 包装方法和对应的对象，他可以存储方法的名称 对应的对象 对应的参数
    // NSMethodSignature 签名对象，再创建NSMethodSignature的时候，必须传递一个签名对象，通过签名对象获得参数的个数和方法的返回值
    NSMethodSignature *signare = [NSInVocationViewController instanceMethodSignatureForSelector:@selector(sendMessageWithNumber:content:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signare];
    invocation.target = self;
    invocation.selector = @selector(sendMessageWithNumber:content:);
    NSString *number = @"13718536806";
    //0 已经被self占用，1 已经被_cmd占用
    [invocation setArgument:&number atIndex:2];
    NSString *content = @"nice";
    [invocation setArgument:&content atIndex:3];
    [invocation invoke];
    
    
}
- (void)sendMessageWithNumber:(NSString *)number content:(NSString *)content{
    NSLog(@"电话号码%@内容%@",number,content);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
