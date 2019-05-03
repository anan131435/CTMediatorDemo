//
//  DemoModuleADetailViewController.m
//  CTMediator
//
//  Created by 韩志峰 on 2019/5/3.
//  Copyright © 2019 韩志峰. All rights reserved.
//

#import "DemoModuleADetailViewController.h"

@interface DemoModuleADetailViewController ()
@property (nonatomic, strong)  UIButton *returnButton;
@end

@implementation DemoModuleADetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.grayColor;
    [self.view addSubview: _valueLabel];
    [self.view addSubview: _imageView];
    [self.view addSubview: _returnButton];
}

- (void)didTappedReturnButton:(UIButton *)button{
    if (!self.navigationController){
        [self dismissViewControllerAnimated:true completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:true];
    }
}
#pragma mark - getters and setters
- (UILabel *)valueLabel
{
    if (_valueLabel == nil) {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = [UIFont systemFontOfSize:30];
        _valueLabel.textColor = [UIColor blackColor];
    }
    return _valueLabel;
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIButton *)returnButton
{
    if (_returnButton == nil) {
        _returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_returnButton addTarget:self action:@selector(didTappedReturnButton:) forControlEvents:UIControlEventTouchUpInside];
        [_returnButton setTitle:@"return" forState:UIControlStateNormal];
        [_returnButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _returnButton;
}

@end
