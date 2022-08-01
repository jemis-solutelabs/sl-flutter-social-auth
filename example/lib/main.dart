import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:sl_social_auth/sl_social_auth.dart';
import 'package:sl_social_auth/widgets/sl_social_auth_widget.dart';
import 'package:sl_social_auth_example/config.dart';

void main() async {
  await SlSocialAuth.initializedSocialAuth(ensureInitialized: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: Center()),
            SlAuthWidget(
              isGoogleEnable: true,
              isTwitterEnable: true,
              twitterApiKey: Config.twitterApiKey,
              twitterSecrectKey: Config.twitterSecretKey,
              title: 'Or Sign In with',
              twitterRedirctUrl: Config.redirectUrl,
              onAuthenticated: (authType, slAuthResponse) {
                log("Google login authenticated");
                log(slAuthResponse.authData!.user!.email.toString());
              },
              onFailure: (authType, authResponse) {
                log(authType.toString() + " failed: " + authResponse.msg);
              },
            ),
            Expanded(child: Center())
          ],
        ),
      ),
    );
  }
}
