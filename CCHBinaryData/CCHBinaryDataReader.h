//
//  BinaryDataReader.h
//  Departures
//
//  Created by Claus Höfele on 23.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Options for changing the behavior of this class. */
typedef NS_OPTIONS(NSUInteger, CCHBinaryDataReaderOptions) {
    CCHBinaryDataReaderLittleEndian = (1UL << 0)    /// Changes mode to little endian (default: big endian)
};

/**
 Reads data from binary input.
 */
@interface CCHBinaryDataReader : NSObject

/** Binary data used for reading. */
@property (nonatomic, readonly) NSData *data;
/** Current reading position. */
@property (nonatomic, readonly) const uint8_t *currentPosition;
/** Endianess of multi-byte values. */
@property (nonatomic, getter = isLittleEndian, readonly) BOOL littleEndian;

/**
 Initializes this class with data to read and options.
 @param data data to read
 @param options changes behavior of this class
 */
- (instancetype)initWithData:(NSData *)data options:(CCHBinaryDataReaderOptions)options NS_DESIGNATED_INITIALIZER;

/**
 Resets the reading position to the begin of the data.
 */
- (void)reset;

/**
 Sets the current reading position.
 @param numberOfBytes number of bytes relative to the begin of the data
 */
- (void)setNumberOfBytesRead:(NSUInteger)numberOfBytes;

/**
 Advances the current reading position by the given number of bytes.
 @param numberOfBytes number of bytes relative to the current reading position
 */
- (void)skipNumberOfBytes:(NSUInteger)numberOfBytes;

/**
 Checks if the given number of bytes can be read.
 @param numberOfBytes number of bytes to read
 @return YES if the given number of bytes can be read
 */
- (BOOL)canReadNumberOfBytes:(NSUInteger)numberOfBytes;

/** Reads data and advances the current position by one byte. */
- (char)readChar;
/** Reads unsigned data and advances the current position by one byte. */
- (unsigned char)readUnsignedChar;

/** Reads data and advances the current position by two bytes. */
- (short)readShort;
/** Reads unsigned data and advances the current position by two bytes. */
- (unsigned short)readUnsignedShort;

/** Reads data and advances the current position by four bytes. */
- (int)readInt;
/** Reads unsigned data and advances the current position by four bytes. */
- (unsigned int)readUnsignedInt;

/** Reads data and advances the current position by eight bytes. */
- (long long)readLongLong;
/** Reads unsigned data and advances the current position by eight bytes. */
- (unsigned long long)readUnsignedLongLong;

/**
 Reads a string with the given encoding until the value '\0' is encountered.
 @param encoding string encoding
 @return string
 */
- (NSString *)readNullTerminatedStringWithEncoding:(NSStringEncoding)encoding;

/**
 Reads a string with the given byte-length and encoding.
 @param numberOfBytes number of bytes (not characters)
 @param encoding string encoding
 @return string
 */
- (NSString *)readStringWithNumberOfBytes:(NSUInteger)numberOfBytes encoding:(NSStringEncoding)encoding;

@end
