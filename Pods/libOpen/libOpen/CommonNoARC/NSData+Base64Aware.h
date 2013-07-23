//
//  NSData+Base64Aware.h
//  DirectSale
//
//  Created by Sean Guo on 7/17/12.
//  Copyright (c) 2012 Voxeo. All rights reserved.
//

#import <Foundation/Foundation.h>

void *NewBase64Decode(const char *inputBuffer,
                      size_t length,
                      size_t *outputLength);

char *NewBase64Encode(const void *inputBuffer,
                      size_t length,
                      bool separateLines,
                      size_t *outputLength);

@interface NSData (Base64Aware)

+ (NSData*)dataFromBase64String:(NSString *)aString;
- (NSString*)base64EncodedString;

@end
