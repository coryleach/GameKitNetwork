//
//  NetOutMsg.m
//  NekoLogic
//
//  Created by Cory on 10/08/22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NetOutMsg.h"
#import "NetworkManager.h"
#import "AppUtility.h"

@implementation NetOutMsg

@synthesize header;
@synthesize handlerId;
@synthesize data;

- (id) init {
	
	if ( (self = [super init]) != nil ) {
		//Init
		data = [[NSMutableData alloc] initWithCapacity:1000];

		NetPacketHeader tempHeader;
		tempHeader.type = 0;
		tempHeader.handler = 0;
		tempHeader.size = 0;
	
		[data appendBytes:&tempHeader length:sizeof(NetPacketHeader)];
		
		header = (NetPacketHeader*)[data mutableBytes];
				
	}
	
	return self;
	
}

- (void) dealloc {

	[data autorelease];
	data = nil;
	
	[super dealloc];
	
}

- (NetworkHandlerID) handlerId {
	return header->handler;
}

- (void) setHandlerId:(NetworkHandlerID)newId {
	header->handler = newId;
}

- (void) writeUint8:(uint8_t)value {
	
	[data appendBytes:&value length:sizeof(value)];
	[self update];
	
}

- (uint8_t) type {
	return header->type;
}

- (void) setType:(uint8_t)value {
	header->type = value;
}

- (uint16_t) size {
	[self update];
	return header->size;
}

- (void) writeInt8:(int8_t)value {
	
	[data appendBytes:&value length:sizeof(value)];
	[self update];
	
}

- (void) writeUint16:(uint16_t)value {
	
	[data appendBytes:&value length:sizeof(value)];
	[self update];
	
}

- (void) writeInt16:(int16_t)value  {
	
	[data appendBytes:&value length:sizeof(value)];
	[self update];
	
}

- (void) writeUint32:(uint32_t)value  {
	
	[data appendBytes:&value length:sizeof(value)];
	[self update];
	
}

- (void) writeInt32:(int32_t)value {
	
	[data appendBytes:&value length:sizeof(value)];
	[self update];
	
}

- (void) writeFloat:(float)value {
	
	//For this version we're just going to assume byte order
	//Is the same between devices
	//int* pseudoValue = (int*)&value;
	//*pseudoValue = htonl(*pseudoValue);
	
	[data appendBytes:&value length:sizeof(value)];	
	[self update];
	
}


 - (void) writeInteger:(NSInteger)value {
 
	 [data appendBytes:&value length:sizeof(value)];	
	 [self update];
 
}

- (void) writeString:(NSString*)string {
	
	uint32_t size = [string lengthOfBytesUsingEncoding:NSUTF32BigEndianStringEncoding];
	[self writeUint32:size];	
	[data appendBytes:[string cStringUsingEncoding:NSUTF32BigEndianStringEncoding] length:size];
	[self update];
	
}

- (void) writeBuffer:(void*)buffer bytes:(uint32_t)length {
	
	[data appendBytes:buffer length:length];
	[self update];
	
}

- (void) write32Bit:(void*)value {
	
	[data appendBytes:value length:4];
	[self update];
	
}

- (void) write16Bit:(void*)value {
	
	[data appendBytes:value length:2];
	[self update];
	
}

- (void) write8Bit:(void*)value {
	
	[data appendBytes:value length:1];
	[self update];
	
}

- (void) update {
	
	//Update Packet Size in Header
	header->size = [data length];
	
}

- (BOOL) sendReliable {
	
	NSError* error = nil;
	[[[NetworkManager sharedInstance] session] sendDataToAllPeers:data withDataMode:GKSendDataReliable error:&error];
	
	if ( error != nil ) {
		[AppUtility errorAlert:[NSString stringWithFormat:@"Failed to Send Data Registered Msg: %@", [error localizedDescription]]];
		return NO;
	}
	
	return YES;
	
}

- (BOOL) sendUnreliable {
	
	NSError* error = nil;
	[[[NetworkManager sharedInstance] session] sendDataToAllPeers:data withDataMode:GKSendDataUnreliable error:&error];
	
	if ( error != nil ) {
		[AppUtility errorAlert:[NSString stringWithFormat:@"Failed to Send Data Registered Msg: %@", [error localizedDescription]]];
		return NO;
	}
	
	return YES;
	
}

@end
