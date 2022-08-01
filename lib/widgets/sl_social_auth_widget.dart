import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sl_social_auth/core/auth_type.dart';
import 'package:sl_social_auth/core/sl_auth_response.dart';
import 'package:sl_social_auth/sl_social_auth.dart';
import 'package:sl_social_auth/widgets/colors.dart';
import 'package:sl_social_auth/widgets/round_button.dart';

///SlAutthWidget provides by default social login implimentation
class SlAuthWidget extends StatefulWidget {
  ///need to pass following parament for customization
  ///
  ///
  SlAuthWidget(
      {required this.title,
      Key? key,
      this.onFailure,
      this.onAuthenticated,
      this.isGoogleEnable = true,
      this.isTwitterEnable = true,
      this.twitterApiKey,
      this.twitterRedirctUrl,
      this.twitterSecrectKey})
      : super(key: key);

  /// authentication callback
  final void Function(
          AuthType authType, SlAuthResponse<UserCredential?> authResponse)?
      onAuthenticated;

  ///specify if google auth is enable
  bool? isGoogleEnable = true;

  ///speficy if twitter is enable
  bool? isTwitterEnable = true;

  ///specify if apple is enable
  bool? isAppleEnable = true;

  ///specify is facebook is enable
  bool? isFacebookEnable = true;

  ///Twitter api key
  String? twitterApiKey;

  ///Tweitter secret keys
  String? twitterSecrectKey;

  ///Twitter redirct url
  String? twitterRedirctUrl;

  /// String dividerTitle

  String title = '';

  /// failure callback
  /// authentication callback
  final void Function(
          AuthType authType, SlAuthResponse<UserCredential?> authResponse)?
      onFailure;

  @override
  State<SlAuthWidget> createState() => _SlAuthWidgetState();
}

class _SlAuthWidgetState extends State<SlAuthWidget> {
  bool isGoogleauthenticating = false;
  bool isApppleauthenticaitng = false;
  bool isFacebookauthenticating = false;
  bool isTwitterauthenticating = false;
  SlSocialAuth slSocialAuth = SlSocialAuth();
  @override
  Widget build(BuildContext context) => Container(
        color: transparent,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                const SizedBox(
                  width: 16,
                ),
                const Expanded(
                    child: Divider(
                  height: 4,
                  thickness: 2,
                )),
                const SizedBox(
                  width: 16,
                ),
                Text(widget.title),
                const SizedBox(
                  width: 16,
                ),
                const Expanded(
                    child: Divider(
                  height: 4,
                  thickness: 2,
                )),
                const SizedBox(
                  width: 12,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 16,
              spacing: 16,
              children: <Widget>[
                widget.isGoogleEnable!
                    ? RoundButton(
                        onPressed: () async {
                          setState(() {
                            isGoogleauthenticating = true;
                          });
                          final SlAuthResponse<UserCredential?> res =
                              await slSocialAuth.signInWithGoogle();
                          setState(() {
                            isGoogleauthenticating = false;
                          });

                          if (res.isAuthenticated) {
                            widget.onAuthenticated!(AuthType.google, res);
                          } else {
                            widget.onFailure!(AuthType.google, res);
                          }
                        },
                        width: 55,
                        isLoading: isGoogleauthenticating,
                        color: google,
                        icon: FontAwesomeIcons.google)
                    : const SizedBox.shrink(),
                widget.isAppleEnable!
                    ? RoundButton(
                        onPressed: () async {
                          setState(() {
                            isApppleauthenticaitng = true;
                          });
                          final SlAuthResponse<UserCredential?> res =
                              await slSocialAuth.signInWithApple();
                          setState(() {
                            isApppleauthenticaitng = false;
                          });

                          if (res.isAuthenticated) {
                            widget.onAuthenticated!(AuthType.apple, res);
                          } else {
                            widget.onFailure!(AuthType.apple, res);
                          }
                        },
                        width: 55,
                        isLoading: isApppleauthenticaitng,
                        color: Colors.black,
                        icon: FontAwesomeIcons.apple)
                    : const SizedBox.shrink(),
                widget.isFacebookEnable!
                    ? RoundButton(
                        onPressed: () async {
                          setState(() {
                            isFacebookauthenticating = true;
                          });
                          final SlAuthResponse<UserCredential?> res =
                              await slSocialAuth.signInWithFacebook();
                          setState(() {
                            isFacebookauthenticating = false;
                          });

                          if (res.isAuthenticated) {
                            widget.onAuthenticated!(AuthType.faceBook, res);
                          } else {
                            widget.onFailure!(AuthType.faceBook, res);
                          }
                        },
                        width: 55,
                        isLoading: isFacebookauthenticating,
                        color: facebook,
                        icon: FontAwesomeIcons.facebook)
                    : const SizedBox.shrink(),
                widget.isTwitterEnable!
                    ? RoundButton(
                        onPressed: () async {
                          setState(() {
                            isTwitterauthenticating = true;
                          });
                          await slSocialAuth.signOut();

                          final SlAuthResponse<UserCredential?> res =
                              await slSocialAuth.signInWithTwitter(
                                  apiKey: widget.twitterApiKey ?? '',
                                  apiSecretKey: widget.twitterSecrectKey ?? '',
                                  redirectURI: widget.twitterRedirctUrl ?? '');
                          setState(() {
                            isTwitterauthenticating = false;
                          });

                          if (res.isAuthenticated) {
                            widget.onAuthenticated!(AuthType.twitter, res);
                          } else {
                            widget.onFailure!(AuthType.twitter, res);
                          }
                        },
                        width: 55,
                        isLoading: isTwitterauthenticating,
                        color: twitter,
                        icon: FontAwesomeIcons.twitter)
                    : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      );
}
