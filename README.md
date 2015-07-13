CCHBinaryData
=============

Utility classes for handling binary data, such as reading various data types from byte buffers.

[![Build Status](https://img.shields.io/travis/choefele/CCHBinaryData.svg)](https://travis-ci.org/choefele/CCHBinaryData)&nbsp;![Version](https://img.shields.io/cocoapods/v/CCHBinaryData.svg)&nbsp;![Platform](http://img.shields.io/cocoapods/p/CCHBinaryData.svg)

See [Releases](https://github.com/choefele/CCHBinaryData/releases) for a high-level overview of recent updates.

Need to talk to a human? [I'm @claushoefele on Twitter](https://twitter.com/claushoefele).

## Installation

Use [CocoaPods](http://cocoapods.org) to integrate `CCHBinaryData` into your project. Minimum deployment targets are 7.0 for iOS and 10.9 for OS X.

```ruby
platform :ios, '7.0'
pod "CCHBinaryData"
```

```ruby
platform :osx, '10.9'
pod "CCHBinaryData"
```

## Reading binary data

`CCHBinaryDataReader` can read various data types from byte buffers provided as `NSData`. The following sample code reads chunk information from a PNG image file:

```Objective-C
    // Read PNG file. Data is big endian, see http://www.w3.org/TR/PNG/#7Integers-and-byte-order
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"pngbar" ofType:@"png"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    CCHBinaryDataReader *binaryDataReader = [[CCHBinaryDataReader alloc] initWithData:data options:CCHBinaryDataReaderBigEndian];
    
    // Skip file signature
    [binaryDataReader setNumberOfBytesRead:8];
    
    // Read chunks, see http://www.w3.org/TR/PNG/#5Chunk-layout
    while ([binaryDataReader canReadNumberOfBytes:4]) {
        unsigned int length = [binaryDataReader readUnsignedInt];
        NSString *chunkType = [binaryDataReader readStringWithNumberOfBytes:4 encoding:NSASCIIStringEncoding];
        [binaryDataReader skipNumberOfBytes:length];
        unsigned int crc = [binaryDataReader readUnsignedInt];
        
        [NSLog(@"%@ length: %tu, crc: 0x%08x\n", chunkType, length, crc];
    }
```
