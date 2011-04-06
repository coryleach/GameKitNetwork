//
//  NetworkManager.m
//  NekoLogic
//
//  Created by Cory on 10/08/22.
//  Copyright 2010 Cory R. Leach. All rights reserved.
//

#import "NetworkManager.h"
#import "NetInMsg.h"
#import "NetOutMsg.h"

@implementation NetworkManager

static NetworkManager* _sharedInstance = nil;

@synthesize session;

+ (id) alloc {
	
	@synchronized([NetworkManager class]) {
		NSAssert(_sharedInstance == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedInstance = [super alloc];
		return _sharedInstance;
	}
	
	return nil;
	
}

- (id) init {
	
	if ( (self = [super init]) == nil ) {
		return self;
	}
	
	//Init
	handlers = [[NSMutableDictionary alloc] init];
	registeredObjects = [[NSMutableDictionary alloc] init];
	
	sendUpdateCounter = 0;
	recieveUpdateCounter = 0;
	
	return self;
	
}

- (void) dealloc {
	
	[handlers release];
	handlers = nil;
	
	[registeredObjects release];
	registeredObjects = nil;
		
	[super dealloc];
	
}

+ (NetworkManager*) sharedInstance {
	
	@synchronized([NetworkManager class])
	{
		if (!_sharedInstance) {
			
			[[self alloc] init];
			
			
		}
		
		return _sharedInstance;
	}
	
	// to avoid compiler warning
	return nil;
	
}

- (GKSessionMode) sessionMode {
	return [session sessionMode];	
}

- (BOOL) isServer {
	return (self.sessionMode == GKSessionModeServer);
}

- (BOOL) isClient {
	return (self.sessionMode == GKSessionModeClient);
}

- (BOOL) isPeer {
	return (self.sessionMode == GKSessionModePeer);
}

- (BOOL) isConnected {
	return ( [[session peersWithConnectionState:GKPeerStateConnected] count] > 0 );
}

- (void) setSession:(GKSession*)aSession {
	
	[session release];
	session = aSession;
	[session retain];
	
	[session setDataReceiveHandler:self withContext:NULL];
	
}
	
- (NSString*) myID {
	return [session peerID];
}

- (NSArray*) peers {
	return [session peersWithConnectionState:GKPeerStateConnected];
}

- (void) registerMessageHandler:(id<NetworkHandler>)handler withId:(NetworkHandlerID)handlerId {
	[handlers setObject:handler forKey:[NSNumber numberWithUnsignedChar:handlerId]];
}

- (id) handlerWithId:(NetworkHandlerID)handlerId {
	return [handlers objectForKey:[NSNumber numberWithUnsignedChar:handlerId]];
}

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)aSession context:(void *)context {

	NetInMsg* msg = [[NetInMsg alloc] initWithData:data];
	
	//Send Message to Appropriate Hander
	id<NetworkHandler> handler = [self handlerWithId:msg.handlerId];
	
	if ( handler != nil ) {
		[handler recieveMsg:msg fromPeer:peer onNetwork:self];
	}
	
	NSLog(@"NetworkManager: No Registered Handler For Message! %d",msg.handlerId);
	
}

@end
