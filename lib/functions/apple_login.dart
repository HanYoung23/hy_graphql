// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import "package:http/http.dart" as http;

// Future appleLogin(BuildContext context) async {
//   print("🍎 apple login");
//   final credential = await SignInWithApple.getAppleIDCredential(
//     scopes: [
//       AppleIDAuthorizationScopes.email,
//       AppleIDAuthorizationScopes.fullName,
//     ],
//     webAuthenticationOptions: WebAuthenticationOptions(
//       clientId: 'com.jjang.letsgotrip',
//       redirectUri: Uri.parse(
//           'https://lopsided-eminent-cheese.glitch.me/callbacks/sign_in_with_apple'),
//     ),
//   );
//   print("🍎 apple token : ${credential.identityToken}");
//   final signInWithAppleEndpoint = Uri(
//     scheme: 'https',
//     // host: 'flutter-sign-in-with-apple-example.glitch.me',
//     host: "lopsided-eminent-cheese.glitch.me/callbacks",
//     path: '/sign_in_with_apple',
//     queryParameters: <String, String>{
//       'code': credential.authorizationCode,
//       if (credential.givenName != null) 'firstName': credential.givenName,
//       if (credential.familyName != null) 'lastName': credential.familyName,
//       'useBundleId': Platform.isIOS || Platform.isMacOS ? 'true' : 'false',
//       if (credential.state != null) 'state': credential.state,
//     },
//   );

//   final session = await http.Client().post(
//     signInWithAppleEndpoint,
//   );

//   print("🍎 session : $session");
// }
