cordova.define("com.morefun.mposmanager.mposmanager", function(require, exports, module) { /**
 * cordova is available under *either* the terms of the modified BSD license *or* the
 * MIT License (2008). See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) Chen Jiaqi
 * Copyright (c) 2015, Morfun-et Corporation
 */

/* global cordova, module */
"use strict";

var stringToArrayBuffer = function(str) {
    var ret = new Uint8Array(str.length);
    for (var i = 0; i < str.length; i++) {
        ret[i] = str.charCodeAt(i);
    }
    // TODO would it be better to return Uint8Array?
    return ret.buffer;
};

var base64ToArrayBuffer = function(b64) {
    return stringToArrayBuffer(atob(b64));
};

function massageMessageNativeToJs(message) {
    if (message.CDVType == 'ArrayBuffer') {
        message = base64ToArrayBuffer(message.data);
    }
    return message;
}

// Cordova 3.6 doesn't unwrap ArrayBuffers in nested data structures
// https://github.com/apache/cordova-js/blob/94291706945c42fd47fa632ed30f5eb811080e95/src/ios/exec.js#L107-L122
function convertToNativeJS(object) {
    Object.keys(object).forEach(function (key) {
        var value = object[key];
        object[key] = massageMessageNativeToJs(value);
        if (typeof(value) === 'object') {
            convertToNativeJS(value);
        }
    });
}

module.exports = {

    open: function (success, failure) {
        cordova.exec(success, failure, 'MposManager', 'open', []);
    },

    close: function (success, failure) {
        cordova.exec(success, failure, 'MposManager', 'close', []);
    },

    startScan: function (seconds, success, failure) {
        cordova.exec(success, failure, 'MposManager', 'startScan', [seconds]);
    },

    stopScan: function (success, failure) {
        cordova.exec(success, failure, 'MposManager', 'stopScan', []);
    },

    connect: function (device_id, success, failure) {
        cordova.exec(success, failure, 'MposManager', 'connect', [device_id]);
    },

    disconnect: function (success, failure) {
        cordova.exec(success, failure, 'MposManager', 'disconnect', []);
    },

    getDeviceState: function (success, failure) {
        cordova.exec(success, failure, 'MposManager', 'getDeviceState', []);
    },
               
    ///////////////////////////////////////////////////////////////////////////
    readPosInfo: function (success, failure) {
        cordova.exec(success, failure, 'MposManager', 'readPosInfo', []);       
    },
               
    cardRead: function (msg, amount, seconds, success, failure) {
        cordova.exec(success, failure, 'MposManager', 'cardRead', [msg, amount, seconds]);
    },

};
});
