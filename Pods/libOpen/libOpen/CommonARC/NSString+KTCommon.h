#import <Foundation/Foundation.h>

enum {
    NSTruncateStringPositionStart=0,
    NSTruncateStringPositionMiddle,
    NSTruncateStringPositionEnd
}; typedef int NSTruncateStringPosition;

@interface NSString (KTCommon)

+ (NSString*)stringWithShortenUUID;


- (BOOL)isEmpty;
- (BOOL)isEqualToStringIgnoringCase:(NSString*)inString;
- (BOOL)containsString:(NSString*)string;
- (BOOL)containsString:(NSString*)string options:(NSStringCompareOptions)options;

- (NSString*)trim;
- (NSString*)stringByTrimmingLeadingAndTrailingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString*)stringByTrimmingLeadingAndTrailingWhitespaceAndNewlineCharacters;
- (NSString*)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString*)stringByTrimmingLeadingWhitespaceAndNewlineCharacters;
- (NSString*)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString*)stringByTrimmingTrailingWhitespaceAndNewlineCharacters;

- (NSString*)stringByRemovingCharactersInSet:(NSCharacterSet*) charSet options:(NSUInteger) mask;
- (NSString*)stringByRemovingCharactersInSet:(NSCharacterSet*) charSet;
- (NSString*)stringByRemovingCharacter:(unichar) character;
- (NSString*)stringByReplacingCharactersInSet:(NSCharacterSet*) charSet withString:(NSString*) substitute;
- (NSString*)stringByCapitalizingFirstCharacter;

- (NSString*)stringByTruncatingToLength:(int)length;
- (NSString*)stringByTruncatingToLength:(int)length direction:(NSTruncateStringPosition)truncateFrom;
- (NSString*)stringByTruncatingToLength:(int)length direction:(NSTruncateStringPosition)truncateFrom withEllipsisString:(NSString*)ellipsis;

- (BOOL)isEmailAddress;

+ (NSString *)cachesPath;
+ (NSString *)documentsPath;
+ (NSString *)temporaryPath;
+ (NSString *)pathForTemporaryFile;

#pragma mark - Formatting

+ (NSString *)stringByFormattingBytes:(long long)bytes;
@end