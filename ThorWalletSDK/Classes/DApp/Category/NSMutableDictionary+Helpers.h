
#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Helpers)
- (void)setValueIfNotNil:(id)value forKey:(NSString *)key;

- (void)setStringIfNotEmpty:(NSString *)str forKey:(NSString *)key;

- (void)setDataBaseValue:(id)value forKey:(NSString *)key;
- (void)setEmptyStringIfNil:(id)value forKey:(NSString*)key;
@end
