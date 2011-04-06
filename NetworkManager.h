//
//  NetworkManager.h
//  NekoLogic
//
//  Created by Cory on 10/08/22.
//  Copyright 2010 Cory R. Leach. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>
#import "Network.h"

//Note: Byte Order is Assumed to be the same between devices!
@interface NetworkManager : NSObject {

	GKSession* session;
	
	NSMutableDictionary* handlers;
	
	NSMutableDictionary* registeredObjects;
	
	NSUInteger sendUpdateCounter;
	NSUInteger recieveUpdateCounter;
	
}

@property (nonatomic,retain) GKSession* session;
@property (nonatomic,readonly) GKSessionMode sessionMode;

@property (nonatomic,readonly) BOOL isServer;
@property (nonatomic,readonly) BOOL isClient;
@property (nonatomic,readonly) BOOL isPeer;
@property (nonatomic,readonly) BOOL isConnected;

+ (NetworkManager*) sharedInstance;

- (void) registerMessageHandler:(id<NetworkHandler>)hander withId:(NetworkHandlerID)handlerId;
- (id) handlerWithId:(NetworkHandlerID)handlerId;

- (NSString*) myID;

- (NSArray*) peers;

- (void) receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)aSession context:(void *)context;

@end

