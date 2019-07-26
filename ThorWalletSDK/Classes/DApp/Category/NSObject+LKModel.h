

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN




@interface NSObject (LKModel)

- (void)setNilValueForKey:(NSString *)key;

- (id)valueForUndefinedKey:(NSString *)key;

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
