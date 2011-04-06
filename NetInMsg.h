//
//  NetInMsg.h
//  NekoLogic
//
//  Created by Cory on 10/08/22.
//  Copyright 2010 Cory R. Leach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Network.h"

@interface NetInMsg : NSObject {

	NSData* data;
	NSRange range;
	NetPacketHeader* header;
}

@property (readonly) NSData* data;
@property (readonly) NetPacketHeader* header;

//Header Convinience Methods
@property (readonly) NetworkHandlerID handlerId;
@property (readonly) uint8_t type;
@property (readonly) uint16_t size;

- (id) initWithData:(NSData*)aData;

//Reset Location Pointer
- (void) reset;

//8-bit
- (uint8_t) readUint8;
- (int8_t) readInt8;

//16-bit
- (uint16_t) readUint16;
- (int16_t) readInt16;

//32-bit
- (uint32_t) readUint32;
- (int32_t) readInt32;

//Other
- (float) readFloat;
- (NSString*) readString;

- (NSInteger) bytesRemaining;

//Raw Buffer
- (void) readBuffer:(void*)buffer bytes:(uint32_t)length;
- (void) read32Bit:(void*)buffer;
- (void) read16Bit:(void*)buffer;
- (void) read8Bit:(void*)buffer;

@end
