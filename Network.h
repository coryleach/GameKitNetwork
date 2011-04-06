/*
 *  Network.h
 *  NekoLogic
 *
 *  Created by Cory on 10/09/16.
 *  Copyright 2010 Cory R. Leach. All rights reserved.
 *
 *	These classes provide a simple way to create, send, and then
 *  dispatch network messages over a GKSession.
 *
 *  NetworkManager does not establish a session for you, instead
 *  you must establish the session and then set the session inside
 *  of NetworkManager to your session. NetworkManager will then take ownership
 *  of the session and set itself as the 'DataReceiveHandler' 
 *
 *  NetworkManager does *NOT* set itself as the session delegate. All connects
 *  and disconnects of peers as well as session creation/establishment are handled
 *  outside of NetowrkManager.
 *
 *	Requires: GameKit.framework
 *
 */

@class NetworkManager;
@class NetInMsg;

@protocol NetworkHandler

- (void) recieveMsg:(NetInMsg*)msg fromPeer:(NSString*)peer onNetwork:(NetworkManager*)network;

@end

typedef struct NetPacketHeader_t {
	uint8_t handler;
	uint8_t type;
	uint16_t size;
} NetPacketHeader;

#define MAX_PACKET_SIZE 0xFFFF

//Valid handler IDs are [1-255] inclusive
typedef uint8_t NetworkHandlerID;

#import "NetOutMsg.h"
#import "NetInMsg.h"
#import "NetworkManager.h"
