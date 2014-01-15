//
//  ViewController.h
//  DekSoul
//
//  Created by Romain Boces on 17/11/2013.
//  Copyright (c) 2013 Romain Boces. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetSoulProtocolHandler.h"

@interface ViewController : UIViewController
{
    NetSoulProtocolHandler   *_netsoulHandler;
    
    NSUserDefaults  *_defaults;
    
    __weak IBOutlet UITextField *loginField;
    __weak IBOutlet UITextField *passwordField;
    __weak IBOutlet UISwitch *connectionSwitch;
    __weak IBOutlet UILabel *connectionLabel;
    __weak IBOutlet UILabel *statusLabel;
}

// Netsoul Delegates
- (void) netsoulSuccess:(NSString*)data;
- (void) netsoulError:(NSString*)data;

- (IBAction)switchClickHandler;
- (IBAction)loginEditingEnd;
- (IBAction)passwordEditingEnd;
- (IBAction)BackgroundTap:(id)sender;
- (void) autoConnect;

@end
