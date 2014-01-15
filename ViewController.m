//
//  ViewController.m
//  DekSoul
//
//  Created by Romain Boces on 17/11/2013.
//  Copyright (c) 2013 Romain Boces. All rights reserved.
//

#import "ViewController.h"
#import "socket.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    _netsoulHandler = [[NetSoulProtocolHandler alloc] initWithDelegate:self deletgateQueue:dispatch_get_main_queue()];
    
    _defaults = [NSUserDefaults standardUserDefaults];
    statusLabel.text = @"Disconnected";
    loginField.text = [_defaults objectForKey:@"loginData"];
    passwordField.text = [_defaults objectForKey:@"passwordData"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)switchClickHandler
{
    if ([connectionSwitch isOn])
        [_netsoulHandler connect:loginField.text password:passwordField.text];
    else
        [_netsoulHandler disconnect];
}

-(IBAction)loginEditingEnd
{
    [_defaults setValue:loginField.text forKey:@"loginData"];
    [_defaults synchronize];
}

-(IBAction)passwordEditingEnd
{
    [_defaults setValue:passwordField.text forKey:@"passwordData"];
    [_defaults synchronize];
}

- (IBAction)BackgroundTap:(id)sender
{
    [loginField resignFirstResponder];
    [passwordField resignFirstResponder];
}

-(void) autoConnect
{
    if (loginField.text.length != 0 &&
        passwordField.text.length != 0)
    {
        [connectionSwitch setOn:true animated:true];
        [_netsoulHandler connect:loginField.text password:passwordField.text];
    }
}

////////////////////////////
// Netsoul Delegates
////////////////////////////

- (void)netsoulSuccess:(NSString *)data
{
    [connectionLabel setText:@"Connected"];
    [statusLabel setText:data];
}

- (void)netsoulError:(NSString *)data
{
    [connectionLabel setText:@"Error"];
    [statusLabel setText:data];
}

@end
