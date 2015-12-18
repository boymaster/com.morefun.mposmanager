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

- (void)pluginInitialize {

    NSLog(@"Cordova MoerFun MPosManager Plugin");
    NSLog(@"(c)2015 Chen Jiaqi");

    [super pluginInitialize];

}

#pragma mark - Cordova Plugin Methods

- (void)open:(CDVInvokedUrlCommand *)command {

    NSLog(@"open");

}
- (void)close:(CDVInvokedUrlCommand *)command {

    NSLog(@"close");

}

- (void)connect:(CDVInvokedUrlCommand *)command {

    NSLog(@"connect");
    //NSString *uuid = [command.arguments objectAtIndex:0];

}

// disconnect: function (device_id, success, failure) {
- (void)disconnect:(CDVInvokedUrlCommand*)command {
    NSLog(@"disconnect");

    // always return OK
    //CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    //[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)startScan:(CDVInvokedUrlCommand*)command {

    NSLog(@"startScan");

}

- (void)stopScan:(CDVInvokedUrlCommand*)command {

    NSLog(@"stopScan");

}


- (void)getDeviceState:(CDVInvokedUrlCommand*)command {

    NSLog(@"getDeviceState");

}

#pragma mark - MPosControllerDelegate


@end
