//
//  MposManager.h
//  MoreFun MPos Cordova Plugin
//
//  (c) 2105 Chen Jiaqi
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#ifndef MposManager_h
#define MposManager_h

#import <Cordova/CDV.h>

@interface MposManager : CDVPlugin 

/// 连接音频刷卡器
- (void)open: (CDVInvokedUrlCommand *)command;
/// 断开音频刷卡器
- (void)close: (CDVInvokedUrlCommand *)command;

/// 开始蓝牙搜索
- (void)startScan: (CDVInvokedUrlCommand *)command;
/// 停止蓝牙搜索
- (void)stopScan: (CDVInvokedUrlCommand *)command;
/// 连接蓝牙刷卡设备
- (void)connect: (CDVInvokedUrlCommand *)command;
/// 断开蓝牙刷卡设备
- (void)disconnect: (CDVInvokedUrlCommand *)command;

/// 获取连接状态
- (void)getDeviceState:(CDVInvokedUrlCommand *)command;

@end

#endif
