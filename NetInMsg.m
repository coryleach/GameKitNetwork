//
//  NetInMsg.m
//  NekoLogic
//
//  Created by Cory on 10/08/22.
//  Copyright 2010 Cory R. Leach. All rights reserved.
//

#import "NetInMsg.h"


@implementation NetInMsg

@synthesize data;
@synthesize header;

- (id) initWithData:(NSData *)aData {
	
	if ( (self = [super init]) != nil ) {
		
		NSAssert(aData.length >= sizeof(NetPacketHeader), @"Message Must Be At Least sizeof(NetPacketHeader) Bytes Long!");
		
		//Init
		data = aData;
		[data retain];
		
		header = (NetPacketHeader*)[data bytes];
		
		//Reset Read Location
		[self reset];
		
	}
	
	return self;
	
}

- (void) dealloc {
	
	[data release];
	data = nil;
	
	header = NULL;
	
	[super dealloc];
	
}

- (void) reset {
	range.location = sizeof(NetPacketHeader);
}

- (NetworkHandlerID) handlerId {
	return header->handler;
}

- (uint8_t) type {
	return header->type;
}

- (uint16_t) size {
	return header->size;
}

//8-bit
- (uint8_t) readUint8 {

	uint8_t value;
	range.length = sizeof(value);
	[data getBytes:&value range:range];
	range.location += sizeof(value);
	
	return value;
	
}

- (int8_t) readInt8 {

	int8_t value;
	range.length = sizeof(value);
	[data getBytes:&value range:range];
	range.location += sizeof(value);
	
	return value;

}

//16-bit
- (uint16_t) readUint16 {

	uint16_t value;
	range.length = sizeof(value);
	[data getBytes:&value range:range];
	range.location += sizeof(value);
	
	return value;
	
}

- (int16_t) readInt16 {
	
	int16_t value;
	range.length = sizeof(value);
	[data getBytes:&value range:range];
	range.location += sizeof(value);
	
	return value;
	
}

//32-bit
- (uint32_t) readUint32 {
	
	uint32_t value;
	range.length = sizeof(value);
	[data getBytes:&value range:range];
	range.location += sizeof(value);
	
	return value;
	
}

- (int32_t) readInt32 {

	int32_t value;
	range.length = sizeof(value);
	[data getBytes:&value range:range];
	range.location += sizeof(value);
	
	return value;

}	

//Other
- (float) readFloat {

	float value;
	range.length = sizeof(value);
	[data getBytes:&value range:range];
	range.location += sizeof(value);
	
	return value;
	
}

- (NSString*) readString {

	uint32_t size = [self readUint32];
	range.length = size;
	NSString* string = [[[NSString alloc] initWithData:[data subdataWithRange:range] encoding:NSUTF32BigEndianStringEncoding] autorelease];
	range.location += size;
	
	return string;
	
}

//Raw Buffer
- (void) readBuffer:(void*)buffer bytes:(uint32_t)length {
	
	range.length = length;
	[data getBytes:buffer range:range];
	range.location += range.length;	
	
}

- (void) read32Bit:(void*)buffer {
	
	range.length = 4;
	[data getBytes:buffer range:range];
	range.location += range.length;	
	
}

- (void) read16Bit:(void*)buffer {
	
	range.length = 2;
	[data getBytes:buffer range:range];
	range.location += range.length;	
	
}

- (void) read8Bit:(void*)buffer {
	
	range.length = 1;
	[data getBytes:buffer range:range];
	range.location += range.length;	
	
}

- (NSInteger) bytesRemaining {
	
	return data.length - range.location;
	
}

@end
