
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

///Progression Event Type Enums
enum ByteBrewProgressionType {
  Started,
  Completed,
  Failed
}

///Ad Type Event Enums
enum ByteBrewAdType {
  Interstitial,
  Reward,
  Banner
}

class ByteBrewSdk {
  static const MethodChannel _channel = MethodChannel('bytebrew_sdk');

  ///Initializes ByteBrew
  static void initialize(String appID, String appKey) {
    _channel.invokeMethod("Initialize", {'appID': appID, 'appKey': appKey});
  }

  ///returns bool based on whether ByteBrew is done initializing
  static Future<bool> isByteBrewInitialized() async {
    return await _channel.invokeMethod("IsByteBrewInitialized");
  }

  ///Starts Push Notifications for your app.
  ///Make sure to configure correct Android Setting on your dashboard.
  static void startPushNotifications() {
    _channel.invokeMethod("StartPushNotifications");
  }

  ///Add new Custom Event
  static void newCustomEvent(String eventName) {
    _channel.invokeMethod("NewCustomEvent", {'eventName': eventName});
  }

  ///Add a new Custom Event with a string value or concatenated Sub-Parameters.
  ///To set a Dictionary of Sub-Parameters, use the format "key1=pair1;key2=pair2;" etc.
  ///Example event: ByteBrewSdk.newCustomEventStringValue("sub_param_example", "key1=pair1;key2=pair2;key3=pair3;");
  static void newCustomEventStringValue(String eventName, String value) {
    _channel.invokeMethod("NewCustomEvent", {'eventName': eventName, 'value': value});
  }

  ///Add new Custom Event with a double value
  static void newCustomEventDoubleValue(String eventName, double value) {
    _channel.invokeMethod("NewCustomEvent", {'eventName': eventName, 'value': value});
  }

  ///Add new Progression Event
  static void newProgressionEvent(ByteBrewProgressionType progressionType, String environment, String stage) {
    _channel.invokeMethod("NewProgressionEvent", {'type': progressionType.index, 'environment': environment, 'stage': stage});
  }

  ///Add new Progression Event with a string value
  static void newProgressionEventStringValue(ByteBrewProgressionType progressionType, String environment, String stage, String value) {
    _channel.invokeMethod("NewProgressionEvent", {'type': progressionType.index, 'environment': environment, 'stage': stage, 'value': value});
  }

  ///Add new Progression Event with a double value
  static void newProgressionEventDoubleValue(ByteBrewProgressionType progressionType, String environment, String stage, double value) {
    _channel.invokeMethod("NewProgressionEvent", {'type': progressionType.index, 'environment': environment, 'stage': stage, 'value': value});
  }

  ///Set Custom Data Attribute with a string value. Use for segmenting or querying specific users.
  static void setCustomDataTagString(String key, String value) {
    if(Platform.isAndroid) {
      _channel.invokeMethod("SetCustomData", {'key': key, 'value': value});
    } else if(Platform.isIOS) {
      _channel.invokeMethod("SetCustomData", {'key': key, 'value': value, 'type': 'string'});
    }
  }

  ///Set Custom Data Attribute with a double value. Use for segmenting or querying specific users.
  static void setCustomDataTagDouble(String key, double value) {
    if(Platform.isAndroid) {
      _channel.invokeMethod("SetCustomData", {'key': key, 'value': value});
    } else if(Platform.isIOS) {
      _channel.invokeMethod("SetCustomData", {'key': key, 'value': value, 'type': 'double'});
    }
  }

  ///Set Custom Data Attribute with a int value. Use for segmenting or querying specific users.
  static void setCustomDataTagInt(String key, int value) {
    if(Platform.isAndroid) {
      _channel.invokeMethod("SetCustomData", {'key': key, 'value': value});
    } else if(Platform.isIOS) {
      _channel.invokeMethod("SetCustomData", {'key': key, 'value': value, 'type': 'int'});
    }
  }

  ///Set Custom Data Attribute with a bool value. Use for segmenting or querying specific users.
  static void setCustomDataTagBool(String key, bool value) {
    if(Platform.isAndroid) {
      _channel.invokeMethod("SetCustomData", {'key': key, 'value': value});
    } else if(Platform.isIOS) {
      _channel.invokeMethod("SetCustomData", {'key': key, 'value': value, 'type': 'bool'});
    }
  }

  ///Add a new Ad Event.
  static void trackAdEvent(ByteBrewAdType adType, String adLocation) {
    _channel.invokeMethod("TrackAdEvent", {'adType': adType.index, 'adLocation': adLocation});
  }

  ///Add a new Ad Event, broken down by the adID shown
  static void trackAdEventADID(ByteBrewAdType adType, String adLocation, String adID) {
    _channel.invokeMethod("TrackAdEvent", {'adType': adType.index, 'adLocation': adLocation, 'adID': adID});
  }

  ///Add a new Ad Event, broken down by the adID shown, and Ad Provider
  static void trackAdEventAdProvider(ByteBrewAdType adType, String adLocation, String adID, String adProvider) {
    _channel.invokeMethod("TrackAdEvent", {'adType': adType.index, 'adLocation': adLocation, 'adID': adID, 'adProvider': adProvider});
  }

  ///Track a regular in-app purchase event, this is without validation.
  static void trackInAppPurchase(String store, String currency, double amount, String itemID, String category) {
    _channel.invokeMethod("TrackInAppPurchase", {'store': store, 'currency': currency, 'amount': amount, 'itemID': itemID, 'category': category});
  }

  ///Track & Validate a Google Specific in-app purchase, this will validate the purchase and track it. Make sure to have the correct Google Play License Key
  ///setup in your ByteBrew app dashboard to correctly validate and show the validated purchase.
  static void trackGoogleInAppPurchase(String store, String currency, double amount, String itemID, String category, String receipt, String signature) {
    if(Platform.isAndroid) {
      _channel.invokeMethod("TrackGoogleInAppPurchase", {'store': store, 'currency': currency, 'amount': amount, 'itemID': itemID, 'category': category, 'receipt': receipt, 'signature': signature});
    } else {
      log("ByteBrew cant track Google in-app purchase if the device is not an Android device");
    }
  }

  ///Track & Validate a Apple App Store Specific in-app purchase, this will validate the purchase and track it. Make sure to have the correct Apple App Shared Secret
  ///setup in your ByteBrew app dashboard to correctly validate and show the validated purchase.
  static void trackAppleInAppPurchase(String store, String currency, double amount, String itemID, String category, String receipt) {
    if(Platform.isIOS) {
      _channel.invokeMethod("TrackAppleInAppPurchase", {'store': store, 'currency': currency, 'amount': amount, 'itemID': itemID, 'category': category, 'receipt': receipt});
    } else {
      log("ByteBrew cant track Apple in-app purchase if the device is not an iOS device");
    }
  }

  ///Validate the Google in-app purchase and return the validation result. This will also track the purchase analytically.
  static Future<Map?> validateGoogleInAppPurchase(String store, String currency, double amount, String itemID, String category, String receipt, String signature) async {
    if(Platform.isAndroid) {
      return await _channel.invokeMapMethod("ValidateGoogleInAppPurchase", {'store': store, 'currency': currency, 'amount': amount, 'itemID': itemID, 'category': category, 'receipt': receipt, 'signature': signature});
    } else {
      log("ByteBrew cant track Google in-app purchase if the device is not an Android device");
      return null;
    }
  }

  ///Validate the Apple App Store in-app purchase and return the validation result. This will also track the purchase analytically.
  static Future<Map?> validateAppleInAppPurchase(String store, String currency, double amount, String itemID, String category, String receipt) async {
    if(Platform.isIOS) {
      return await _channel.invokeMethod("ValidateAppleInAppPurchase", {'store': store, 'currency': currency, 'amount': amount, 'itemID': itemID, 'category': category, 'receipt': receipt});
    } else {
      log("ByteBrew cant track Apple in-app purchase if the device is not an iOS device");
      return null;
    }
  }

  ///Retrieve the current ByteBrew User ID
  static Future<String?> getUserID() async {
    return _channel.invokeMethod("GetUserID");
  }

  ///Check to see if there are loaded ByteBrew Remote Configs
  static Future<bool> hasRemoteConfigs() async {
    return await _channel.invokeMethod("HasRemoteConfigsBeenSet");
  }

  ///Loads remote configs and returns when they are done loading.
  static Future<bool> loadRemoteConfigs() async {
    return await _channel.invokeMethod("LoadRemoteConfigs");
  }

  ///Get a remote config value for the key set in the dashboard.
  static Future<String?> retrieveRemoteConfigValue(String key, String defaultValue) async {
    return _channel.invokeMethod("RetrieveRemoteConfigValue", {'key': key, 'defaultValue': defaultValue});
  }

  ///This will pause all tracking for this user.
  static void stopTracking() {
    _channel.invokeMethod("StopTracking");
  }

  ///This will restart tracking for this user.
  static void restartTracking() {
    _channel.invokeMethod("RestartTracking");
  }
}
