//
//  QHAppFootprints.h
//  QQHouse
//
//  Created by Tony Tang on 15/5/12.
//
//

#import <Foundation/Foundation.h>


#ifndef LogFootprintConsoleLog
#   define LogFootprintConsoleLog NSLog
#endif

#define LogFootprint(_msg, _info) \
    { static NSString *staticNSStringChekcer = _msg; staticNSStringChekcer; } \
    if (_info) { LogFootprintConsoleLog(@"%@ %@", _msg, _info); } else { LogFootprintConsoleLog(@"%@", _msg); } \
    [QHAppFootprints addFootprint:[QHFootprint footprint:__FILE__ line:__LINE__ message:_msg info:_info]]

@interface QHFootprint : NSObject
+ (instancetype)footprint:(char *)file
                     line:(NSUInteger)line
                  message:(NSString *)message
                     info:(NSString *)info;
@property (nonatomic,   copy) NSString *file;
@property (nonatomic, assign) NSUInteger line;
@property (nonatomic,   copy) NSString *message;            // compile time
@property (nonatomic,   copy) NSString *info;               // runtime info
@end

@interface QHAppFootprints : NSObject
+ (void)addFootprint:(QHFootprint *)footprint;
+ (NSString *)info;
@end
