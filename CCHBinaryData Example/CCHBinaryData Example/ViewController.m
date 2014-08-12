//
//  ViewController.m
//  CCHBinaryData Example
//
//  Created by Claus Höfele on 12.08.14.
//  Copyright (c) 2014 Claus Höfele. All rights reserved.
//

#import "ViewController.h"

#import "CCHBinaryDataReader.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController
            
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Read PNG file. Data is big endian, see http://www.w3.org/TR/PNG/#7Integers-and-byte-order
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"pngbar" ofType:@"png"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    CCHBinaryDataReader *binaryDataReader = [[CCHBinaryDataReader alloc] initWithData:data options:0];
    
    // Skip file signature
    [binaryDataReader setNumberOfBytesRead:8];
    
    // Read chunks, see http://www.w3.org/TR/PNG/#5Chunk-layout
    NSMutableString *text = [NSMutableString stringWithString:@"Chunks:\n\n"];
    while ([binaryDataReader canReadNumberOfBytes:4]) {
        unsigned int length = [binaryDataReader readUnsignedInt];
        NSString *chunkType = [binaryDataReader readStringWithNumberOfBytes:4 encoding:NSASCIIStringEncoding];
        [binaryDataReader skipNumberOfBytes:length];
        unsigned int crc = [binaryDataReader readUnsignedInt];
        
        [text appendFormat:@"%@ length: %tu, crc: 0x%08x\n", chunkType, length, crc];
    }
    
    self.textView.text = text;
}

@end
