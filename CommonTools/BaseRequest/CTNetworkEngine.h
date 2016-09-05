//
//  CTNetworkEngine.h
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^successBlock)(id result);
typedef void (^failBlock)(id error);
typedef void (^CTUploadProgress)(long long totalBytesWritten, long long totalBytesExpectedToWrite);
typedef void (^CTDownloadProgress)(long long totalBytesRead, long long totalBytesExpectedToRead);

typedef NS_ENUM(NSInteger, CTNetworkEngineType){
    CTNetworkEngineTypeCommon, //POST/GET
    CTNetworkEngineTypeUpload, //上传
    CTNetworkEngineTypeDownload //下载
};

@interface CTNetworkEngine : NSObject
/**
 *  超时时间
 */
@property (nonatomic, assign) NSInteger timeoutInterval;

/**
 *  基础地址，如http://www.baidu.com，用于拼接url，如果为空则不拼接
 */
@property (nonatomic, strong) NSString *baseUrl;

/**
 *  限制请求地址，如http://www.baidu.com，用于屏蔽其它的请求，如果为空则不屏蔽
 */
@property (nonatomic, strong) NSString *limitedUrl;

/**
 *  错误处理统一回调
 */
@property (nonatomic, copy) failBlock unionfailBlock;
/**
 *  获取实例
 *
 *  @return 实例
 */
+ (instancetype)instance;

/**
 *  网络请求
 *
 *  @param type         请求类型POST/GET
 *  @param URLString    请求地址
 *  @param parameters   参数
 *  @param success      成功回调
 *  @param fail         失败回调
 *
 *  @return 队列
 */
- (NSOperation *)httpRequest:(NSString *)type url:(NSString *)URLString parameters:(NSDictionary *)parameters files:(NSArray *)files filesData:(NSData *)filesData fileUploadKey:(NSString *)fileUploadKey savedFilePath:(NSString *)savedFilePath requestType:(CTNetworkEngineType)requestType success:(successBlock)successBlock fail:(failBlock)failBlock uploadProgress:(CTUploadProgress)uploadProgress downloadProgress:(CTDownloadProgress)downloadProgress;
@end
