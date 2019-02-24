//
//  CBTimeUtils.m
//  CBAudioPlayer
//
//  Created by FrancisKevin on 2019/2/20.
//  Copyright © 2019年 KF. All rights reserved.
//

#import "CBTimeUtils.h"

@implementation CBTimeUtils

+ (NSString *)mmssWithSeconds:(NSTimeInterval)seconds {
    if (seconds <= 0) {
        return @"0:00";
    }
    
    NSInteger newSeconds = (NSInteger)seconds;
    
    if (newSeconds < 10) {
        return [NSString stringWithFormat:@"0:0%ld", newSeconds];
    } else if (newSeconds < 60) {
        return [NSString stringWithFormat:@"0:%ld", newSeconds];
    } else {
        NSInteger mm = (NSInteger)(newSeconds / 60);
        NSTimeInterval ss = newSeconds - mm * 60.0f;
        if (ss < 10) {
            return [NSString stringWithFormat:@"%ld:0%.0f", mm, ss];
        } else {
            return [NSString stringWithFormat:@"%ld:%.0f", mm, ss];
        }
    }
}

@end
