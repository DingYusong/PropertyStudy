//
//  DYSPeople.h
//  PropertyStudy
//
//  Created by DingYusong on 2018/11/3.
//  Copyright © 2018 DingYusong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYSPeople : NSObject
@property (nonatomic ,copy) NSString *firstName;
@property (nonatomic ,copy) NSString *lastName;
@property (nonatomic ,assign) NSUInteger legNumber;

@end

NS_ASSUME_NONNULL_END
