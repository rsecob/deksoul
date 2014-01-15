//
//  AppDelegate.h
//  DekSoul
//
//  Created by Romain Boces on 17/11/2013.
//  Copyright (c) 2013 Romain Boces. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BOOL        _isBackground;
    UIBackgroundTaskIdentifier  bgTask;
}

@property (strong, nonatomic) UIWindow *window;

@end
