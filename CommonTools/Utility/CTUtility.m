//
//  CTUtility.m
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

#import "CTUtility.h"
#import <objc/runtime.h>
#import <CoreLocation/CLLocationManager.h>
#import <AddressBook/AddressBook.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@implementation CTUtility

+ (instancetype)getInstance
{
    static id instance;
    static dispatch_once_t predict;
    dispatch_once(&predict, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (id)convertDictionaryToModel:(NSDictionary *)originDict className:(NSString *)className
{
    unsigned int count;
    Class class = NSClassFromString(className);
    id originClass = [[class alloc] init];
    NSMutableDictionary *propertyTypeDict = [[NSMutableDictionary alloc] init];
    NSString *filterPattern = @"T@\"(.+)\"";
    NSError *err = nil;
    NSRegularExpression *filterReg = [NSRegularExpression regularExpressionWithPattern:filterPattern options:NSRegularExpressionCaseInsensitive error:&err]; //过滤条件
    objc_property_t *properties = class_copyPropertyList([originClass class], &count);
    
    //获取模型所有属性的类型
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        const char *getName = property_getName(property);
        NSString *propName = [NSString stringWithUTF8String:getName];
        NSString *propAttributes = [NSString stringWithFormat:@"%s", property_getAttributes(property)]; //如T@"NSNumber",&,N,V_intContentId
        NSArray *matches = [filterReg matchesInString:propAttributes options:NSMatchingReportCompletion range:NSMakeRange(0, propAttributes.length)];
        if (matches.count) {
            //获取属性对应的类型, 并记录下来
            NSString *propType = [propAttributes substringWithRange:[matches[0] rangeAtIndex:1]];
            [propertyTypeDict setValue:propType forKey:propName];
        }
    }
    free(properties);
    
    if (propertyTypeDict.allKeys.count == 0) {
        Class superClass = class_getSuperclass(class);
        id originClass = [[superClass alloc] init];
        objc_property_t *properties = class_copyPropertyList([originClass class], &count);
        
        //获取模型所有属性的类型
        for (int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            const char *getName = property_getName(property);
            NSString *propName = [NSString stringWithUTF8String:getName];
            NSString *propAttributes = [NSString stringWithFormat:@"%s", property_getAttributes(property)]; //如T@"NSNumber",&,N,V_intContentId
            NSArray *matches = [filterReg matchesInString:propAttributes options:NSMatchingReportCompletion range:NSMakeRange(0, propAttributes.length)];
            if (matches.count) {
                //获取属性对应的类型, 并记录下来
                NSString *propType = [propAttributes substringWithRange:[matches[0] rangeAtIndex:1]];
                [propertyTypeDict setValue:propType forKey:propName];
            }
        }
        free(properties);
        
    }
    
    //遍历字典所有关键字
    [[originDict allKeys] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            //系统返回字段为驼峰命名，所以需要
            NSString *fixedPropName = [obj stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[obj substringToIndex:1] uppercaseString]];
            NSString *setMethodStr = [NSString stringWithFormat:@"set%@:", fixedPropName];
            if ([originClass respondsToSelector:NSSelectorFromString(setMethodStr)]) {
                id value = [originDict objectForKey:obj];
                
                NSString *propType = [propertyTypeDict objectForKey:obj];
                if (propType) {
                    if ([propType isEqualToString:@"NSString"]) {
                        if (![value isEqual:[NSNull null]]) {
                            if ([value isKindOfClass:[NSString class]]) {
//                                value = [value stringValue];
                            }
                        } else {
                            value = @"";
                        }
                    } else if ([propType isEqualToString:@"NSNumber"]) {
                        if (![value isEqual:[NSNull null]]) {
                            NSString *valueStr = ((NSNumber *)value).stringValue;
                            if ([valueStr isEqualToString:@"true"]) {
                                value = @(1);
                            } else if ([valueStr isEqualToString:@"false"]) {
                                value = @(0);
                            }
                            value = [NSNumber numberWithDouble:[value doubleValue]];
                        } else {
                            value = [NSNumber numberWithInteger:0];
                        }
                    } else if ([propType isEqualToString:@"NSDictionary"]) {
                        if (![value isKindOfClass:[NSDictionary class]]) {
                            value = nil;
                        }
                    } else if ([propType isEqualToString:@"NSArray"]) {
                        if (![value isKindOfClass:[NSArray class]]) {
                            value = nil;
                        }
                        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
                        for (NSDictionary *arrayDict in value) {
                            NSString *dataClassName = [NSString stringWithFormat:@"%@DataModel", [className substringToIndex:(className.length - 5)]];
                            id dataClass = [self convertDictionaryToModel:arrayDict className:dataClassName];
//                            [CTUtilityNew convertDictionaryToModel:arrayDict className:dataClassName];
                            if (dataClass) {
                                [dataArray addObject:dataClass];
                            }
                        }
                        value = dataArray;
                    }
                }
                
                if ([value isKindOfClass:[NSNull class]]) {
                    value = nil;
                }
                
                SEL selector = NSSelectorFromString(setMethodStr);
                NSMethodSignature *signature = [originClass methodSignatureForSelector:selector];
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                [invocation setArgument:&value atIndex:2]; //index前两个分别被target和selector占用, 从后往前设置，分别是argument, selector, target
                [invocation setSelector:selector];
                [invocation invokeWithTarget:originClass];
            }
        }
    }];
    
    return originClass;
}


+ (BOOL)checkSystemAccess:(RequestSystemAccessType)requestSystemAccessType
{
    switch (requestSystemAccessType) {
        case RequestSystemAccessTypeLocation:
        {
            CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
            if (authStatus == kCLAuthorizationStatusRestricted || authStatus == kCLAuthorizationStatusDenied) {
                [self showAlertView:@"Access Location"];
                return NO;
            }
            return YES;
        }
            break;
        case RequestSystemAccessTypeContacts:
        {
            ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
            if (authStatus == kABAuthorizationStatusRestricted || authStatus == kABAuthorizationStatusDenied) {
                [self showAlertView:@"Access Contacts"];
                return NO;
            } else {
                return YES;
            }
        }
            break;
        case RequestSystemAccessTypePhotos:
        {
            ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
            if (author == kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
                //无权限
                [self showAlertView:@"Access Photos"];
                return NO;
            } else {
                return YES;
            }
        }
            break;
        case RequestSystemAccessTypeMicrophone:
        {
            AVAudioSessionRecordPermission audioPermission = [[AVAudioSession sharedInstance] recordPermission];
            if (audioPermission == AVAudioSessionRecordPermissionDenied)
            {
                //无权限
                [self showAlertView:@"Access Microphone"];
                return NO;
            } else {
                return YES;
            }
        }
            break;
        case RequestSystemAccessTypeCamera:
        {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied)
            {
                //无权限
                [self showAlertView:@"Access Camera"];
                return NO;
            } else {
                return YES;
            }
        }
            break;
            
        default:
            break;
    }
    return NO;
}

+ (void)requestSystemAccess:(RequestSystemAccessType)requestSystemAccessType
{
    switch (requestSystemAccessType) {
        case RequestSystemAccessTypeLocation:
            [self showAlertView:@"Access Location"];
            break;
        case RequestSystemAccessTypeContacts:
            [self showAlertView:@"Access Contacts"];
            break;
        case RequestSystemAccessTypePhotos:
            [self showAlertView:@"Access Photos"];
            break;
        case RequestSystemAccessTypeMicrophone:
            [self showAlertView:@"Access Microphone"];
            break;
        case RequestSystemAccessTypeCamera:
            [self showAlertView:@"Access Camera"];
            break;
            
        default:
            break;
    }
}

+ (void)showAlertView:(NSString *)message
{
    UIAlertController *settingAlertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openURL];
    }];
    [settingAlertController addAction:cancelAction];
    [settingAlertController addAction:okAction];
    if ([CTUtility getInstance].currentTopViewController) {
        [[CTUtility getInstance].currentTopViewController presentViewController:settingAlertController animated:YES completion:nil];
    } else {
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:settingAlertController animated:YES completion:nil];
    }
}

+ (void)openURL
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@", [[NSBundle mainBundle] bundleIdentifier]]];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
