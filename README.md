NFXPermissionViewController
=========================
If you use this library, the user put one cushion before the permission agreement.

![](http://i.imgur.com/bnXxsTn.png)

##Installation
>1.add your project `NFXPermissionViewController.h` and `NFXPermissionViewController.m`.

##Usage
```
#import "NFXPermissionViewController.h"
```

```
    NFXPermissionViewController*vc = [[NFXPermissionViewController alloc] initWithType:NFXPermissionTypeTwitter];
    vc.delegate = self;
    [self presentViewController:vc animated:true completion:nil];
```
support for
* twitter
* addressbook
* calender
* reminder
* microphone


##About
noppefoxwolf
- [GitHub](http://github.com/noppefoxwolf)
- [Twitter](http://twitter.com/noppefoxwolf)