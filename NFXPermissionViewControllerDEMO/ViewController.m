//
//  ViewController.m
//  NFXPermissionViewControllerDEMO
//
//  Created by Tomoya_Hirano on 2014/10/15.
//  Copyright (c) 2014年 Tomoya_Hirano. All rights reserved.
//

#import "ViewController.h"
#import "NFXPermissionViewController.h"

@interface ViewController ()<NFXPermissionViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)ButtonPushed:(UIButton*)sender {
    NFXPermissionViewController*vc = [[NFXPermissionViewController alloc] initWithType:(NFXPermissionType)sender.tag];
    vc.delegate = self;
    [self presentViewController:vc animated:true completion:nil];
}

-(void)NFXPermissionViewController:(NFXPermissionViewController *)NFXPermissionViewController accept:(BOOL)accept{
    [NFXPermissionViewController dismissViewControllerAnimated:true completion:^{
        NSLog(@"%@",accept?@"true":@"false");
    }];
}

@end
