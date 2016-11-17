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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
