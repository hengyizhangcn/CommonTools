//
//  CTBaseRequest.m
//  Pods
//
//  Created by zhy on 9/5/16.
//  Copyright © 2016 OCT. All rights reserved.
//

#import "CTBaseRequest.h"
#import "AFNetworking.h"
#import "CTNetworkEngine.h"
@interface CTBaseRequest ()

/**
 *  请求队列
 */
@property (nonatomic, strong) NSOperation *operation;
@end

@implementation CTBaseRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.fields = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)sendRequest
{
    if (self.operation.isExecuting) {
        return;
    }
    _httpType = _httpType ?: [self getHttpType];
    [CTNetworkEngine instance].timeoutInterval = self.timeoutInterval;
    
    _operation = [[CTNetworkEngine instance] httpRequest:_httpType url:self.apiUrl parameters:self.fields files:self.files filesData:self.filesData fileUploadKey:self.fileUploadKey savedFilePath:self.savedFilePath requestType:self.requestType success:^(id returnObject) {
        if (!([returnObject isKindOfClass:[NSDictionary class]]||[returnObject isKindOfClass:[NSArray class]])) {
            if (self.failBlock) {
                self.failBlock(0);
            }
            return;
        }
        NSMutableDictionary *tmpDic = returnObject;
        if ([[tmpDic objectForKey:@"OK"] boolValue]) {
            if (self.successBlock) {
                if (self.requestModel) {
//                    Class class = NSClassFromString(self.requestModel);
                    id obj = tmpDic;// [[class alloc] initWithDictionary:tmpDic error:nil];
                    if (obj) {
                        self.successBlock(obj);
                        return;
                    }
                }
                self.successBlock(tmpDic);
            }
        } else {
            if ([tmpDic objectForKey:@"errorCode"]) {
                if (self.failBlock) {
                    self.failBlock([tmpDic objectForKey:@"errorCode"]);
                }
            } else if ([tmpDic objectForKey:@"resultCode"]) {
                if (self.failBlock) {
                    self.failBlock([tmpDic objectForKey:@"resultCode"]);
                }
            } else {
                if (self.failBlock) {
                    self.failBlock(0);
                }
            }
        }
    } fail:^(NSError *error) {
        if (self.failBlock) {
            self.failBlock(@(error.code));
        }
    } uploadProgress:^(long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if (self.uploadProgress) {
            self.uploadProgress(totalBytesWritten, totalBytesExpectedToWrite);
        }
    } downloadProgress:^(long long totalBytesRead, long long totalBytesExpectedToRead) {
        if (self.downloadProgress) {
            self.downloadProgress(totalBytesRead, totalBytesExpectedToRead);
        }
    }];
}

- (void)cancelRequest
{
    if (_operation) {
        [_operation cancel];
        //        _operation = nil;
    }
}

#pragma mark Access Methods
/**
 *  默认POST请求
 *
 *  @return 请求类型
 */
- (NSString *)getHttpType
{
    return @"POST";
}
@end
