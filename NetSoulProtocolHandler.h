//
//  NetSoulProtocolHandler.h
//  DekSoul
//
//  Created by Romain Boces on 15/01/2014.
//  Copyright (c) 2014 Romain Boces. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#include "GCDAsyncSocket.h"

@interface NetSoulProtocolHandler : NSObject
{
    @private
    GCDAsyncSocket      *_socket;
    id                  _delegate;
    dispatch_queue_t    _delegateQueue;
    
    NSString        *_login;
    NSString        *_pass;
    
    NSString        *_hash;
    NSString        *_host;
    NSString        *_port;
}

// Server Host
#define HOST    "ns-server.epita.fr"
#define PORT    4242


// Server Reponses TAG

typedef enum    serverResponsesTag
{
    WELCOME_MESSAGE,
    ASK_PERMISSION,
    AUTH_USER,
    PING
} ServerResponsesTag;

typedef enum    serverReponse
{
    COMMAND_NOT_FOUND,
    COMMAND_END,
    COMMAND_ERROR
} ServerResponse;

// Constructor

- (id) initWithDelegate:(id)delegate deletgateQueue:(dispatch_queue_t)dq;

// Methods
- (void) connect:(NSString *)login password:(NSString*)passwd;
- (void) getConnectionData:(NSString*) welcomeMsg;
- (void) askPermisionAuthentification;
- (void) logUser;
- (void) userLogResponse:(NSString *)response;
- (void) waitForPing;
- (void) ping:(NSData*)data;
- (void) disconnect;
- (ServerResponse) serverResponse:(NSString*)data;

// Delegates

- (void) netsoulSuccess:(NSString*)data;
- (void) netsoulError:(NSString*)data;

// Delegates AsyncSocket
- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port;
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error;
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;

@end


@interface NSString(MD5)

- (NSString *)MD5;

@end