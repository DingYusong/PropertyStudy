//
//  ViewController.m
//  PropertyStudy
//
//  Created by DingYusong on 2018/11/3.
//  Copyright © 2018 DingYusong. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "DYSDog.h"
#import "DYSDisableDog.h"

@interface ViewController (){
    NSString *_property3;
    NSString *property4Exc;
    NSString *ivar8;
}

@property (nonatomic ,copy) NSString *property6;

@end

/*
 当你想手动管理 @property 的所有内容时，你就会尝试通过实现 @property 的所有“存取方法”（the accessor methods,复写存取方法）或者使用 @dynamic 来达到这个目的，这时编译器就会认为你打算手动管理 @property，于是编译器就禁用了 autosynthesis（自动合成）。
 */



@implementation ViewController
//synthesize合成的意思，如果不写是autosynthesize，自动合成。
@synthesize property2;
@synthesize property3 = _property3;
@synthesize property4 = property4Exc;
@synthesize property5 = property5Exc;

@synthesize property10;

//Property 'property2' is already implemented
//@dynamic property2;


/**
    dynamic 是动态的意思，使用dynamic则表示，不会自动生成成员变量，同时不能用@synthesize，需要自己重写set和get方法。如果不重写，则使用点语法时会报错。
    使用dynamic的时候ivar少了_property1，method 少了property1和setProperty1两个方法。如果不重写set和get方法，则点语法会报错。
 */
//@dynamic property1;
@dynamic property9;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dys_propertyOfIvar];
    [self dys_propertyOfMethod];
    [self dys_propertyOfDynamic];
    
}

#pragma mark - Ivar

- (void)setProperty7:(NSString *)property7{
}
- (NSString *)property7{
    return @"property7";
}

-(NSString *)property8{
    return @"property8";
}

- (void)dys_propertyOfIvar{
    
    
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
    unsigned int ivarCount;
    Ivar *ivars = class_copyIvarList([self class], &ivarCount);
    for (int i = 0; i < ivarCount; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        
        NSLog(@"ivar %d:%@",i+1,key);
    }
    free(ivars);
    
    // Do any additional setup after loading the view, typically from a nib.
    
    /**
     属性有如下几个特性：
     1.使用了属性(property)的话，会自动生成对应的名为属性名加下划线的实例变量(ivar)，私有属性也一样。
     例如属性：property1自动给生成_property1的成员变量，私有属性property6自动给生成_property6的成员变量
     2.使用了@synthesize 但是没有指定成员变量名，则会生成一个同名的成员变量;
     例如：@synthesize property2;自动为属性property2生成了一个同名的ivar，property2。
     3.如果使用@synthesize指定了一个成员变量名，无论是否和系统的默认一样加下划线，如果这个成员变量存在则不再生成，如果不存在则自动生成一个指定名称的成员变量。
     例如：@synthesize property3 = _property3;和系统生成名规则一样，且_property3存在则不再生成。
     @synthesize property4 = property4Exc;和系统生成名规则不一样，且property4Exc存在则不再生成。
     @synthesize property5 = property5Exc;和系统生成名规则不一样，且property5Exc不存在则自动生成一个property5Exc。
     
     4.成员变量不必和属性一一匹配。
     例如：ivar7 和 ivar8，就只是纯粹的成员变量，没有对应的属性。
     
     5.当你同时重写了 setter 和 getter 时，系统就不会生成 ivar（实例变量/成员变量）
     例如：property7 就没有自动生成对应的_property7 的实例变量。
     
     6.重写了只读属性的 getter 时,系统就不会生成 ivar（实例变量/成员变量）
     例如：property8 是只读属性，且重写了-(NSString *)property8 方法， 就没有自动生成对应的_property8 的实例变量。想想也没有必要。
     
     7.使用了 @dynamic 时,系统就不会生成 ivar（实例变量/成员变量）和set，get方法。
     例如：property9
     
     8.在 @protocol 中定义的所有属性需要手动@synthesize 手动合成
     例如：ViewControllerProtol中定义的，如果遵循ViewControllerProtol，则必须手动合成property10，否则会报警告，手动合成后不仅会生成相应的变量，还会生成相应的存取方法。
     2018-11-03 21:24:58.219481+0800 PropertyStudy[13133:663785] ivar 7:property10
     2018-11-03 21:24:58.220286+0800 PropertyStudy[13133:663785] method 4:property10
     2018-11-03 21:24:58.220517+0800 PropertyStudy[13133:663785] method 5:setProperty10:
     2018-11-03 21:24:58.206794+0800 PropertyStudy[13133:663785] propertyName 14:property10

     9.在 category 中定义的所有属性，需要@dynamic
     例如：ViewController (DYSDefaultCategory)中定义的property11，必须使用@dynamic property11; 手动实现其set和get方法。
     
     10.重载的属性。
     当你在子类中重载了父类中的属性，你必须 使用 @synthesize 来手动合成ivar。否则默认使用父类定义的ivar。
     例如：子类DYSDisableDog的legnumber属性需要重载父类DYSDog的legnumber，因为是特殊情况，所以需要手动合成ivar来重载父类属性。
     
     
     打印结果如下：
     2018-11-03 20:18:11.386887+0800 PropertyStudy[11778:592871] propertyName 1:property6
     2018-11-03 20:18:11.387066+0800 PropertyStudy[11778:592871] propertyName 2:property1
     2018-11-03 20:18:11.387172+0800 PropertyStudy[11778:592871] propertyName 3:property2
     2018-11-03 20:18:11.387277+0800 PropertyStudy[11778:592871] propertyName 4:property3
     2018-11-03 20:18:11.387370+0800 PropertyStudy[11778:592871] propertyName 5:property4
     2018-11-03 20:18:11.387471+0800 PropertyStudy[11778:592871] propertyName 6:property5
     2018-11-03 20:18:11.387471+0800 PropertyStudy[11778:592871] propertyName 6:property7
     2018-11-03 20:18:11.387585+0800 PropertyStudy[11778:592871] ivar 1:ivar7
     2018-11-03 20:18:11.387683+0800 PropertyStudy[11778:592871] ivar 2:_property3
     2018-11-03 20:18:11.387786+0800 PropertyStudy[11778:592871] ivar 3:property4Exc
     2018-11-03 20:18:11.387915+0800 PropertyStudy[11778:592871] ivar 4:ivar8
     2018-11-03 20:18:11.388011+0800 PropertyStudy[11778:592871] ivar 5:property2
     2018-11-03 20:18:11.388110+0800 PropertyStudy[11778:592871] ivar 6:property5Exc
     2018-11-03 20:18:11.388337+0800 PropertyStudy[11778:592871] ivar 7:_property1
     2018-11-03 20:18:11.388572+0800 PropertyStudy[11778:592871] ivar 8:_property6
     */

}

- (void)dys_propertyOfMethod{
    unsigned int count;
    Method *methods = class_copyMethodList([self class], &count);
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        SEL methodSEL = method_getName(method);
        const char *name = sel_getName(methodSEL);
        NSString *methodName = [NSString stringWithUTF8String:name];
//        int arguments = method_getNumberOfArguments(method);
        NSLog(@"method %d:%@",i+1,methodName);
    }
    free(methods);
    
    /*
     不指定dynamic 情况下回自动生成相应的set和get方法。
     
     结果打印如下：
     2018-11-03 20:45:50.530035+0800 PropertyStudy[12323:620474] method 1:yyi_propertyOfMethod
     2018-11-03 20:45:50.530241+0800 PropertyStudy[12323:620474] method 2:property2
     2018-11-03 20:45:50.530464+0800 PropertyStudy[12323:620474] method 3:setProperty2:
     2018-11-03 20:45:50.535659+0800 PropertyStudy[12323:620474] method 4:property3
     2018-11-03 20:45:50.535790+0800 PropertyStudy[12323:620474] method 5:setProperty3:
     2018-11-03 20:45:50.535890+0800 PropertyStudy[12323:620474] method 6:property4
     2018-11-03 20:45:50.535980+0800 PropertyStudy[12323:620474] method 7:setProperty4:
     2018-11-03 20:45:50.536069+0800 PropertyStudy[12323:620474] method 8:property5
     2018-11-03 20:45:50.536153+0800 PropertyStudy[12323:620474] method 9:setProperty5:
     2018-11-03 20:45:50.536298+0800 PropertyStudy[12323:620474] method 10:property1
     2018-11-03 20:45:50.536420+0800 PropertyStudy[12323:620474] method 11:setProperty1:
     2018-11-03 20:45:50.536525+0800 PropertyStudy[12323:620474] method 12:property6
     2018-11-03 20:45:50.536620+0800 PropertyStudy[12323:620474] method 13:setProperty6:
     2018-11-03 20:45:50.536751+0800 PropertyStudy[12323:620474] method 14:.cxx_destruct
     2018-11-03 20:45:50.537048+0800 PropertyStudy[12323:620474] method 15:viewDidLoad

     */

}

- (void)dys_propertyOfDynamic{
    DYSDog *dog = [DYSDog new];
    dog.firstName = @"丁";
    //dog.lastName = @"玉松";
    //2018-11-03 21:05:34.512467+0800 PropertyStudy[12700:641940] -[DYSDog setLastName:]: unrecognized selector sent to instance 0x600003a64b40
    //2018-11-03 21:05:34.592585+0800 PropertyStudy[12700:641940] *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[DYSDog setLastName:]: unrecognized selector sent to instance 0x600003a64b40'
    //lastName 使用了dynamic 需要复写setLastName 和 lastName ，否则点语法使用时就会报错。
 
    NSLog(@"dog.legNumber:%ld",dog.legNumber);

    DYSDisableDog *dog2 = [DYSDisableDog new];
    NSLog(@"dog2.legNumber:%ld",dog2.legNumber);
    
}



@end


@implementation ViewController (DYSDefaultCategory)

@dynamic property11;
-(NSString *)property11{
    return @"property11";
}
-(void)setProperty11:(NSString *)property11{
}

@end
