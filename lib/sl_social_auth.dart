library sl_social_auth;

import 'dart:developer' as dev;

/// A Calculator.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sl_social_auth/core/networkcheck.dart';
import 'package:sl_social_auth/core/sl_auth_exception.dart';
import 'package:sl_social_auth/core/sl_auth_response.dart';
import 'package:twitter_login/entity/auth_result.dart';
import 'package:twitter_login/twitter_login.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

///A SlSocialAuth
class SlSocialAuth {
  /// Need to intialized firebase before using any methods of the social login

  static Future<bool> initializedSocialAuth(
      {

      ///pass true if you want to use [WidgetsFlutterBinding] ensureInitialized
      bool ensureInitialized = false,

      ///String name of the app
      String? name,

      ///Provide extra firebase option for configuration
      FirebaseOptions? firebaseOptions}) async {
    try {
      if (ensureInitialized) {
        WidgetsFlutterBinding.ensureInitialized();
      }
      await Firebase.initializeApp();
      return true;
    } on FirebaseException {
      return false;
    }
  }

  ///This method impliments sigin with google
  // Initializes global sign-in configuration settings.
  ///
  /// The [signInOption] determines the user experience. [SigninOption.games]
  /// is only supported on Android.
  ///
  /// The list of [scopes] are OAuth scope codes to request when signing in.
  /// These scope codes will determine the level of data access that is granted
  /// to your application by the user. The full list of available scopes can
  /// be found here:
  /// <https://developers.google.com/identity/protocols/googlescopes>
  ///
  /// The [hostedDomain] argument specifies a hosted domain restriction. By
  /// setting this, sign in will be restricted to accounts of the user in the
  /// specified domain. By default, the list of accounts will not be restricted.
  Future<SlAuthResponse<UserCredential?>> signInWithGoogle({
    SignInOption signInOption = SignInOption.standard,
    List<String> scope = const <String>[],
    String? hostedDomain,
    String? clientId,
    String? serverClientId,
  }) async {
    try {
      if (!await NetworkCheck().isNetworkAvailable()) {
        throw NetworkException(
            msg: 'network-not-available', code: 'Internet is not available');
      }
// Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
              signInOption: signInOption,
              scopes: scope,
              hostedDomain: hostedDomain,
              clientId: clientId,
              serverClientId: serverClientId)
          .signIn();

      if (googleUser == null) {
        throw PlatformException(
            code: 'google-auth-error', message: 'Cancled by User');
      }
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential usercredntial =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return SlAuthResponse<UserCredential?>(
          msg: 'msg', isAuthenticated: true, authData: usercredntial);
    } on FirebaseException {
      return SlAuthResponse<UserCredential?>(
        msg: 'Please try again later',
        isAuthenticated: false,
        authData: null,
      );
    } on PlatformException catch (e) {
      return SlAuthResponse<UserCredential?>(
          msg: e.message ?? 'Try again later',
          isAuthenticated: false,
          authData: null,
          exception: <PlatformException>[e]);
    } on NetworkException catch (e) {
      return SlAuthResponse<UserCredential?>(
          msg: e.msg,
          isAuthenticated: false,
          authData: null,
          exception: <NetworkException>[e]);
    } on Exception catch (e) {
      dev.log(e.toString());
      return SlAuthResponse<UserCredential?>(
        msg: 'Please try again later',
        isAuthenticated: false,
        authData: null,
      );
    }
  }

  ///trigger sigin with facebook
  Future<SlAuthResponse<UserCredential?>> signInWithFacebook() async {
    try {
      if (!await NetworkCheck().isNetworkAvailable()) {
        throw NetworkException(
            msg: 'network-not-available', code: 'Internet is not available');
      }
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      final UserCredential usercredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      return SlAuthResponse<UserCredential?>(
          msg: 'msg', isAuthenticated: true, authData: usercredential);
    } on FirebaseException {
      return SlAuthResponse<UserCredential?>(
        msg: 'Please try again later',
        isAuthenticated: false,
        authData: null,
      );
    } on NetworkException catch (e) {
      return SlAuthResponse<UserCredential?>(
          msg: e.msg,
          isAuthenticated: false,
          authData: null,
          exception: <NetworkException>[e]);
    } on PlatformException catch (e) {
      return SlAuthResponse<UserCredential?>(
          msg: e.message ?? 'Try again later',
          isAuthenticated: false,
          authData: null,
          exception: <PlatformException>[e]);
    } on Exception catch (e) {
      dev.log(e.toString());
      return SlAuthResponse<UserCredential?>(
        msg: 'Please try again later',
        isAuthenticated: false,
        authData: null,
      );
    }
  }

  ///trigger sigin with twitter

  Future<SlAuthResponse<UserCredential?>> signInWithTwitter(
      {required String apiKey,
      required String apiSecretKey,
      required String redirectURI}) async {
    try {
      if (!await NetworkCheck().isNetworkAvailable()) {
        throw NetworkException(
            msg: 'network-not-available', code: 'Internet is not available');
      }
      // Create a TwitterLogin instance
      final TwitterLogin twitterLogin = TwitterLogin(
          apiKey: apiKey, apiSecretKey: apiSecretKey, redirectURI: redirectURI);

      // Trigger the sign-in flow
      final AuthResult authResult = await twitterLogin.loginV2();

      // Create a credential from the access token

      dev.log(authResult.errorMessage.toString());
      if (authResult.status == TwitterLoginStatus.loggedIn) {
      } else {
        throw PlatformException(
          code: 'twitter-error',
          message: authResult.errorMessage,
        );
      }

      final OAuthCredential twitterAuthCredential =
          TwitterAuthProvider.credential(
        accessToken: authResult.authToken!,
        secret: authResult.authTokenSecret!,
      );

      // Once signed in, return the UserCredential
      final UserCredential usercredntial = await FirebaseAuth.instance
          .signInWithCredential(twitterAuthCredential);

      return SlAuthResponse<UserCredential?>(
          msg: 'msg', isAuthenticated: true, authData: usercredntial);
    } on FirebaseException catch (e) {
      return SlAuthResponse<UserCredential?>(
        msg: e.message ?? 'Please try again later',
        isAuthenticated: false,
        authData: null,
      );
    } on NetworkException catch (e) {
      return SlAuthResponse<UserCredential?>(
          msg: e.msg,
          isAuthenticated: false,
          authData: null,
          exception: <NetworkException>[e]);
    } on PlatformException catch (e) {
      return SlAuthResponse<UserCredential?>(
          msg: e.message ?? 'Try again later',
          isAuthenticated: false,
          authData: null,
          exception: <PlatformException>[e]);
    } on Exception catch (e) {
      dev.log(e.toString());
      return SlAuthResponse<UserCredential?>(
        msg: 'Please try again later',
        isAuthenticated: false,
        authData: null,
      );
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    const String charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final Random random = Random.secure();
    return List<String>.generate(
        length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final List<int> bytes = utf8.encode(input);
    final Digest digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// trigger sigin with apple
  Future<SlAuthResponse<UserCredential?>> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.

    try {
      if (!await NetworkCheck().isNetworkAvailable()) {
        throw NetworkException(
            msg: 'network-not-available', code: 'Internet is not available');
      }
      final String rawNonce = generateNonce();
      final String nonce = sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: <AppleIDAuthorizationScopes>[
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final OAuthCredential oauthCredential =
          OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`,
      //sign in will fail.
      final UserCredential usercredntial =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      return SlAuthResponse<UserCredential?>(
          msg: 'msg', isAuthenticated: true, authData: usercredntial);
    } on FirebaseException catch (e) {
      return SlAuthResponse<UserCredential?>(
        msg: e.message ?? 'Please try again later',
        isAuthenticated: false,
        authData: null,
      );
    } on NetworkException catch (e) {
      return SlAuthResponse<UserCredential?>(
          msg: e.msg,
          isAuthenticated: false,
          authData: null,
          exception: <NetworkException>[e]);
    } on PlatformException catch (e) {
      return SlAuthResponse<UserCredential?>(
          msg: e.message ?? 'Try again later',
          isAuthenticated: false,
          authData: null,
          exception: <PlatformException>[e]);
    } on Exception catch (e) {
      dev.log(e.toString());
      return SlAuthResponse<UserCredential?>(
        msg: 'Please try again later',
        isAuthenticated: false,
        authData: null,
      );
    }
  }

  ///With this method we can signOut from the Firebase auth
  Future<bool> signOut() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        if (await GoogleSignIn().isSignedIn()) {
          await GoogleSignIn().signOut();
        }

        await FirebaseAuth.instance.signOut();
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
