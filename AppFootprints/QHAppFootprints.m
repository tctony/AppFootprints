//
//  QHAppFootprints.m
//  QQHouse
//
//  Created by Tony Tang on 15/5/12.
//
//

#import "QHAppFootprints.h"
#import "FootprintMap.h"

@implementation QHFootprint
+ (instancetype)footprint:(char *)file
                     line:(NSUInteger)line
                  message:(NSString *)message
                     info:(NSString *)info
{
    QHFootprint *instance = [[QHFootprint alloc] init];
    instance.file  = [NSString stringWithUTF8String:file];
    instance.line = line;
    instance.message = message;
    instance.info = info;
    return instance;
}
@end

static NSTimeInterval appStartTime = 0;
static NSMutableArray *appFootprints = nil;
static NSLock *lock = nil;

@implementation QHAppFootprints

+ (void)initialize
{
    [self start];
}

+ (void)start
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appStartTime = [[NSDate date] timeIntervalSince1970];
        appFootprints = [NSMutableArray array];
        lock = [[NSLock alloc] init];
    });
}

+ (void)addFootprint:(QHFootprint *)footprint
{
    if (!footprint) { return; }
    
    [lock lock];
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSString *time = [NSString stringWithFormat:@"%.3f", now - appStartTime];
    [appFootprints addObject:@[ time, footprint]];
    [lock unlock];
}

+ (NSString *)info
{
    NSMutableString *string = [NSMutableString string];
    [string appendFormat:@"%.3f", appStartTime];
    
    [lock lock];
    for (NSArray *array in appFootprints) {
        if (![array isKindOfClass:[NSArray class]]
            || [array count] < 2) {
            continue;
        }
        NSString *time = array[0];
        QHFootprint *footprint = array[1];
        if (![time isKindOfClass:[NSString class]]
            || ![footprint isKindOfClass:[QHFootprint class]]) {
            continue;
        }
        
        NSString *footprintCode = [FootprintMap footprintCodeForLine:footprint.line
                                                              inFile:footprint.file];
        [string appendFormat:@"_%@,%@,", time, footprintCode];
        if (footprint.info && footprint.info.length > 0) {
            [string appendFormat:@"%@", [self encodeString:footprint.info]];
        }
    }
    [lock unlock];
    
    NSTimeInterval crashTime = [[NSDate date] timeIntervalSince1970];
    [string appendFormat:@"_%.3f", crashTime - appStartTime];
    
    return [NSString stringWithFormat:@"%@:%@", FootprintMapSignature, string];
}

+ (NSString *)encodeString:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"_" withString:@"\\-"];
    string = [string stringByReplacingOccurrencesOfString:@"," withString:@"\\'"];
    return string;
}

@end
