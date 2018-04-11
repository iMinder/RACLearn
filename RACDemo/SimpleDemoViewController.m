//
//  ViewController.m
//  RACDemo
//
//  Created by iminder on 2016/11/16.
//  Copyright © 2016年 tencent. All rights reserved.
//

//  学习网址：https://www.raywenderlich.com/62699/reactivecocoa-tutorial-pt1
//  http://www.cocoachina.com/industry/20140115/7702.html
// 《Functional reactive programming introduction using ReactiveCocoa》 https://www.gitbook.com/book/kevinhm/functionalreactiveprogrammingonios/details
//  http://nathanli.cn/2015/08/27/reactivecocoa2-%E6%BA%90%E7%A0%81%E6%B5%85%E6%9E%90/


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
    RACSignal *textFieldSignal = [self.name.rac_textSignal map:^id(id value) {
        return @([value rangeOfString:@"@"].location != NSNotFound);
    }];
    RAC(self.name, textColor) = [textFieldSignal map:^id(id value) {
        if ([value boolValue]) {
            return [UIColor greenColor];
        } else {
            return [UIColor redColor];
        }
    }];
    
    self.loginButton.rac_command = [[RACCommand alloc] initWithEnabled:textFieldSignal signalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"button pressed");
        return [RACSignal empty];
    }];
//    [self.name.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
//        NSLog(@"输入内容%@", x);
//    } completed:^{
//        NSLog(@"输入完成");
//    }];
//
//    //2. 加个filter rac_textSignal -> filter(lenght > 3) ->subcribeNext
////    RACSignal *nameSignal = self.name.rac_textSignal;
////    RACSignal *filterUserName = [nameSignal filter:^BOOL(id value) {
////        NSString *text = value;
////        return text.length > 3;
////    }];
////    [filterUserName subscribeNext:^(id  _Nullable x) {
////        NSLog(@"输入内容必然 > 3 : %@", x);
////    } completed:^{
////
////    }];
////    [[self.name.rac_textSignal filter:^BOOL(id value) {
////        NSString *text = value;
////        return text.length > 3;
////    }] subscribeNext:^(NSString * _Nullable x) {
////        NSLog(@"输入内容%@", x);
////    } completed:^{
////
////    }];
//
//    //3. map 重新包装对象 nsstring ->number
////    [[[self.name.rac_textSignal map:^id(NSString *text) {
////        return @(text.length);
////    }] filter:^BOOL(NSNumber *num) {
////        return num.integerValue > 3;
////    }] subscribeNext:^(id x) {
////        NSLog(@"返回内容是%@", x);
////    } completed:^{
////
////    }];
//    [self validStatusSingal];
//}
//
//- (void)validStatusSingal {
//    RACSignal *validUserNameSingal = [self.name.rac_textSignal map:^id(NSString *text) {
//        return @([self isValidUserName:text]);
//    }];
//
//    RACSignal *validPasswordSingal = [self.password.rac_textSignal map:^id(NSString *passwd) {
//        return @([self isValidPassword:passwd]);
//    }];
//
//    RAC(self.name, backgroundColor) = [validUserNameSingal map:^id(NSNumber *nameValid) {
//        return [nameValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
//    }];
//
//    RAC(self.password, backgroundColor) = [validPasswordSingal map:^id(NSNumber *passwdValid) {
//        return [passwdValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
//    }];
//
//    //combine
//    [[RACSignal combineLatest:@[validPasswordSingal, validUserNameSingal] reduce:^id _Nonnull(NSNumber *passwdValid, NSNumber *nameValid){
//        return @([passwdValid boolValue] && [nameValid boolValue]);
//    }] subscribeNext:^(NSNumber *signupActive) {
//        self.loginButton.enabled = [signupActive boolValue];
//    } completed:^{
//
//    }];
//
//    //login action 不完美版本
//    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        NSLog(@"登录事件");
//    } completed:^{
//
//    }];
//
//    [[[[self.loginButton
//        rac_signalForControlEvents:UIControlEventTouchUpInside]
//       doNext:^(id x) {
//           self.loginButton.enabled = NO;
//       }]
//      flattenMap:^id(id x) {
//          return [self signInSignal];
//      }]
//     subscribeNext:^(NSNumber *signedIn) {
//         self.loginButton.enabled = YES;
//         BOOL success = [signedIn boolValue];
////         self.signInFailureText.hidden = success;
//         if (success) {
//             //登录成功
//         }
//     }];
//
    //
    [self racStreams];
}

- (void)racStreams {
    NSArray *array = @[@(1),@(2),@(3)];
    RACSequence *stream = [array rac_sequence];
    [stream map:^id(id value) {
        return @(pow([value integerValue], 2));
    }];
    NSLog(@"stream array %@", [stream array]);
    
    //left fold
    NSLog(@"%@",[[stream map:^id(id value) {
        return [value stringValue];
        }]foldLeftWithStart:@"haha" reduce:^id(id accumulator, id value) {
            NSLog(@"accumulator is %@ and value is %@", accumulator, value);
            
        return [accumulator stringByAppendingString:value];
    }]);
}
- (BOOL)isValidUserName:(NSString *)text {
    return text.length > 3;
}

- (BOOL)isValidPassword:(NSString *)passwd {
    return passwd.length > 6;
}


-(RACSignal *)signInSignal {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        [self.signInService
//         signInWithUsername:self.usernameTextField.text
//         password:self.passwordTextField.text
//         complete:^(BOOL success) {
//             [subscriber sendNext:@(success)];
//             [subscriber sendCompleted];
//         }];
        return nil;
    }];
}


@end
