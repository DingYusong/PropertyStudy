//
//  ViewController.h
//  PropertyStudy
//
//  Created by DingYusong on 2018/11/3.
//  Copyright © 2018 DingYusong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewControllerProtol <NSObject>

@property (nonatomic ,copy) NSString *property10;

@end

@interface ViewController : UIViewController<ViewControllerProtol>
{
    NSString *ivar7;
}
@property (nonatomic ,copy) NSString *property1;
@property (nonatomic ,copy) NSString *property2;
@property (nonatomic ,copy) NSString *property3;
@property (nonatomic ,copy) NSString *property4;
@property (nonatomic ,copy) NSString *property5;
@property (nonatomic ,copy) NSString *property7;
@property (nonatomic , readonly,copy) NSString *property8;
@property (nonatomic ,copy) NSString *property9;

@end



@interface ViewController (DYSDefaultCategory)
//{
//    NSString *_property11;
//}
//Instance variables may not be placed in categories 实例变量不能再类别中声明，属性是 set+get+ivar，因为没有ivar所以说类别中不能添加属性。但是可以形式上添加属性，通过associate object 代替ivar添加到set，get方法中来模拟属性的存在。

@property (nonatomic ,copy) NSString *property11;

@end
