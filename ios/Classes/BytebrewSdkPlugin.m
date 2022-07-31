#import "BytebrewSdkPlugin.h"

#import "ByteBrewNativeiOSPlugin/ByteBrewNativeiOSPlugin.h"

@implementation BytebrewSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"bytebrew_sdk"
            binaryMessenger:[registrar messenger]];
  BytebrewSdkPlugin* instance = [[BytebrewSdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
   if([call.method isEqualToString:@"getPlatformVersion"]) {
      NSString* version = [[UIDevice currentDevice] systemVersion];
      result(version);
   } else if([call.method isEqualToString:@"Initialize"]) {
      NSMutableDictionary* parameterVals = call.arguments;

      [ByteBrewNativeiOSPlugin InitializeWithSettings:[parameterVals valueForKey:@"appID"] SecretKey:[parameterVals valueForKey:@"appKey"] EngineVersion:@"FLUTTER@0.0.8" BuildVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
  } else if([call.method isEqualToString:@"StartPushNotifications"]) {

      [ByteBrewNativeiOSPlugin StartPushNotification];

  } else if([call.method isEqualToString:@"NewCustomEvent"]) {
      NSMutableDictionary* parameterVals = call.arguments;

      NSString* eventName = [parameterVals valueForKey:@"eventName"];
      if([parameterVals valueForKey:@"value"] != nil) {
          if([[parameterVals valueForKey:@"value"] isKindOfClass:[NSString class]]) {
              NSString* value = [parameterVals valueForKey:@"value"];
              [ByteBrewNativeiOSPlugin AddNewCustomEventWithStringValue:eventName Value:value];
          } else if([[parameterVals valueForKey:@"value"] isKindOfClass:[NSNumber class]]) {
              NSNumber* value = [parameterVals valueForKey:@"value"];
              [ByteBrewNativeiOSPlugin AddNewCustomEventWithNumericValue:eventName Value:[value floatValue]];
          }
      } else {
          [ByteBrewNativeiOSPlugin AddNewCustomEvent:eventName];
      }
  } else if([call.method isEqualToString:@"NewProgressionEvent"]) {
      NSMutableDictionary* parameterVals = call.arguments;
      NSNumber* progressionType = [parameterVals valueForKey:@"type"];
      NSString* environment = [parameterVals valueForKey:@"environment"];
      NSString* stage = [parameterVals valueForKey:@"stage"];

      if([parameterVals valueForKey:@"value"] != nil) {
          if([[parameterVals valueForKey:@"value"] isKindOfClass:[NSString class]]) {
              NSString* value = [parameterVals valueForKey:@"value"];
              [ByteBrewNativeiOSPlugin AddProgressionEventWithStringValue:(ByteBrewProgressionType) [progressionType intValue] Environment:environment Stage:stage Value:value];
          } else if([[parameterVals valueForKey:@"value"] isKindOfClass:[NSNumber class]]) {
              NSNumber* value = [parameterVals valueForKey:@"value"];
              [ByteBrewNativeiOSPlugin AddProgressionEventWithNumericValue:(ByteBrewProgressionType) [progressionType intValue] Environment:environment Stage:stage Value:[value floatValue]];
          }
      } else {
          [ByteBrewNativeiOSPlugin AddProgressionEvent:(ByteBrewProgressionType) [progressionType intValue] Environment:environment Stage:stage];
      }

  } else if([call.method isEqualToString:@"SetCustomData"]) {
      NSMutableDictionary* parameterVals = call.arguments;
      NSString* key = [parameterVals valueForKey:@"key"];
      NSString* type = [parameterVals valueForKey:@"type"];
      if([type isEqualToString:@"string"]) {
          NSString* value = [parameterVals valueForKey:@"value"];

          [ByteBrewNativeiOSPlugin AddCustomDataAttributeWithStringValue:key Value:value];
      } else if([type isEqualToString:@"double"]) {
          NSNumber* value = [parameterVals valueForKey:@"value"];

          [ByteBrewNativeiOSPlugin AddCustomDataAttributeWithDoubleValue:key Value:[value doubleValue]];
      } else if([type isEqualToString:@"int"]) {
          NSNumber* value = [parameterVals valueForKey:@"value"];

          [ByteBrewNativeiOSPlugin AddCustomDataAttributeWithIntegerValue:key Value:[value intValue]];
      } else if([type isEqualToString:@"bool"]) {
          NSNumber* value = [parameterVals valueForKey:@"value"];

          [ByteBrewNativeiOSPlugin AddCustomDataAttributeWithBooleanValue:key Value:[value boolValue]];
      }
  } else if([call.method isEqualToString:@"TrackAdEvent"]) {
      NSMutableDictionary* parameterVals = call.arguments;
      NSNumber* adType = [parameterVals valueForKey:@"adType"];
      NSString* adLocation = [parameterVals valueForKey:@"adLocation"];

      NSString* adTypeSTR = @"";
      if([adType intValue] == 0) {
          adTypeSTR = @"Interstitial";
      } else if([adType intValue] == 1) {
          adTypeSTR = @"Reward";
      } else if([adType intValue] == 2) {
          adTypeSTR = @"Banner";
      }
      if([parameterVals valueForKey:@"adID"] != nil) {
          NSString* adID = [parameterVals valueForKey:@"adID"];
          if([parameterVals valueForKey:@"adProvider"] != nil) {
              NSString* adProvider = [parameterVals valueForKey:@"adProvider"];
              [ByteBrewNativeiOSPlugin NewTrackedAdEvent:adTypeSTR AdLocation:adLocation AdID:adID AdProvider:adProvider];
          } else {
              [ByteBrewNativeiOSPlugin NewTrackedAdEvent:adTypeSTR AdLocation:adLocation AdID:adID];
          }
      } else {
          [ByteBrewNativeiOSPlugin NewTrackedAdEvent:adTypeSTR AdLocation:adLocation];
      }

  } else if([call.method isEqualToString:@"TrackInAppPurchase"]) {
      NSMutableDictionary* parameterVals = call.arguments;
      NSString* store = [parameterVals valueForKey:@"store"];
      NSString* currency = [parameterVals valueForKey:@"currency"];
      NSNumber* amount = [parameterVals valueForKey:@"amount"];
      NSString* itemID = [parameterVals valueForKey:@"itemID"];
      NSString* category = [parameterVals valueForKey:@"category"];

      [ByteBrewNativeiOSPlugin AddTrackedInAppPurchaseEvent:store Currency:currency Amount:[amount floatValue] ItemID:itemID Category:category];

  } else if([call.method isEqualToString:@"TrackAppleInAppPurchase"]) {
      NSMutableDictionary* parameterVals = call.arguments;
      NSString* store = [parameterVals valueForKey:@"store"];
      NSString* currency = [parameterVals valueForKey:@"currency"];
      NSNumber* amount = [parameterVals valueForKey:@"amount"];
      NSString* itemID = [parameterVals valueForKey:@"itemID"];
      NSString* category = [parameterVals valueForKey:@"category"];
      NSString* receipt = [parameterVals valueForKey:@"receipt"];

      [ByteBrewNativeiOSPlugin AddTrackediOSInAppPurchaseEvent:store Currency:currency Amount:[amount floatValue] ItemID:itemID Category:category Receipt:receipt];
  } else if([call.method isEqualToString:@"ValidateAppleInAppPurchase"]) {
      NSMutableDictionary* parameterVals = call.arguments;
      NSString* store = [parameterVals valueForKey:@"store"];
      NSString* currency = [parameterVals valueForKey:@"currency"];
      NSNumber* amount = [parameterVals valueForKey:@"amount"];
      NSString* itemID = [parameterVals valueForKey:@"itemID"];
      NSString* category = [parameterVals valueForKey:@"category"];
      NSString* receipt = [parameterVals valueForKey:@"receipt"];

      [ByteBrewNativeiOSPlugin ValidateiOSInAppPurchaseEvent:store Currency:currency Amount:[amount floatValue] ItemID:itemID Category:category Receipt:receipt finishedValidationResult:^(NSMutableDictionary *purchaseResult) {
          NSDictionary* dataDict = [[NSDictionary alloc] initWithDictionary:purchaseResult];
          result(dataDict);
      }];
  } else if([call.method isEqualToString:@"GetUserID"]) {
      result([ByteBrewNativeiOSPlugin GetUserID]);
  } else if([call.method isEqualToString:@"HasRemoteConfigsBeenSet"]) {
      NSNumber* remoteHas = [NSNumber numberWithBool:[ByteBrewNativeiOSPlugin HasRemoteConfigs]];
      result(remoteHas);
  } else if([call.method isEqualToString:@"LoadRemoteConfigs"]) {
      [ByteBrewNativeiOSPlugin LoadRemoteConfigs:^(BOOL status) {
          NSNumber* remoteHas = [NSNumber numberWithBool:status];
          result(remoteHas);
      }];
  } else if([call.method isEqualToString:@"RetrieveRemoteConfigValue"]) {
      NSMutableDictionary* parameterVals = call.arguments;
      NSString* key = [parameterVals valueForKey:@"key"];
      NSString* defaultValue = [parameterVals valueForKey:@"defaultValue"];
      result([ByteBrewNativeiOSPlugin RetrieveRemoteConfigs:key DefaultValue:defaultValue]);
  } else if([call.method isEqualToString:@"StopTracking"]) {
      [ByteBrewNativeiOSPlugin StopTracking];
  } else if([call.method isEqualToString:@"RestartTracking"]) {
      [ByteBrewNativeiOSPlugin RestartTracking];
  } else {
      result(FlutterMethodNotImplemented);
  }
}

@end
