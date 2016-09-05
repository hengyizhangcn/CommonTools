//
//  CTBaseRequest.h
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTNetworkEngine.h"

@interface CTBaseRequest : NSObject

/**
 *  请求参数
 */
@property (nonatomic, strong) NSMutableDictionary *fields;
/**
 *  post/get
 */
@property (nonatomic, copy) NSString *httpType;
/**
 *  请求类型
 */
@property (nonatomic, assign) CTNetworkEngineType requestType;
/**
 *  需要上传的文件，包含的是文件名
 */
@property (nonatomic, strong) NSArray *files;
/**
 *  需要上传的文件data值
 */
@property (nonatomic, strong) NSData *filesData;
/**
 *  上传文件对应的key, 需要与服务器约定
 */
@property (nonatomic, strong) NSString *fileUploadKey;
/**
 *  下载文件需要的缓存路径，如果不设置，默认为Documents/CTCaches文件夹下
 */
@property (nonatomic, strong) NSString *savedFilePath;
/**
 *  请求地址
 */
@property (nonatomic, copy) NSString *apiUrl;
/**
 *  请求成功回调
 *  在下载文件时，以下载地址(不带后缀)的md5值作为缓存文件的文件名，如果文件已存在，则不再进行请求
 */
@property (nonatomic, copy) successBlock successBlock;
/**
 *  请求失败回调
 */
@property (nonatomic, copy) failBlock failBlock;

/**
 *  上传进度回调
 */
@property (nonatomic, copy) CTUploadProgress uploadProgress;
/**
 *  下载进度回调
 */
@property (nonatomic, copy) CTDownloadProgress downloadProgress;
/**
 *  超时时间
 */
@property (nonatomic, assign) NSInteger timeoutInterval;

@property (nonatomic, copy) NSString *requestModel;

- (void)sendRequest;

- (void)cancelRequest;
@end
