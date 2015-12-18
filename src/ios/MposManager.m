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

#import "MposManager.h"
#import <Cordova/CDV.h>


@implementation MposManager

@synthesize posCtrl;

- (void)pluginInitialize {

    NSLog(@"Cordova MoerFun MPosManager Plugin");
    NSLog(@"(c)2015 Chen Jiaqi");

    [super pluginInitialize];

    posCtrl = [MPosController sharedInstance];
    posCtrl.delegate = self;
}

#pragma mark - Cordova Plugin Methods

- (void)open:(CDVInvokedUrlCommand *)command
{
    NSLog(@"open");
    [posCtrl open];

}
-(void) close:(CDVInvokedUrlCommand *)command
{
    NSLog(@"close");
    [posCtrl close];
}

-(void) connect:(CDVInvokedUrlCommand *)command
{
    NSLog(@"connect");
    
    [posCtrl stopScan];
    discoverPeripherialCallbackId = nil;
    
    posCallbackId = [command.callbackId copy];
    NSString *uuid = [command.arguments objectAtIndex:0];
    [posCtrl connectBtDevice: uuid];
}

// disconnect: function (success, failure) {
-(void) disconnect:(CDVInvokedUrlCommand*)command
{
    NSLog(@"disconnect");

    posCallbackId = [command.callbackId copy];
    [posCtrl disconnectBtDevice];
}


-(void) startScan:(CDVInvokedUrlCommand*)command
{
    NSLog(@"startScan");

    discoverPeripherialCallbackId = [command.callbackId copy];
    
    NSNumber *timeoutSeconds = [command.arguments objectAtIndex: 0];
    [posCtrl scanBtDevice: [timeoutSeconds integerValue]];
}

-(void) stopScan:(CDVInvokedUrlCommand*)command
{
    NSLog(@"stopScan");
    
    [posCtrl stopScan];
    
    discoverPeripherialCallbackId = nil;
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


-(void) getDeviceState:(CDVInvokedUrlCommand*)command
{
    NSLog(@"getDeviceState");
    
    int state = (int)[posCtrl getDeviceState];
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt: state];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - MPosController Function

-(void) readPosInfo: (CDVInvokedUrlCommand *)command
{
    NSLog(@"readPosInfo");
    
    posCallbackId = [command.callbackId copy];
    [posCtrl readPosInfo];
}

// cardRead: function (msg, amountFen, timeout, success, failure) {
-(void) cardRead: (CDVInvokedUrlCommand *)command
{
    NSLog(@"cardRead");
    
    posCallbackId = [command.callbackId copy];
    
    NSString *msg = [command.arguments objectAtIndex:0];
    NSNumber *fen = [command.arguments objectAtIndex: 1];
    NSNumber *timeout = [command.arguments objectAtIndex: 2];
    
    amountFen = [fen integerValue];
    [posCtrl openCardReader: msg aMount:amountFen timeOut:[timeout integerValue] readType: MF_COMBINED showMsg: @""];
}

#pragma mark - MPosControllerDelegate

-(void) didFoundBtDevice:(NSString *)btDevice
{
    NSLog(@"didFoundBtDevice: %@", btDevice);
    if (discoverPeripherialCallbackId) {
        CDVPluginResult *pluginResult = nil;
        
        NSRange rrr = [btDevice rangeOfString: @","];
        if (rrr.length > 0) {
            NSString *name = [btDevice substringToIndex: rrr.location];
            NSString *uuid = [btDevice substringFromIndex: rrr.location + 1];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  name, @"name",
                                  uuid, @"id",
                                  nil];
            
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary: dic];
            NSLog(@"Discovered %@", dic);
            [pluginResult setKeepCallbackAsBool:TRUE];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:discoverPeripherialCallbackId];
        }
    }
    
}

-(void) didStopScanBtDevice
{
    if (discoverPeripherialCallbackId) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"stopScan"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId: discoverPeripherialCallbackId];
        
        discoverPeripherialCallbackId = nil;
    }
}

-(void) didConnected:(NSString *)devName
{
    NSLog(@"didConnected: %@", devName);
    
    if (posCallbackId) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: devName];
        [self.commandDelegate sendPluginResult:pluginResult callbackId: posCallbackId];
        
        posCallbackId = nil;
    }
}

-(void) didConnectFail
{
    NSLog(@"didConnectFail.");
    if (posCallbackId) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"connectFail"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId: posCallbackId];
        
        posCallbackId = nil;
    }
}

-(void) didDisconnected
{
    NSLog(@"didDisconnected.");
    if (posCallbackId) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId: posCallbackId];
        
        posCallbackId = nil;
    }
}

-(void) didTimeout
{
    if (posCallbackId) {
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"timeOut"];
        [self.commandDelegate sendPluginResult:pluginResult callbackId: posCallbackId];
        
        posCallbackId = nil;
    }
}

-(void) didReadPosInfoResp:(NSString *)ksn status:(MFEU_MSR_DEVSTAT)status battery:(MFEU_MSR_BATTERY)battery app_ver:(NSString *)app_ver data_ver:(NSString *)data_ver custom_info:(NSString *)custom_info
{
    if (posCallbackId) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         ksn, @"ksn",
                         [NSString stringWithFormat: @"%d", status], @"status",
                         [NSString stringWithFormat: @"%d", battery], @"battery",
                         app_ver, @"app_version",
                         data_ver, @"data_version",
                         custom_info, @"custom_info",
                         nil];
        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary: dic];
        NSLog(@"readPosInfoResp: %@", dic);
        [self.commandDelegate sendPluginResult:pluginResult callbackId:posCallbackId];
        
        posCallbackId = nil;
    }
}

-(void) didOpenCardResp:(MFEU_MSR_OPENCARD_RESP)resp
{
    CDVPluginResult *pluginResult = nil;
    switch (resp) {
        case MF_RESP_OPENCARD_FINISH:
            // 磁条卡
            [posCtrl readMagcard: MF_READ_TRACK_COMBINED panMask: MF_READ_NOMASK];
            break;
        case MF_RESP_OPENCARD_INSERT:
        case MF_RESP_OPENCARD_ICFORCE:
            // IC卡
            [posCtrl startEmv: amountFen otherAmount: 0 tradeType: MF_FUNC_SALE ecashTrade: MF_ECASH_FORBIT pbocFlow: MF_PBOC_FULL icOnline:MF_ONLINE_YES];
            break;
        default:
            // 其他错误
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: [NSString stringWithFormat:@"didOpenCardResp = %d", resp]];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:posCallbackId];
            posCallbackId = nil;
            break;
    }
}

-(void) didReadMagcardResp:(MFEU_MSR_READCARD_RESP)resp maskedPAN:(NSString *)pan expiryDate:(NSString *)exdate serivceCode:(NSString *)sCode track2Length:(NSInteger)t2Size track3Length:(NSInteger)t3Size encTrack2:(NSString *)t2data encTrack3:(NSString *)t3data randomNumber:(NSString *)randNum
{
    // 读卡成功
    //NSLog(@"didReadMagcardResp resp=%d\n主账号: %@\n有效日期: %@\n服务代码: %@\n二磁道数据: %@\n三磁道数据: %@\n随机数: %@", resp, pan, exdate, sCode, t2data, t3data, randNum);
    
    CDVPluginResult *pluginResult = nil;
    if (resp == MF_RESP_READCARD_SUCC) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"0", @"isICCard",
                             pan, @"account",
                             exdate, @"expiryDate",
                             sCode, @"serviceCode",
                             t2data, @"track2Data",
                             t3data, @"track3Data",
                             randNum, @"randomNumber",
                             nil];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary: dic];
        NSLog(@"didReadMagcardResp: %@", dic);
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:posCallbackId];
    posCallbackId = nil;
}

-(void) didStartEmvResp:(MFEU_MSR_EMV_RESP)resp pinReq:(MFEU_MSR_EMV_PIN)req
{
    CDVPluginResult *pluginResult = nil;
    
    switch (resp) {
        case MF_RESP_EMV_SUCC:
        case MF_RESP_EMV_ACCEPT:
        case MF_RESP_EMV_ONLINE:
        emvPinReq = req;
        [posCtrl getEmvDataEx2: MF_FUNC_SALE];
        break;
        
        default:
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: [NSString stringWithFormat:@"didStartEmvResp: %d", resp]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:posCallbackId];
        posCallbackId = nil;
        break;
    }
}

-(void) didGetEmvDataExResp:(NSString *)data55 beforeLength:(NSInteger)len55 randomNumber:(NSString *)randNum serialNumber:(NSString *)serial maskedPAN:(NSString *)pan encTrack:(NSString *)track expiryDate:(NSString *)exdate
{
    CDVPluginResult *pluginResult = nil;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"1", @"isICCard",
                        pan, @"account",
                        exdate, @"expiryDate",
                        serial, @"serialNumber",
                        data55, @"data55",
                        randNum, @"randomNumber",
                        nil];
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary: dic];
    NSLog(@"didGetEmvDataExResp: %@", dic);
    [self.commandDelegate sendPluginResult:pluginResult callbackId:posCallbackId];
    posCallbackId = nil;
    
    [posCtrl endEmv];
}

@end
