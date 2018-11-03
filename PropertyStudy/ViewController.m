//
//  ViewController.m
//  PropertyStudy
//
//  Created by DingYusong on 2018/11/3.
//  Copyright © 2018 DingYusong. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController (){
    NSString *_property3;
    NSString *property4Exc;
}
@end




@implementation ViewController

@synthesize property2;
@synthesize property3 = _property3;
@synthesize property4 = property4Exc;
@synthesize property5 = property5Exc;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    unsigned int count;//NSFetchedResultsController
    //获得所有属性
    objc_property_t *propertys = class_copyPropertyList([self class], &count);

    for (int i = 0; i < count; i++) {
        objc_property_t property = propertys[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:name];
        NSLog(@"propertyName %d:%@",i+1,propertyName);
    }
    free(propertys);

    //获得所有成员变量
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


@end
