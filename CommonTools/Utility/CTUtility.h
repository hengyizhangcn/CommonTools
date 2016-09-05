//
//  CTUtility.h
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

#import <Foundation/Foundation.h>/**
*  权限类型
*/
typedef NS_ENUM(NSInteger, RequestSystemAccessType) {
    /**
     *  位置
     */
    RequestSystemAccessTypeLocation,
    /**
     *  通讯录
     */
    RequestSystemAccessTypeContacts,
    /**
     *  照片，相册
     */
    RequestSystemAccessTypePhotos,
    /**
     *  麦克风
     */
    RequestSystemAccessTypeMicrophone,
    /**
     *  相机
     */
    RequestSystemAccessTypeCamera
};

@interface CTUtility : NSObject
/**
 *  当前置顶的控制器，
 * Attention !!!!
 * 如果Alert所在当前的界面是present出来的，需要给此属性赋值，不然显示的层级会不正确
 */
@property (nonatomic, strong) UIViewController *currentTopViewController;

+ (instancetype)getInstance;

/**
 *  把字典转成模型
 *
 *  @param dictionary 字典
 *  @param class      模型对应的类名
 *
 *  @return 类的对象
 */
+ (id)convertDictionaryToModel:(NSDictionary *)originDict className:(NSString *)className;

/**
 *  检测系统权限，并给出设置提示
 *  @param requestSystemAccessType 类型
 *  @return 检测结果
 */
+ (BOOL)checkSystemAccess:(RequestSystemAccessType)requestSystemAccessType;
@end