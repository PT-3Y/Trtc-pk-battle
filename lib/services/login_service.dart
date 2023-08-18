import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:socialv/main.dart';
import 'package:socialv/screens/auth/screens/opt_screen.dart';
import 'package:socialv/utils/constants.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class LoginService {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // region Google Sign in
  Future<Map> signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User user = authResult.user!;

      assert(!user.isAnonymous);

      final User currentUser = _auth.currentUser!;
      assert(user.uid == currentUser.uid);

      signOutGoogle();

      String firstName = '';
      String lastName = '';

      if (currentUser.displayName.validate().split(' ').length >= 1) firstName = currentUser.displayName.splitBefore(' ');
      if (currentUser.displayName.validate().split(' ').length >= 2) lastName = currentUser.displayName.splitAfter(' ');

      appStore.setLoginAvatarUrl(currentUser.photoURL!);

      Map req = {
        "email": currentUser.email,
        "first_name": firstName,
        "last_name": lastName,
        "avatar_url": currentUser.photoURL,
        "access_token": googleSignInAuthentication.accessToken,
        "login_type": 'google',
      };
      return req;
    } else {
      throw '';
    }
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
  }

//endregion

  // region Apple Sign
  Future<Map> appleSignIn() async {
    Map request = {};

    if (await TheAppleSignIn.isAvailable()) {
      AuthorizationResult result = await TheAppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);

      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential!;
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken!),
            accessToken: String.fromCharCodes(appleIdCredential.authorizationCode!),
          );

          final authResult = await _auth.signInWithCredential(credential);
          final user = authResult.user!;

          log('User:- $user');

          if (result.credential!.email != null) {
            appStore.setLoading(true);

            await saveAppleData(result).then((value) {
              appStore.setLoading(false);
            }).catchError((e) {
              appStore.setLoading(false);
              throw e;
            });
          }

          await saveAppleDataWithoutEmail(user).then((value) {
            request = value;
            appStore.setLoading(false);
          }).catchError((e) {
            appStore.setLoading(false);
            throw e;
          });

          break;
        case AuthorizationStatus.error:
          throw ("Sign in failed: ${result.error!.localizedDescription}");
        case AuthorizationStatus.cancelled:
          throw ('User cancelled');
      }

      return request;
    } else {
      throw 'Apple SignIn Not Available';
    }
  }

  Future<void> saveAppleData(AuthorizationResult result) async {
    await setValue(APPLE_EMAIL, result.credential!.email);
    await setValue(APPLE_GIVE_NAME, result.credential!.fullName!.givenName);
    await setValue(APPLE_FAMILY_NAME, result.credential!.fullName!.familyName);
  }

  Future<Map> saveAppleDataWithoutEmail(User user) async {
    log('Email:- ${getStringAsync(APPLE_EMAIL)}');
    log('appleGivenName:- ${getStringAsync(APPLE_GIVE_NAME)}');
    log('appleFamilyName:- ${getStringAsync(APPLE_FAMILY_NAME)}');

    Map req = {
      "email": getStringAsync(APPLE_EMAIL),
      "first_name": getStringAsync(APPLE_GIVE_NAME),
      "last_name": getStringAsync(APPLE_FAMILY_NAME),
      "avatar_url": '',
      "access_token": '123456',
      "login_type": 'apple',
    };

    log("Apple Login Json" + jsonEncode(req));
    return req;
  }

//endregion

  //region Google OTP
  Future loginWithOTP(BuildContext context, {String phoneNumber = "", String? countryCode, String? countryISOCode, required Function(Map) callback}) async {
    Map request = {};
    log("PHONE NUMBER VERIFIED +$countryCode$phoneNumber");

    await _auth
        .verifyPhoneNumber(
      phoneNumber: "+$countryCode$phoneNumber",
      verificationCompleted: (PhoneAuthCredential credential) {
        toast(language.verified);
      },
      verificationFailed: (FirebaseAuthException e) {
        appStore.setLoading(false);
        if (e.code == 'invalid-phone-number') {
          toast(language.invalidCodeText, print: true);
        } else {
          toast(e.toString(), print: true);
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        toast(language.otpCodeIsSent);

        appStore.setLoading(false);

        await OtpScreen(
          onTap: (otpCode) async {
            if (otpCode != null) {
              AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpCode);

              await _auth.signInWithCredential(credential).then((credentials) async {
                request = {
                  'phone': phoneNumber,
                  'login_type': 'mobile',
                };

                log("OTP REQUEST $request");

                log("UID ${credentials.user!.uid}");

                callback.call(request);
              }).catchError((e) {
                if (e.code.toString() == 'invalid-verification-code') {
                  toast(language.invalidCodeText, print: true);
                } else {
                  toast(e.message.toString(), print: true);
                }
                appStore.setLoading(false);
              });
            }
          },
        ).launch(context);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        appStore.setLoading(false);
      },
    )
        .catchError((e) {
      appStore.setLoading(false);

      log('Error: ${e.toString()}');
    });
  }

//endregion
}
