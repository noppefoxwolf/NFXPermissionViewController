//
//  NFXPermissionViewController.h
//  NFXPermissionViewControllerDEMO
//
//  Created by Tomoya_Hirano on 2014/10/15.
//  Copyright (c) 2014年 Tomoya_Hirano. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NFXPermissionTypeTwitter,//social
    NFXPermissionTypeAddressBook,//addressbook
    NFXPermissionTypeCalendar,//Calendar
    NFXPermissionTypeReminder,//Reminder
    NFXPermissionTypeRecord,//Mic
} NFXPermissionType;

@class NFXPermissionViewController;
@protocol NFXPermissionViewControllerDelegate <NSObject>
-(void)NFXPermissionViewController:(NFXPermissionViewController*)NFXPermissionViewController accept:(BOOL)accept;
@end

@interface NFXPermissionViewController : UIViewController
-(id)initWithType:(NFXPermissionType)type;

@property (nonatomic,copy)   NSString*permission_title;
@property (nonatomic,copy)   NSString*permission_description;
@property (nonatomic,assign) id<NFXPermissionViewControllerDelegate>delegate;
@end
