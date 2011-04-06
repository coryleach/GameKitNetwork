//
//  NetOutMsg.h
//  NekoLogic
//
//  Created by Cory on 10/08/22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"

@interface NetOutMsg : NSObject {
	
	NSMutableData* data;
	NetPacketHeader* header;
	
}

@property (readonly) NSMutableData* data;
@property (readonly) NetPacketHeader* header;

//Header Properties (Convinience Methods)
@property (assign) NetworkHandlerID handlerId;
@property (assign) uint8_t type;
@property (readonly) uint16_t size;

- (void) writeUint8:(uint8_t)value;
- (void) writeInt8:(int8_t)value;
- (void) writeUint16:(uint16_t)value;
- (void) writeInt16:(int16_t)value;
- (void) writeUint32:(uint32_t)value;
- (void) writeInt32:(int32_t)value;
- (void) writeFloat:(float)value;
- (void) writeString:(NSString*)string;

- (void) writeBuffer:(void*)buffer bytes:(uint32_t)length;

- (void) write32Bit:(void*)value;
- (void) write16Bit:(void*)value;
- (void) write8Bit:(void*)value;

- (void) update; //Called internally to update packet size in header

- (BOOL) sendReliable;
- (BOOL) sendUnreliable;

@end
