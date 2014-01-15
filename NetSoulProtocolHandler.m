//
//  NetSoulProtocolHandler.m
//  DekSoul
//
//  Created by Romain Boces on 15/01/2014.
//  Copyright (c) 2014 Romain Boces. All rights reserved.
//

#import "NetSoulProtocolHandler.h"

@implementation NetSoulProtocolHandler

///////////////////////////
// Constructor
///////////////////////////

- (id)init
{
    self = [super init];
    if (self) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

- (id) initWithDelegate:(id)delegate deletgateQueue:(dispatch_queue_t)dq;
{
    self = [super init];
    if (self) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        _delegate = delegate;
        _delegateQueue = dq;
    }
    return self;
}

///////////////////////////
// Methods
///////////////////////////

- (void)connect:(NSString *)login password:(NSString *)passwd
{
    NSError *err = nil;

    _login = login;
    _pass = passwd;
    if (_socket == nil)
        return;
    if (![_socket connectToHost:[NSString stringWithUTF8String:HOST] onPort:PORT error:&err])
        NSLog(@"I goofed: %@", err);
    else
        [_socket readDataToData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:WELCOME_MESSAGE];
}

- (void)disconnect
{
    [_socket disconnect];
}

- (ServerResponse)serverResponse:(NSString *)data
{
    if ([data rangeOfString:@"001"].length != 0)
        return COMMAND_NOT_FOUND;
    else if ([data rangeOfString:@"002"].length != 0)
        return COMMAND_END;
    return COMMAND_ERROR;
}

- (void)getConnectionData:(NSString *)welcomeMsg
{
    NSArray     *data;
    
    data = [welcomeMsg componentsSeparatedByString:@" "];
    if ([data count] > 4)
    {
        _hash = data[2];
        _host = data[3];
        _port = data[4];
    }
}

- (void)askPermisionAuthentification
{
    NSData  *permissionRequest;
    
    if (_socket != nil)
    {
        permissionRequest = [@"auth_ag ext_user none none\n" dataUsingEncoding:NSUTF8StringEncoding];
        [_socket writeData:permissionRequest withTimeout:-1 tag:ASK_PERMISSION];
        [_socket readDataToData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:ASK_PERMISSION];
    }
}

- (void)logUser
{
    NSString    *md5Secure;
    NSData      *logRequest;
    
    if (_socket != nil)
    {
        md5Secure = [[NSString stringWithFormat:@"%@-%@/%@%@", _hash, _host, _port, _pass] MD5];
        logRequest = [[NSString stringWithFormat:@"ext_user_log %@ %@ none DekSoul\n", _login, md5Secure] dataUsingEncoding:NSUTF8StringEncoding];
        [_socket writeData:logRequest withTimeout:-1 tag:AUTH_USER];
        [_socket readDataToData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:AUTH_USER];
    }
}

- (void)userLogResponse:(NSString *)response
{
    if (!_delegateQueue)
        return;
    
    if ([self serverResponse:response] == COMMAND_END
        && [_delegate respondsToSelector:@selector(netsoulSuccess:)])
    {
        [self waitForPing];
        dispatch_async(_delegateQueue, ^{
            [_delegate netsoulSuccess:@"Authentificaion Success"];
        });
    }
    else if ([_delegate respondsToSelector:@selector(netsoulError:)])
    {
        dispatch_async(_delegateQueue, ^{
            [_delegate netsoulError:@"Authentificaion Failed"];
        });
    }
}

- (void)waitForPing
{
    [_socket readDataToData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:PING];
}

- (void)ping:(NSData *)data
{
    [_socket writeData:data withTimeout:-1 tag:PING];
    [self waitForPing];
}

///////////////////////////
// AsyncSocket Delegates
///////////////////////////


- (void)socket:(GCDAsyncSocket *)sender didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"Cool, I'm connected! That was easy.");
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)error
{
    NSLog(@"I goofed: %@", error);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    switch (tag)
    {
        case WELCOME_MESSAGE:
            [self getConnectionData:[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]];
            [self askPermisionAuthentification];
            break;
            
        case ASK_PERMISSION:
            [self logUser];
            break;
            
        case AUTH_USER:
            [self userLogResponse:[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]];
            break;
            
        case PING:
            [self ping:data];
            break;
        default:
            break;
    }
}

@end

@implementation NSString(MD5)

- (NSString*)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

@end
