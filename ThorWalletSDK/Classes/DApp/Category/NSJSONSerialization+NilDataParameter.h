
#import <Foundation/Foundation.h>

@interface NSJSONSerialization (NilDataParameter)

+ (id)JSONObjectWithDataMayBeNil:(NSData *)data
                         options:(NSJSONReadingOptions)opt
                           error:(NSError *__autoreleasing *)error;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end
