//
//  ViewController.m
//  RACDemo
//
//  Created by iminder on 2016/11/16.
//  Copyright © 2016年 tencent. All rights reserved.
//

// 学习网址：https://www.raywenderlich.com/62699/reactivecocoa-tutorial-pt1
// http://www.cocoachina.com/industry/20140115/7702.html
// 《Functional reactive programming introduction using ReactiveCocoa》 https://www.gitbook.com/book/kevinhm/functionalreactiveprogrammingonios/details


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
//    [[self.name.rac_textSignal filter:^BOOL(id value) {
//        NSString *text = value;
//        return text.length > 3;
//    }] subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"输入内容%@", x);
//    } completed:^{
//        
//    }];
    
    //3. map 重新包装对象 nsstring ->number
//    [[[self.name.rac_textSignal map:^id(NSString *text) {
//        return @(text.length);
//    }] filter:^BOOL(NSNumber *num) {
//        return num.integerValue > 3;
//    }] subscribeNext:^(id x) {
//        NSLog(@"返回内容是%@", x);
//    } completed:^{
//        
//    }];
    [self validStatusSingal];
}

- (void)validStatusSingal {
    RACSignal *validUserNameSingal = [self.name.rac_textSignal map:^id(NSString *text) {
        return @([self isValidUserName:text]);
    }];
    
    RACSignal *validPasswordSingal = [self.password.rac_textSignal map:^id(NSString *passwd) {
        return @([self isValidPassword:passwd]);
    }];
    
    RAC(self.name, backgroundColor) = [validUserNameSingal map:^id(NSNumber *nameValid) {
        return [nameValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    RAC(self.password, backgroundColor) = [validPasswordSingal map:^id(NSNumber *passwdValid) {
        return [passwdValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    //combine
    [[RACSignal combineLatest:@[validPasswordSingal, validUserNameSingal] reduce:^id _Nonnull(NSNumber *passwdValid, NSNumber *nameValid){
        return @([passwdValid boolValue] && [nameValid boolValue]);
    }] subscribeNext:^(NSNumber *signupActive) {
        self.loginButton.enabled = [signupActive boolValue];
    } completed:^{
        
    }];
    
    //login action
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"登录事件");
    } completed:^{
        
    }];
    
}


- (BOOL)isValidUserName:(NSString *)text {
    return text.length > 3;
}

- (BOOL)isValidPassword:(NSString *)passwd {
    return passwd.length > 6;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
