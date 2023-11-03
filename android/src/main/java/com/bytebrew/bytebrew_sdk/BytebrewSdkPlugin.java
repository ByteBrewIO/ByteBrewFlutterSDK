package com.bytebrew.bytebrew_sdk;

import android.content.Context;

import androidx.annotation.NonNull;

import com.bytebrew.bytebrewlibrary.*;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** BytebrewSdkPlugin */
public class BytebrewSdkPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context currentContext;
  private final String SDKVersion = "0.1.4";
  private boolean initializedCalled;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "bytebrew_sdk");
    channel.setMethodCallHandler(this);
    currentContext = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {

    if(!call.method.equals("Initialize") && !initializedCalled) {
      result.error("UNINITILIZED", "Please call ByteBrew initialization first before any other call", null);
    }

    switch (call.method)
    {
      case "Initialize":
      {
        String appID = call.argument("appID");
        String appKey = call.argument("appKey");
        String flutterVersion = "FLUTTER@" + SDKVersion;
        ByteBrew.InitializeByteBrew(appID, appKey, flutterVersion, currentContext);
        initializedCalled = true;
        break;
      }
      case "IsByteBrewInitialized":
      {
        result.success(ByteBrew.IsByteBrewInitialized());
        break;
      }
      case "StartPushNotifications":
      {
        ByteBrew.StartPushNotifications(currentContext);
        break;
      }
      case "NewCustomEvent":
      {
        String eventName = call.argument("eventName");
        if(call.hasArgument("value")) {
          if(call.argument("value") instanceof Double) {
            Double value = call.argument("value");
            ByteBrew.NewCustomEvent(eventName, (float) value.doubleValue());
          } else {
            String value = call.argument("value");
            ByteBrew.NewCustomEvent(eventName, value);
          }
        } else {
          ByteBrew.NewCustomEvent(eventName);
        }
        break;
      }
      case "NewProgressionEvent":
      {
        Integer progressionType = call.argument("type");
        String progressionEnvironment = call.argument("environment");
        String progressionStage = call.argument("stage");
        if(call.hasArgument("value")) {
          if(call.argument("value") instanceof Double) {
            Double value = call.argument("value");
            ByteBrew.NewProgressionEvent(ByteBrewProgressionType.values()[progressionType], progressionEnvironment, progressionStage, (float) value.doubleValue());
          } else {
            String value = call.argument("value");
            ByteBrew.NewProgressionEvent(ByteBrewProgressionType.values()[progressionType], progressionEnvironment, progressionStage, value);
          }
        } else {
          ByteBrew.NewProgressionEvent(ByteBrewProgressionType.values()[progressionType], progressionEnvironment, progressionStage);
        }
        break;
      }
      case "SetCustomData":
      {
        String tagName = call.argument("key");
        if(call.argument("value") instanceof String) {
          String value = call.argument("value");
          ByteBrew.SetCustomData(tagName, value);
        } else if (call.argument("value") instanceof Double) {
          Double value = call.argument("value");
          ByteBrew.SetCustomData(tagName, value.doubleValue());
        } else if (call.argument("value") instanceof Integer) {
          Integer value = call.argument("value");
          ByteBrew.SetCustomData(tagName, value.intValue());
        } else if (call.argument("value") instanceof Boolean) {
          Boolean value = call.argument("value");
          ByteBrew.SetCustomData(tagName, value.booleanValue());
        }
        break;
      }
      case "TrackAdEvent":
      {
        Integer adType = call.argument("adType");
        String adLocation = call.argument("adLocation");
        if(call.hasArgument("adID")) {
          String adID = call.argument("adID");
          if(call.hasArgument("adProvider")) {
            String adProvider = call.argument("adProvider");
            ByteBrew.TrackAdEvent(ByteBrewAdType.values()[adType], adLocation, adID, adProvider);
          } else {
            ByteBrew.TrackAdEvent(ByteBrewAdType.values()[adType], adLocation, adID);
          }
        } else {
          ByteBrew.TrackAdEvent(ByteBrewAdType.values()[adType], adLocation);
        }
        break;
      }
      case "TrackAdEventRevenue":
      {
        Integer adType = call.argument("adType");
        String adProvider = call.argument("adProvider");
        String adUnitName = call.argument("adUnitName");
        Double revenue = call.argument("revenue");

        if(call.hasArgument("adLocation")) {
          String adLocation = call.argument("adLocation");
          ByteBrew.TrackAdEvent(ByteBrewAdType.values()[adType], adProvider, adUnitName, adLocation, revenue);
        } else {
          ByteBrew.TrackAdEvent(ByteBrewAdType.values()[adType], adProvider, adUnitName, revenue);
        }
        break;
      }
      case "TrackInAppPurchase":
      {
        String store = call.argument("store");
        String currency = call.argument("currency");
        Double amount = call.argument("amount");
        String itemID = call.argument("itemID");
        String category = call.argument("category");
        ByteBrew.TrackInAppPurchaseEvent(store, currency, (float) amount.doubleValue(), itemID, category);
        break;
      }
      case "TrackGoogleInAppPurchase":
      {
        String store = call.argument("store");
        String currency = call.argument("currency");
        Double amount = call.argument("amount");
        String itemID = call.argument("itemID");
        String category = call.argument("category");
        String receipt = call.argument("receipt");
        String signature = call.argument("signature");
        ByteBrew.TrackGoogleInAppPurchaseEvent(store, currency, (float) amount.doubleValue(), itemID, category, receipt, signature);
        break;
      }
      case "ValidateGoogleInAppPurchase":
      {
        String store = call.argument("store");
        String currency = call.argument("currency");
        Double amount = call.argument("amount");
        String itemID = call.argument("itemID");
        String category = call.argument("category");
        String receipt = call.argument("receipt");
        String signature = call.argument("signature");
        ByteBrew.ValidateGoogleInAppPurchaseEvent(store, currency, (float) amount.doubleValue(), itemID, category, receipt, signature,
                new PurchaseResponseListener() {
                  @Override
                  public void purchaseValidated(ByteBrewPurchaseResult byteBrewPurchaseResult) {
                    HashMap<String, Object> purchaseResult = new HashMap<String, Object>(5);
                    purchaseResult.put("itemID", byteBrewPurchaseResult.getItemID());
                    purchaseResult.put("isValid", byteBrewPurchaseResult.isPurchaseValid());
                    purchaseResult.put("purchaseProcessed", byteBrewPurchaseResult.isPurchaseProcessed());
                    purchaseResult.put("message", byteBrewPurchaseResult.getMessage());
                    purchaseResult.put("timestamp", byteBrewPurchaseResult.getValidationTime());
                    result.success(purchaseResult);
                  }
                });
        break;
      }
      case "GetUserID":
      {
        result.success(ByteBrew.GetUserID());
        break;
      }
      case "HasRemoteConfigsBeenSet":
      {
        result.success(ByteBrew.HasRemoteConfigsBeenSet());
        break;
      }
      case "LoadRemoteConfigs":
      {
        ByteBrew.LoadRemoteConfigs(new RemoteConfigListener() {
          @Override
          public void RetrievedConfigs(boolean b) {
            result.success(b);
          }
        });
        break;
      }
      case "RetrieveRemoteConfigValue":
      {
        String key = call.argument("key");
        String defaultValue = call.argument("defaultValue");
        result.success(ByteBrew.RetrieveRemoteConfigValue(key, defaultValue));
        break;
      }
      case "StopTracking":
      {
        ByteBrew.StopTracking(currentContext);
        break;
      }
      case "RestartTracking":
      {
        ByteBrew.RestartTracking(currentContext);
        break;
      }
      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
