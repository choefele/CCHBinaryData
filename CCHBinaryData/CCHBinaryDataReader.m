//
//  BinaryDataReader.m
//  Departures
//
//  Created by Claus Höfele on 23.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHBinaryDataReader.h"

@interface CCHBinaryDataReader()

@property (nonatomic) NSData *data;
@property (nonatomic) const uint8_t *currentPosition;
@property (nonatomic, getter = isLittleEndian) BOOL littleEndian;

@end

@implementation CCHBinaryDataReader

- (instancetype)initWithData:(NSData *)data options:(CCHBinaryDataReaderOptions)options
{
    self = [super init];
    if (self) {
        _data = data;
        _currentPosition = (const uint8_t *)data.bytes;
        _littleEndian = (options & CCHBinaryDataReaderLittleEndian) != 0;
    }
    
    return self;
}

- (void)reset
{
    self.currentPosition = (const uint8_t *)self.data.bytes;
}

- (void)setNumberOfBytesRead:(NSUInteger)numberOfBytes
{
    NSAssert(numberOfBytes <= self.data.length, @"Passed end of data");
    
    self.currentPosition = (const uint8_t *)self.data.bytes + numberOfBytes;
}

- (void)skipNumberOfBytes:(NSUInteger)numberOfBytes
{
    NSAssert([self canReadNumberOfBytes:numberOfBytes], @"Passed end of data");
    
    self.currentPosition += numberOfBytes;
}

- (BOOL)canReadNumberOfBytes:(NSUInteger)numberOfBytes
{
    NSUInteger currentLength = self.currentPosition - (const uint8_t *)self.data.bytes;
    return (currentLength + numberOfBytes <= self.data.length);
}

- (char)readChar
{
    NSAssert(sizeof(char) == 1, @"Invalid size");
    NSAssert([self canReadNumberOfBytes:sizeof(char)], @"Passed end of data");
    
    char value = *((char *)self.currentPosition);
    [self skipNumberOfBytes:sizeof(char)];
    
    return value;
}

- (unsigned char)readUnsignedChar
{
    return (unsigned char)[self readChar];
}

- (short)readShort
{
    NSAssert(sizeof(short) == 2, @"Invalid size");
    NSAssert([self canReadNumberOfBytes:sizeof(short)], @"Passed end of data");

    short value = *((short *)self.currentPosition);
    if (self.isLittleEndian) {
        value = CFSwapInt16LittleToHost(value);
    } else {
        value = CFSwapInt16BigToHost(value);
    }
    [self skipNumberOfBytes:sizeof(short)];
    
    return value;
}

- (unsigned short)readUnsignedShort
{
    return (unsigned short)[self readShort];
}

- (int)readInt
{
    NSAssert(sizeof(int) == 4, @"Invalid size");
    NSAssert([self canReadNumberOfBytes:sizeof(int)], @"Passed end of data");

    int value = *((int *)self.currentPosition);
    if (self.isLittleEndian) {
        value = CFSwapInt32LittleToHost(value);
    } else {
        value = CFSwapInt32BigToHost(value);
    }
    [self skipNumberOfBytes:sizeof(int)];
    
    return value;
}

- (unsigned int)readUnsignedInt
{
    return (unsigned int)[self readInt];
}

- (long long)readLongLong
{
    NSAssert(sizeof(long long) == 8, @"Invalid size");
    NSAssert([self canReadNumberOfBytes:sizeof(long long)], @"Passed end of data");

    long long value = *((long long *)self.currentPosition);
    if (self.isLittleEndian) {
        value = CFSwapInt64LittleToHost(value);
    } else {
        value = CFSwapInt64BigToHost(value);
    }
    [self skipNumberOfBytes:sizeof(long long)];
    
    return value;
}

- (unsigned long long)readUnsignedLongLong
{
    return (unsigned long long)[self readLongLong];
}

- (NSString *)readNullTerminatedStringWithEncoding:(NSStringEncoding)encoding
{
    const uint8_t *start = self.currentPosition;
    while (*self.currentPosition++ != '\0') {
        NSAssert([self canReadNumberOfBytes:0], @"Passed end of data");
    }
    
    NSUInteger numberOfBytes = self.currentPosition - start - 1;
    NSString *result = [[NSString alloc] initWithBytes:(const void *)start length:numberOfBytes encoding:encoding];
    
    return result;
}

- (NSString *)readStringWithNumberOfBytes:(NSUInteger)numberOfBytes encoding:(NSStringEncoding)encoding
{
    NSAssert([self canReadNumberOfBytes:numberOfBytes], @"Passed end of data");
    
    NSString *result = [[NSString alloc] initWithBytes:(const void *)self.currentPosition length:numberOfBytes encoding:encoding];
    [self skipNumberOfBytes:numberOfBytes];
    
    return result;
}

@end
