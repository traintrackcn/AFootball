#import "NSString+KTCommon.h"

unichar convert(unsigned int c);
unichar convert(unsigned int c) {
    if (c < 26) return 'a' + c;
    if (c < 52) return 'A' + c - 26;
    if (c < 62) return '0' + c - 52;
    if (c == 62) return '-';
    return '_';
}

@implementation NSString (KTCommon)

#pragma mark - Generating a UUID

+ (NSString*)stringWithShortenUUID {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFUUIDBytes b = CFUUIDGetUUIDBytes(uuid);
    unichar unichars[22];
    unichar* c = unichars;
    *c++ = convert(b.byte0 >> 2);
    *c++ = convert((b.byte0 & 3 << 4) + (b.byte1 >> 4));
    *c++ = convert((b.byte1 & 15 << 2) + (b.byte2 >> 6));
    *c++ = convert(b.byte2 & 63);
    *c++ = convert(b.byte3 >> 2);
    *c++ = convert((b.byte3 & 3 << 4) + (b.byte4 >> 4));
    *c++ = convert((b.byte4 & 15 << 2) + (b.byte5 >> 6));
    *c++ = convert(b.byte5 & 63);
    *c++ = convert(b.byte6 >> 2);
    *c++ = convert((b.byte6 & 3 << 4) + (b.byte7 >> 4));
    *c++ = convert((b.byte7 & 15 << 2) + (b.byte8 >> 6));
    *c++ = convert(b.byte8 & 63);
    *c++ = convert(b.byte9 >> 2);
    *c++ = convert((b.byte9 & 3 << 4) + (b.byte10 >> 4));
    *c++ = convert((b.byte10 & 15 << 2) + (b.byte11 >> 6));
    *c++ = convert(b.byte11 & 63);
    *c++ = convert(b.byte12 >> 2);
    *c++ = convert((b.byte12 & 3 << 4) + (b.byte13 >> 4));
    *c++ = convert((b.byte13 & 15 << 2) + (b.byte14 >> 6));
    *c++ = convert(b.byte14 & 63);
    *c++ = convert(b.byte15 >> 2);
    *c = convert(b.byte15 & 3);
    CFRelease(uuid);
    return [NSString stringWithCharacters: unichars length: 22];
}

#pragma mark - Compare
- (BOOL)isEmpty {
    return self.length == 0 || [[self trim] length] == 0;
}

- (BOOL)isEqualToStringIgnoringCase:(NSString*)inString {
    return ([self compare:inString options:NSCaseInsensitiveSearch] == NSOrderedSame);
}

- (BOOL)containsString:(NSString*)string {
    return [self containsString:string options:NSCaseInsensitiveSearch];
}

- (BOOL)containsString:(NSString*)string options:(NSStringCompareOptions)options {
    return [self rangeOfString:string options:options].location == NSNotFound ? NO : YES;
}


#pragma mark - Trimming

- (NSString *)trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)stringByTrimmingLeadingAndTrailingCharactersInSet:(NSCharacterSet *)characterSet {
    return [[self stringByTrimmingLeadingCharactersInSet:characterSet]
            stringByTrimmingTrailingCharactersInSet:characterSet];
}

- (NSString *)stringByTrimmingLeadingAndTrailingWhitespaceAndNewlineCharacters {
    return [[self stringByTrimmingLeadingWhitespaceAndNewlineCharacters]
            stringByTrimmingTrailingWhitespaceAndNewlineCharacters];
}

- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet {
    NSRange rangeOfFirstWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]];
    if (rangeOfFirstWantedCharacter.location == NSNotFound) {
        return @"";
    }
    return [self substringFromIndex:rangeOfFirstWantedCharacter.location];
}

- (NSString *)stringByTrimmingLeadingWhitespaceAndNewlineCharacters {
    return [self stringByTrimmingLeadingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet*)characterSet {
    NSRange rangeOfLastWantedCharacter = [self rangeOfCharacterFromSet:[characterSet invertedSet]
                                                               options:NSBackwardsSearch];
    if (rangeOfLastWantedCharacter.location == NSNotFound) {
        return @"";
    }
    return [self substringToIndex:rangeOfLastWantedCharacter.location + 1]; // Non-inclusive
}

- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters {
    return [self stringByTrimmingTrailingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - Replacing

- (NSString *)stringByRemovingCharactersInSet:(NSCharacterSet*) charSet options:(NSUInteger) mask {
    NSRange	range;
    NSMutableString*	newString = [NSMutableString string];
    NSUInteger	len = [self length];
    
    mask &= ~NSBackwardsSearch;
    range = NSMakeRange (0, len);
    while (range.length) {
        NSRange substringRange;
        NSUInteger pos = range.location;
        
        range = [self rangeOfCharacterFromSet:charSet options:mask range:range];
        if (range.location == NSNotFound)
            range = NSMakeRange (len, 0);
        
        substringRange = NSMakeRange (pos, range.location - pos);
        [newString appendString:[self substringWithRange:substringRange]];
        
        range.location += range.length;
        range.length = len - range.location;
    }
    
    return newString;
}

- (NSString *)stringByRemovingCharactersInSet:(NSCharacterSet*) charSet {
    return [self stringByRemovingCharactersInSet:charSet options:0];
}

- (NSString *)stringByRemovingCharacter:(unichar) character {
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithRange:NSMakeRange (character, 1)];
    return [self stringByRemovingCharactersInSet:charSet];
}

- (NSString*)stringByReplacingCharactersInSet:(NSCharacterSet*) charSet withString:(NSString*) substitute {
    NSRange	range;
    NSMutableString*	newString = [NSMutableString string];
    NSUInteger	len = [self length];
    
    range = NSMakeRange (0, len);
    while (range.length) {
        NSRange substringRange;
        NSUInteger pos = range.location;
        
        range = [self rangeOfCharacterFromSet:charSet options:0 range:range];
        if (range.location == NSNotFound)
            range = NSMakeRange (len, 0);
        
        substringRange = NSMakeRange (pos, range.location - pos);
        [newString appendString:[self substringWithRange:substringRange]];
        
        if( range.length > 0 )
            [newString appendString:substitute];
        
        range.location += range.length;
        range.length = len - range.location;
    }
    
    return newString;
}

- (NSString*)stringByCapitalizingFirstCharacter {
    NSMutableString* sc = [self mutableCopy];
    if([self length] > 0 ) {
        [sc replaceCharactersInRange:NSMakeRange(0,1) withString:[[self substringToIndex:1] uppercaseString]];
    }
    return sc;
}

#pragma mark - Truncating
- (NSString*)stringByTruncatingToLength:(int)length {
    return [self stringByTruncatingToLength:length direction:NSTruncateStringPositionEnd];
}

- (NSString*)stringByTruncatingToLength:(int)length direction:(NSTruncateStringPosition)truncateFrom {
    return [self stringByTruncatingToLength:length direction:truncateFrom withEllipsisString:@"..."];
}

- (NSString*)stringByTruncatingToLength:(int)length direction:(NSTruncateStringPosition)truncateFrom withEllipsisString:(NSString*)ellipsis {
    NSMutableString *result = [[NSMutableString alloc] initWithString:self];
    NSString *immutableResult;
    
    if([result length] <= length) {
        return self;
    }
    unsigned int charactersEachSide = length / 2;
    NSString* first;
    NSString* last;
    
    switch(truncateFrom) {
        case NSTruncateStringPositionStart:
            [result insertString:ellipsis atIndex:[result length] - length + [ellipsis length] ];
            immutableResult = [[result substringFromIndex:[result length] - length] copy];
            return immutableResult;
        case NSTruncateStringPositionMiddle:
            first = [result substringToIndex:charactersEachSide - [ellipsis length]+1];
            last = [result substringFromIndex:[result length] - charactersEachSide];
            immutableResult = [[[NSArray arrayWithObjects:first, last, NULL] componentsJoinedByString:ellipsis] copy];
            return immutableResult;
        default:
        case NSTruncateStringPositionEnd:
            [result insertString:ellipsis atIndex:length - [ellipsis length]];
            immutableResult = [[result substringToIndex:length] copy];
            return immutableResult;
    }
}

#pragma mark - Email
- (BOOL)isEmailAddress {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

#pragma mark - File Paths
+ (NSString *)cachesPath {
    static dispatch_once_t onceToken;
    static NSString *cachedPath;
    dispatch_once(&onceToken, ^{
        cachedPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];	
    });
    return cachedPath;
}

+ (NSString *)documentsPath {
    static dispatch_once_t onceToken;
    static NSString *cachedPath;
    dispatch_once(&onceToken, ^{
        cachedPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];	
    });
    return cachedPath;
}

+ (NSString *)temporaryPath {
    static dispatch_once_t onceToken;
    static NSString *cachedPath;
    dispatch_once(&onceToken, ^{
        cachedPath = NSTemporaryDirectory();	
    });
    return cachedPath;
}

+ (NSString *)pathForTemporaryFile {
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    NSString *tmpPath = [[NSString temporaryPath] stringByAppendingPathComponent:(__bridge NSString *)newUniqueIdString];
    CFRelease(newUniqueId);
    CFRelease(newUniqueIdString);
    return tmpPath;
}

#pragma mark - Formatting

+ (NSString *)stringByFormattingBytes:(long long)bytes {
    NSArray *units = [NSArray arrayWithObjects:@"%1.0f Bytes", @"%1.1f kB", @"%1.1f MB", @"%1.1f GB", @"%1.1f TB", nil];
    long long value = bytes * 10;
    for (int i=0; i<[units count]; i++) {
        if (i > 0) {
            value = value/1024;
        }
        if (value < 10000) {
            return [NSString stringWithFormat:[units objectAtIndex:i], value/10.0];
        }
    }
    return [NSString stringWithFormat:[units objectAtIndex:[units count]-1], value/10.0];
}

@end