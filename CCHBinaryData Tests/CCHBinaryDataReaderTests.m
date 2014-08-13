//
//  CCHBinaryDataReaderTests.m
//  Departures
//
//  Created by Claus Höfele on 27.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "CCHBinaryDataReader.h"

@interface CCHBinaryDataReaderTests : XCTestCase

@end

@implementation CCHBinaryDataReaderTests

+ (CCHBinaryDataReader *)binaryDataReaderWithFileName:(NSString *)fileName options:(CCHBinaryDataReaderOptions)options
{
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *filePath = [bundle pathForResource:fileName ofType:@"bin"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    CCHBinaryDataReader *binaryDataReader = [[CCHBinaryDataReader alloc] initWithData:data options:options];
    
    return binaryDataReader;
}

- (void)testReset
{
    CCHBinaryDataReader *binaryDataReader = [self.class binaryDataReaderWithFileName:@"bigendian" options:0];
    
    [binaryDataReader skipNumberOfBytes:7];
    XCTAssertEqual([binaryDataReader readUnsignedShort], 11780);
    
    [binaryDataReader reset];
    XCTAssertEqual([binaryDataReader readChar], 12);
}

- (void)testSkipNumberOfBytes
{
    CCHBinaryDataReader *binaryDataReader = [self.class binaryDataReaderWithFileName:@"bigendian" options:0];

    [binaryDataReader skipNumberOfBytes:7];
    XCTAssertEqual([binaryDataReader readUnsignedShort], 11780);
    
    [binaryDataReader skipNumberOfBytes:9];
    XCTAssertEqual([binaryDataReader readUnsignedInt], 2662465724);
}

- (void)testSetNumberOfBytesRead
{
    CCHBinaryDataReader *binaryDataReader = [self.class binaryDataReaderWithFileName:@"bigendian" options:0];
    
    [binaryDataReader setNumberOfBytesRead:7];
    XCTAssertEqual([binaryDataReader readUnsignedShort], 11780);
    
    [binaryDataReader setNumberOfBytesRead:18];
    XCTAssertEqual([binaryDataReader readUnsignedInt], 2662465724);
}

- (void)testCanReadNumberOfBytes
{
    CCHBinaryDataReader *binaryDataReader = [self.class binaryDataReaderWithFileName:@"bigendian" options:0];
    
    XCTAssertTrue([binaryDataReader canReadNumberOfBytes:1]);
    [binaryDataReader setNumberOfBytesRead:binaryDataReader.data.length - 1];
    XCTAssertTrue([binaryDataReader canReadNumberOfBytes:1]);
    [binaryDataReader setNumberOfBytesRead:binaryDataReader.data.length];
    XCTAssertFalse([binaryDataReader canReadNumberOfBytes:1]);
    
    [binaryDataReader reset];
    [binaryDataReader skipNumberOfBytes:binaryDataReader.data.length];
    XCTAssertFalse([binaryDataReader canReadNumberOfBytes:1]);
}

- (void)testBigEndian
{
    CCHBinaryDataReader *binaryDataReader = [self.class binaryDataReaderWithFileName:@"bigendian" options:0];
    
    XCTAssertEqual([binaryDataReader readChar], 12);
    XCTAssertEqual([binaryDataReader readChar], -12);

    XCTAssertEqual([binaryDataReader readUnsignedChar], 12u);
    XCTAssertEqual([binaryDataReader readUnsignedChar], 244u);

    XCTAssertEqual([binaryDataReader readShort], 1234);
    XCTAssertEqual([binaryDataReader readShort], -1234);
    
    XCTAssertEqual([binaryDataReader readUnsignedShort], 1234u);
    XCTAssertEqual([binaryDataReader readUnsignedShort], 64302u);
    
    XCTAssertEqual([binaryDataReader readInt], 12345678);
    XCTAssertEqual([binaryDataReader readInt], -12345678);
    
    XCTAssertEqual([binaryDataReader readUnsignedInt], 12345678u);
    XCTAssertEqual([binaryDataReader readUnsignedInt], 4282621618u);

    XCTAssertEqual([binaryDataReader readLongLong], 12345678901234ll);
    XCTAssertEqual([binaryDataReader readLongLong], -12345678901234ll);
    
    XCTAssertEqual([binaryDataReader readUnsignedLongLong], 12345678901234llu);
    XCTAssertEqual([binaryDataReader readUnsignedLongLong], 18446731728030650382llu);
}

- (void)testLittleEndian
{
    CCHBinaryDataReader *binaryDataReader = [self.class binaryDataReaderWithFileName:@"littleendian" options:CCHBinaryDataReaderLittleEndian];
    
    XCTAssertEqual([binaryDataReader readChar], 12);
    XCTAssertEqual([binaryDataReader readChar], -12);
    
    XCTAssertEqual([binaryDataReader readUnsignedChar], 12u);
    XCTAssertEqual([binaryDataReader readUnsignedChar], 244u);
    
    XCTAssertEqual([binaryDataReader readShort], 1234);
    XCTAssertEqual([binaryDataReader readShort], -1234);
    
    XCTAssertEqual([binaryDataReader readUnsignedShort], 1234u);
    XCTAssertEqual([binaryDataReader readUnsignedShort], 64302u);
    
    XCTAssertEqual([binaryDataReader readInt], 12345678);
    XCTAssertEqual([binaryDataReader readInt], -12345678);
    
    XCTAssertEqual([binaryDataReader readUnsignedInt], 12345678u);
    XCTAssertEqual([binaryDataReader readUnsignedInt], 4282621618u);
    
    XCTAssertEqual([binaryDataReader readLongLong], 12345678901234ll);
    XCTAssertEqual([binaryDataReader readLongLong], -12345678901234ll);
    
    XCTAssertEqual([binaryDataReader readUnsignedLongLong], 12345678901234llu);
    XCTAssertEqual([binaryDataReader readUnsignedLongLong], 18446731728030650382llu);
}

- (void)testReadNullTerminatedString
{
    CCHBinaryDataReader *binaryDataReader = [self.class binaryDataReaderWithFileName:@"iso8859-1" options:0];

    NSString *string = [binaryDataReader readNullTerminatedStringWithEncoding:NSISOLatin1StringEncoding];
    XCTAssertEqualObjects(string, @"abcdefäöüß");

    string = [binaryDataReader readNullTerminatedStringWithEncoding:NSISOLatin1StringEncoding];
    XCTAssertEqualObjects(string, @"hello");
}

- (void)testReadString
{
    CCHBinaryDataReader *binaryDataReader = [self.class binaryDataReaderWithFileName:@"iso8859-1" options:0];
    
    NSString *string = [binaryDataReader readStringWithNumberOfBytes:10 encoding:NSISOLatin1StringEncoding];
    XCTAssertEqualObjects(string, @"abcdefäöüß");
    
    [binaryDataReader skipNumberOfBytes:1]; // '\0'
    string = [binaryDataReader readStringWithNumberOfBytes:5 encoding:NSISOLatin1StringEncoding];
    XCTAssertEqualObjects(string, @"hello");
}

- (void)testEmptyString
{
    CCHBinaryDataReader *binaryDataReader = [self.class binaryDataReaderWithFileName:@"iso8859-1" options:0];
    [binaryDataReader skipNumberOfBytes:binaryDataReader.data.length - 1];
    
    NSString *string = [binaryDataReader readNullTerminatedStringWithEncoding:NSISOLatin1StringEncoding];
    XCTAssertEqualObjects(string, @"");
}

@end
