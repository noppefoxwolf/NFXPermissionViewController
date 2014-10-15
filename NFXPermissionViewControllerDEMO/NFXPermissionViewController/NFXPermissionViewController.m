//
//  NFXPermissionViewController.m
//  NFXPermissionViewControllerDEMO
//
//  Created by Tomoya_Hirano on 2014/10/15.
//  Copyright (c) 2014年 Tomoya_Hirano. All rights reserved.
//

#import "NFXPermissionViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <AddressBook/AddressBook.h>
#import <EventKit/EventKit.h>
#import <AVFoundation/AVAudioSession.h>

@interface NFXPermissionViewController (){
    NFXPermissionType type_;
    UIImageView*app_iv;
    UIImageView*permisson_iv;
    UILabel*title_lbl;
    UILabel*description_lbl;
}

@end

@implementation NFXPermissionViewController

-(id)initWithType:(NFXPermissionType)type{
    self = [super init];
    if (self) {
        type_ = type;
        [self setup];
    }
    return self;
}

-(void)setup{
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    
    CGPoint permisson_iv_center  = self.view.center;
    permisson_iv_center.x -= 36;
    permisson_iv_center.y -= 100;
    permisson_iv= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    permisson_iv.center = permisson_iv_center;
    permisson_iv.backgroundColor = [UIColor redColor];
    permisson_iv.layer.cornerRadius = 5;
    permisson_iv.image = [UIImage imageNamed:@"key.jpg"];
    permisson_iv.clipsToBounds = true;
    [self.view addSubview:permisson_iv];
    
    CGPoint app_iv_center = self.view.center;
    app_iv_center.x += 36;
    app_iv_center.y -= 100;
    app_iv= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64, 64)];
    app_iv.center = app_iv_center;
    app_iv.backgroundColor = [UIColor redColor];
    app_iv.layer.cornerRadius = 5;
    app_iv.image = [UIImage imageNamed:@"120x120.png"];
    app_iv.clipsToBounds = true;
    [self.view addSubview:app_iv];
    
    CGPoint btncenter = self.view.center;
    CGRect  btnrect   = CGRectMake(0, 0, 200, 44);
    btncenter.y = self.view.bounds.size.height - 66;
    UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:createImageFromUIColor([UIColor whiteColor]) forState:UIControlStateNormal];
    [btn setBackgroundImage:createImageFromUIColor([UIColor lightGrayColor]) forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [btn setTitle:@"Accept" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonpushed:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = btnrect;
    btn.center = btncenter;
    btn.layer.cornerRadius = 5;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 0.5;
    btn.clipsToBounds = true;
    [self.view addSubview:btn];
    

    title_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    title_lbl.font = [UIFont boldSystemFontOfSize:22];
    title_lbl.textAlignment = NSTextAlignmentCenter;
    title_lbl.text = [self defaultTitle];
    [self.view addSubview:title_lbl];
    [title_lbl sizeToFit];
    

    description_lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 100)];
    description_lbl.numberOfLines = 0;
    description_lbl.font = [UIFont systemFontOfSize:16];
    description_lbl.text = [self defaultDescription];
    [self.view addSubview:description_lbl];
    
    [self viewWillLayoutSubviews];
}

-(void)viewWillLayoutSubviews{
    CGPoint title_lbl_center = self.view.center;
    title_lbl.center = title_lbl_center;
    CGPoint description_lbl_center = self.view.center;
    description_lbl_center.y += 100;
    description_lbl.center = description_lbl_center;
}

-(NSString*)defaultTitle{
    if (self.permission_title) {
        return self.permission_title;
    }
    
    switch (type_) {
        case NFXPermissionTypeTwitter:
            return @"Require twitter access";
        case NFXPermissionTypeAddressBook:
            return @"Require addressbook access";
        case NFXPermissionTypeCalendar:
            return @"Require calendar access";
        case NFXPermissionTypeReminder:
            return @"Require reminder access";
        case NFXPermissionTypeRecord:
            return @"Require mic access";
    }
    return @"";
}

-(NSString*)defaultDescription{
    if (self.permission_description) {
        return self.permission_description;
    }
    switch (type_) {
        case NFXPermissionTypeTwitter:
            return @"If you will accept permission,this app can access twitter.";
        case NFXPermissionTypeAddressBook:
            return @"If you will accept permission,this app can access addressbook.";
        case NFXPermissionTypeCalendar:
            return @"If you will accept permission,this app can access calendar.";
        case NFXPermissionTypeReminder:
            return @"If you will accept permission,this app can access reminder.";
        case NFXPermissionTypeRecord:
            return @"If you will accept permission,this app can access microphone.";
    }
    return @"";
}

-(void)buttonpushed:(UIButton*)sender{
    switch (type_) {
        case NFXPermissionTypeTwitter:
            [self requestAccessSocial:ACAccountTypeIdentifierTwitter];
            break;
        case NFXPermissionTypeAddressBook:
            [self AddressBookRequest];
            break;
        case NFXPermissionTypeCalendar:
            [self requestAccessEventWithType:EKEntityTypeEvent];
            break;
        case NFXPermissionTypeReminder:
            [self requestAccessEventWithType:EKEntityMaskReminder];
            break;
        case NFXPermissionTypeRecord:
            [self requestRecord];
            break;
        default:
            break;
    }
}

-(void)requestRecord{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate NFXPermissionViewController:self accept:granted];
        });
    }];
}

-(void)requestAccessEventWithType:(EKEntityType)eventType{
    [[EKEventStore new] requestAccessToEntityType:eventType completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate NFXPermissionViewController:self accept:granted];
        });
    }];
}

- (void)requestAccessSocial:(NSString*)identifer{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twAccountType = [accountStore accountTypeWithAccountTypeIdentifier:identifer];
    [accountStore requestAccessToAccountsWithType:twAccountType
                                          options:nil
                                       completion:^(BOOL granted, NSError *error) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [self.delegate NFXPermissionViewController:self accept:granted];
                                           });
                                       }];
}

-(void)AddressBookRequest{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate NFXPermissionViewController:self accept:granted];
        });
    });
}

//---------------
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

UIImage *(^createImageFromUIColor)(UIColor *) = ^(UIColor *color)
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [color CGColor]);
    CGContextFillRect(contextRef, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
};
@end
