import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:bytebrew_sdk/bytebrew_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _user = 'Unknown';
  String _remoteConfigsStuff = "N/A";

  @override
  void initState() {
    super.initState();
    initPlatformState();
    if(Platform.isAndroid) {
      ByteBrewSdk.initialize("ANDROID_APP_ID", "ANDROID_SDK_KEY");
    } else if(Platform.isIOS) {
      ByteBrewSdk.initialize("IOS_APP_ID", "IOS_SDK_KEY");
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String user;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      user =
          await ByteBrewSdk.getUserID() ?? 'Unknown User';
    } on PlatformException {
      user = 'Failed to get user';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Running on: $_user\n'),
                Text('Remote Configs on: $_remoteConfigsStuff\n'),
                TextButton(
                    onPressed: () {
                      ByteBrewSdk.getUserID().then((value) => {
                        setState(() {
                          _user = value ?? "No User";
                        })
                      });
                    },
                    child: Text("Get User")
                ),
                TextButton(
                    onPressed: () {
                       ByteBrewSdk.newCustomEvent("test_some");
                    },
                    child: Text("New Event")
                ),
                TextButton(
                    onPressed: () {
                      ByteBrewSdk.newCustomEventStringValue("test_complex", "glad=yes;happy=1;");
                    },
                    child: Text("New Complex Event")
                ),
                TextButton(
                    onPressed: () {
                      ByteBrewSdk.setCustomDataTagString("clicked", "yep");
                    },
                    child: Text("Data Attribute Set 1")
                ),
                TextButton(
                    onPressed: () {
                      ByteBrewSdk.setCustomDataTagInt("set-ATT", 1);
                    },
                    child: Text("Data Attribute Set 2")
                ),
                TextButton(
                    onPressed: () {
                      ByteBrewSdk.setCustomDataTagBool("boolCheck", true);
                    },
                    child: Text("Data Attribute Set 3")
                ),
                TextButton(
                    onPressed: () {
                      ByteBrewSdk.setCustomDataTagDouble("amount_earned", 13.5);
                    },
                    child: Text("Data Attribute Set 4")
                ),
                TextButton(
                    onPressed: () {
                      ByteBrewSdk.newProgressionEvent(ByteBrewProgressionType.Started, "levels", "1");
                    },
                    child: Text("Progress 1 Start")
                ),
                TextButton(
                    onPressed: () {
                      ByteBrewSdk.newProgressionEvent(ByteBrewProgressionType.Completed, "levels", "1");
                    },
                    child: Text("Progress 1 Completed")
                ),
                TextButton(
                    onPressed: () {
                      ByteBrewSdk.newProgressionEvent(ByteBrewProgressionType.Failed, "levels", "1");
                    },
                    child: Text("Progress 1 Failed")
                ),
                TextButton(
                    onPressed: () {
                      ByteBrewSdk.trackAdEvent(ByteBrewAdType.Interstitial, "end_level");
                    },
                    child: Text("Ad Event")
                ),
                TextButton(
                    onPressed: () {
                      ByteBrewSdk.trackAdEvent(ByteBrewAdType.Reward, "double_points");
                    },
                    child: Text("Ad Event Reward")
                ),
                TextButton(
                    onPressed: () {
                      ByteBrewSdk.hasRemoteConfigs().then((value) => {
                        log("Has configs: $value")
                      });
                      ByteBrewSdk.loadRemoteConfigs().then((value) => {
                        ByteBrewSdk.retrieveRemoteConfigValue("test_key", "value_1").then((value) => {
                          setState(() {
                            _remoteConfigsStuff = value ?? "something";
                          })
                        })
                      });
                    },
                    child: Text("Get Remote Configs")
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
