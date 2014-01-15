//
//  ViewController.h
//  DekSoul
//
//  Created by Romain Boces on 17/11/2013.
//  Copyright (c) 2013 Romain Boces. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString(MD5)

- (NSString *)MD5;

@end

@interface ViewController : UIViewController
{
    int             _socket;
    const char      *_hash;
    const char      *_host;
    const char      *_port;
    NSUserDefaults  *_defaults;
    NSTimer         *_timer;
    
    __weak IBOutlet UITextField *loginField;
    __weak IBOutlet UITextField *passwordField;
    __weak IBOutlet UISwitch *connectionSwitch;
    __weak IBOutlet UILabel *connectionLabel;
    __weak IBOutlet UILabel *statusLabel;
}

//#define HOST    "ns-server.epita.fr"
//#define PORT    4242

#define HOST    "localhost"
#define PORT    4243

- (IBAction)switchClickHandler;
- (IBAction)loginEditingEnd;
- (IBAction)passwordEditingEnd;
- (void) timerEnd: (NSTimer*)timer;

@end
