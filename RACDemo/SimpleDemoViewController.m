//
//  ViewController.m
//  RACDemo
//
//  Created by iminder on 2016/11/16.
//  Copyright © 2016年 tencent. All rights reserved.
//

#import "SimpleDemoViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface SimpleDemoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation SimpleDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //1. 简单的例子
//    [self.name.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"输入内容%@", x);
//    } completed:^{
//        
//    }];
    
    //2. 加个filter rac_textSignal -> filter(lenght > 3) ->subcribeNext
//    RACSignal *nameSignal = self.name.rac_textSignal;
//    RACSignal *filterUserName = [nameSignal filter:^BOOL(id value) {
//        NSString *text = value;
//        return text.length > 3;
//    }];
//    [filterUserName subscribeNext:^(id  _Nullable x) {
//        NSLog(@"输入内容必然 > 3 : %@", x);
//    } completed:^{
//        
//    }];
    [[self.name.rac_textSignal filter:^BOOL(id value) {
        NSString *text = value;
        return text.length > 3;
    }] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"输入内容%@", x);
    } completed:^{
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
