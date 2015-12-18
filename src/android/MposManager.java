// (c) 2105 Chen Jiaqi
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

package com.morefun.cordova;

import android.app.Activity;

import android.content.Context;
import android.content.Intent;
import android.os.Handler;

import android.provider.Settings;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaArgs;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.LOG;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

import java.util.*;

public class MposManager extends CordovaPlugin {

    private static final String TAG = "MposManager";

    // actions
    private static final String OPEN = "open";
    private static final String CLOSE = "close";

    private static final String START_SCAN = "startScan";
    private static final String STOP_SCAN = "stopScan";

    private static final String CONNECT = "connect";
    private static final String DISCONNECT = "disconnect";

    private static final String GET_DEVICE_STATE = "getDeviceState";

    @Override
    public boolean execute(String action, CordovaArgs args, CallbackContext callbackContext) throws JSONException {

        LOG.d(TAG, "action = " + action);

        return true;
    }
}
