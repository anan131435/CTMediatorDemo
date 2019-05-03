//
//  ViewController.m
//  CTMediator
//
//  Created by 韩志峰 on 2019/5/2.
//  Copyright © 2019 韩志峰. All rights reserved.
//

#import "ViewController.h"
/*
 1.编译时刻 宏是预编译，const是编译阶段
 2.编译坚持： 宏不做检查，不会报编译错误，只是替换，const会编译检查，会报编译错误
 3.宏 能定义函数 方法 const 不能， 大量使用宏会造成编译时间久，每次都要重新替换
 
 
 
 */

#define MaxAgeHan @"age"

#define HanUserDefault [NSUserDefaults standardUserDefaults]

static NSString *const account = @"account";


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * str = MaxAgeHan;
    NSString *str2 = MaxAgeHan;
    NSLog(@"%p,%p",str,str2); //打出来的地址一样，宏定义的是常量，宏在常量区，只会生成一份内存
    /*
     const 作用
     1.const仅仅用来修饰右边的变量 （基本数据变量p 指针变量 *p）
     2.被const修饰的变量是只读的
     
     */
    int a = 1;
    a = 20;
    //这两种写法一样，const只修饰右边的变量
    const int b = 20;
    //int const b = 20;
   // b = 1; 不允许修改值
    
    int *p = &a;
    int c = 10;
    p = &c;
    *p = 20;
    //const 修饰的是右边的*p1
    const int *p1;
//    int const *p1;
    
    
}
/*
 const 开发使用场景
 1.提供一个方法，这个方法的参数是地址，里面只能通过地址读取值，不能通过地址修改值
 */
- (void)test:(int const *)a{
//    *a = 40; 只读
}

//const 放到*后面，表示a只读，不能修改a的地址，只能修改a访问的值
- (void)test1:(int * const)a{
    int b = 0;
//    a = &b;  报错
    *a = 20;
}
@end
