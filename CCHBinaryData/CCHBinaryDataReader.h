//
//  BinaryDataReader.h
//  Departures
//
//  Created by Claus Höfele on 23.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, CCHBinaryDataReaderOptions) {
    CCHBinaryDataReaderLittleEndian = (1UL << 0)
};

@interface CCHBinaryDataReader : NSObject

@property (nonatomic, readonly) NSData *data;
@property (nonatomic, readonly) const uint8_t *currentPosition;
@property (nonatomic, getter = isLittleEndian, readonly) BOOL littleEndian;

- (instancetype)initWithData:(NSData *)data options:(CCHBinaryDataReaderOptions)options NS_DESIGNATED_INITIALIZER;

- (void)reset;
- (void)setNumberOfBytesRead:(NSUInteger)numberOfBytes;
- (void)skipNumberOfBytes:(NSUInteger)numberOfBytes;
- (BOOL)canReadNumberOfBytes:(NSUInteger)numberOfBytes;

- (char)readChar;
- (unsigned char)readUnsignedChar;
- (short)readShort;
- (unsigned short)readUnsignedShort;
- (int)readInt;
- (unsigned int)readUnsignedInt;
- (long long)readLongLong;
- (unsigned long long)readUnsignedLongLong;

- (NSString *)readNullTerminatedStringWithEncoding:(NSStringEncoding)encoding;
- (NSString *)readStringWithNumberOfBytes:(NSUInteger)numberOfBytes encoding:(NSStringEncoding)encoding;

@end
