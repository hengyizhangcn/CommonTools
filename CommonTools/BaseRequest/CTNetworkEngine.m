//
//  CTNetworkEngine.m
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

#import "CTNetworkEngine.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
@interface CTNetworkEngine ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;
@end

@implementation CTNetworkEngine

+ (instancetype)instance
{
    static dispatch_once_t predicate;
    static id sharedInstance;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        //...
        [self.operationManager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        self.operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"video/mp4", @"application/json", @"application/octet-stream", nil];
    }
    return self;
}



- (NSOperation *)httpRequest:(NSString *)type url:(NSString *)URLString parameters:(NSDictionary *)parameters files:(NSArray *)files filesData:(NSData *)filesData fileUploadKey:(NSString *)fileUploadKey savedFilePath:(NSString *)savedFilePath requestType:(CTNetworkEngineType)requestType success:(successBlock)successBlock fail:(failBlock)failBlock uploadProgress:(CTUploadProgress)uploadProgress downloadProgress:(CTDownloadProgress)downloadProgress
{
    self.operationManager.requestSerializer.timeoutInterval = self.timeoutInterval ?: 10; //默认10秒
    switch (requestType) {
        case CTNetworkEngineTypeCommon:
            return [self httpRequest:type url:URLString parameters:parameters success:successBlock fail:failBlock];
            break;
        case CTNetworkEngineTypeUpload:
            return [self uploadRequest:type url:URLString parameters:parameters files:files filesData:filesData fileUploadKey:fileUploadKey success:successBlock fail:failBlock uploadProgress:uploadProgress];
            break;
        case CTNetworkEngineTypeDownload:
            return [self downloadRequest:type url:URLString parameters:parameters savedFilePath:savedFilePath success:successBlock fail:failBlock downloadProgress:downloadProgress];
            break;
            
        default:
            break;
    }
    return nil;
}

- (NSOperation *)httpRequest:(NSString *)type url:(NSString *)URLString parameters:(NSDictionary *)parameters success:(successBlock)successBlock fail:(failBlock)failBlock
{
    //需要进行url地址检查
    AFHTTPRequestOperation *requestOperation = nil;
    if ([type isEqualToString:@"GET"]) {
        requestOperation = [self.operationManager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            id returnObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            if (successBlock) {
                successBlock(returnObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failBlock) {
                failBlock(error);
            }
        }];
    } else if ([type isEqualToString:@"POST"]) {
        requestOperation = [self.operationManager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            id returnObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            if (successBlock) {
                successBlock(returnObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failBlock) {
                failBlock(error);
            }
        }];
    }
    return requestOperation;
}

- (NSOperation *)uploadRequest:(NSString *)type url:(NSString *)URLString parameters:(NSDictionary *)parameters files:(NSArray *)files filesData:(NSData *)filesData fileUploadKey:(NSString *)fileUploadKey success:(successBlock)successBlock fail:(failBlock)failBlock uploadProgress:(CTUploadProgress)uploadProgress
{
    //需要进行url地址检查
    AFHTTPRequestOperation *requestOperation = nil;
    if (files.count || filesData) { //上传
        requestOperation = [self.operationManager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (files.count) {
                for (NSString *filePath in files) {
                    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
                    //注:这里的name:"files"为请求里面的key，由服务器约定好，
                    //如果服务器对上传的文件重新命名的话，fileName参数可以随便填写
                    NSString *nameStr = fileUploadKey ?: @"files";
                    [formData appendPartWithFileData:fileData name:nameStr fileName:filePath.lastPathComponent mimeType:@"application/octet-stream"];
                }
            } else if (filesData) {
                NSString *nameStr = fileUploadKey ?: @"file";
                [formData appendPartWithFileData:filesData name:nameStr fileName:@"file" mimeType:@"application/octet-stream"];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            id returnObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
            if (successBlock) {
                successBlock(returnObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failBlock) {
                failBlock(error);
            }
        }];
        [requestOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
#if DEBUG
            NSLog(@"上传进度:%ld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
#endif
            if (uploadProgress) {
                uploadProgress(totalBytesWritten, totalBytesExpectedToWrite);
            }
        }];
    }
    return requestOperation;
}

- (NSOperation *)downloadRequest:(NSString *)type url:(NSString *)URLString parameters:(NSDictionary *)parameters savedFilePath:(NSString *)path success:(successBlock)successBlock fail:(failBlock)failBlock downloadProgress:(CTDownloadProgress)downloadProgress
{
    //需要进行url地址检查
    
    NSString *destinationFilePath;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (path) {
        destinationFilePath = path;
        if ([fileManager fileExistsAtPath:destinationFilePath]) {
            NSDictionary *resultDict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"OK", destinationFilePath, @"savedFilePath", nil];
            if (successBlock) {
                successBlock(resultDict);
            }
            return nil;
        }
    } else {
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        destinationFilePath = [NSString stringWithFormat:@"%@/CTCaches/%@", pathArray[0], URLString.lastPathComponent];
        if (![fileManager fileExistsAtPath:destinationFilePath]) {
            [fileManager createDirectoryAtPath:[NSString stringWithFormat:@"%@/CTCaches", pathArray[0]] withIntermediateDirectories:YES attributes:nil error:nil];
        } else {
            NSDictionary *resultDict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"OK", destinationFilePath, @"savedFilePath", nil];
            if (successBlock) {
                successBlock(resultDict);
            }
            return nil;
        }
    }
    
    AFHTTPRequestOperation *requestOperation = [self.operationManager HTTPRequestOperationWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:URLString]] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDict = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"OK", destinationFilePath, @"savedFilePath", nil];
        if (successBlock) {
            successBlock(resultDict);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failBlock) {
            failBlock(error);
        }
    }];
    
    requestOperation.inputStream = [NSInputStream inputStreamWithURL:[NSURL URLWithString:URLString]];
    requestOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:destinationFilePath append:NO];
    [requestOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if (downloadProgress) {
            downloadProgress(totalBytesRead, totalBytesExpectedToRead);
        }
#if DEBUG
        NSLog(@"下载进度:%ld, %lld, %lld", bytesRead, totalBytesRead, totalBytesExpectedToRead);
#endif
    }];
    [self.operationManager.operationQueue addOperation:requestOperation];
    return requestOperation;
}

- (AFHTTPRequestOperationManager *)operationManager
{
    if (!_operationManager) {
        _operationManager = [AFHTTPRequestOperationManager manager];
    }
    return _operationManager;
}
@end
