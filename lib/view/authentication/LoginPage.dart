import 'dart:convert';
import 'dart:developer';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/otp_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/authentication/ForgotPassword.dart';
import 'package:amazcart/view/authentication/OtpVerificationPage.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../config/config.dart';
import 'RegistrationPage.dart';

// ignore: must_be_immutable
class LoginPage extends GetView<LoginController> {
  final _formKey = GlobalKey<FormState>();
  final _googleSignIn = GoogleSignIn();

  final LoginController _loginController = Get.put(LoginController());

  final GeneralSettingsController _settingsController =
      Get.put(GeneralSettingsController());

  // ignore: unused_field
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Container(
          height: Get.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppConfig.loginScreenBackgroundGradient1,
                AppConfig.loginScreenBackgroundGradient2,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 10),
                        child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    AppConfig.appLogo,
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    AppConfig.appName.toUpperCase(),
                    style: AppStyles.kFontWhite14w5.copyWith(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Sign In'.tr,
                      style: AppStyles.kFontWhite14w5.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: TextFormField(
                      controller: _loginController.email,
                      decoration: InputDecoration(
                        hintText: 'Enter Your Email'.tr,
                        hintStyle: AppStyles.kFontWhite14w5,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.darkBlueColor,
                          ),
                        ),
                        errorStyle: AppStyles.kFontDarkBlue12w5,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        suffixIcon: Icon(
                          Icons.mail_outline_rounded,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      style: AppStyles.kFontWhite14w5,
                      maxLines: 1,
                      validator: (value) {
                        if (value!.length == 0) {
                          return 'Please Type your email'.tr + '...';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                    child: TextFormField(
                      controller: _loginController.password,
                      obscureText: _loginController.obscrure.value,
                      decoration: InputDecoration(
                        hintText: 'Password'.tr,
                        hintStyle: AppStyles.kFontWhite14w5,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.darkBlueColor,
                          ),
                        ),
                        errorStyle: AppStyles.kFontDarkBlue12w5,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _loginController.obscrure.value =
                                !_loginController.obscrure.value;
                          },
                          child: Icon(
                            _loginController.obscrure.value
                                ? Icons.lock
                                : Icons.lock_open,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      style: AppStyles.kFontWhite14w5,
                      maxLines: 1,
                      validator: (value) {
                        if (value?.length == 0) {
                          return 'Please Type your password.'.tr + '..';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: _loginController.isLoading.value
                        ? Center(
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                child: CupertinoActivityIndicator()))
                        : Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 5),
                            child: InkWell(
                              onTap: () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                } else {
                                  if (_settingsController.otpOnLogin.value) {
                                    Map data = {
                                      "type": "otp_on_login",
                                      "email":
                                          _loginController.email.value.text,
                                    };

                                    final OtpController otpController =
                                        Get.put(OtpController());

                                    _loginController.isLoading.value = true;

                                    await otpController
                                        .generateOtp(data)
                                        .then((value) {
                                      if (value == true) {
                                        _loginController.isLoading.value =
                                            false;
                                        Get.to(() => OtpVerificationPage(
                                              data: data,
                                              onSuccess: (result) async {
                                                if (result == true) {
                                                  var jsonString =
                                                      await _loginController
                                                          .fetchUserLogin(
                                                              email:
                                                                  _loginController
                                                                      .email
                                                                      .text,
                                                              password:
                                                                  _loginController
                                                                      .password
                                                                      .text)
                                                          .then((value) {
                                                    if (value == true) {
                                                      Get.back();
                                                    }
                                                  });
                                                  print(jsonString);
                                                }
                                              },
                                            ));
                                      } else {
                                        _loginController.isLoading.value =
                                            false;
                                        SnackBars()
                                            .snackBarWarning(value.toString());
                                      }
                                    });
                                  } else {
                                    var jsonString = await _loginController
                                        .fetchUserLogin(
                                            email: _loginController.email.text,
                                            password:
                                                _loginController.password.text)
                                        .then((value) {
                                      if (value == true) {
                                        Get.back();
                                      }
                                    });
                                    print(jsonString);
                                  }
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: Get.width,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Sign In'.tr,
                                      textAlign: TextAlign.center,
                                      style: AppStyles.kFontPink15w5),
                                ),
                              ),
                            ),
                          ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('Forget url: ${URLs.FORGOT_PASSWORD}');
                      Get.to(() => ForgotPasswordPage());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        'Forgot password?'.tr,
                        style: AppStyles.kFontWhite14w5,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.dialog(RegistrationPage(), useSafeArea: false);
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Don\'t have an account Yet?'.tr,
                                textAlign: TextAlign.center,
                                style: AppStyles.appFont.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sign Up'.tr,
                                textAlign: TextAlign.center,
                                style: AppStyles.appFont.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  AppConfig.facebookLogin || AppConfig.googleLogin
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: Get.width * 0.25,
                              child: Divider(
                                height: 0.5,
                                thickness: 1,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Or continue with",
                              style: AppStyles.kFontWhite12w5,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: Get.width * 0.25,
                              child: Divider(
                                height: 0.5,
                                thickness: 1,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppConfig.facebookLogin
                          ? InkWell(
                              onTap: () async {
                                final LoginResult result = await FacebookAuth
                                    .instance
                                    .login(); // by default we request the email and the public profile
                                if (result.status == LoginStatus.success) {
                                  _accessToken = result.accessToken!;

                                  final userData =
                                      await FacebookAuth.instance.getUserData();
                                  _userData = userData;

                                  final _getToken = FacebookResponse.fromJson(
                                    _accessToken!.toJson(),
                                  );

                                  final _getUser =
                                      FacebookUser.fromJson(userData);

                                  Map data = {
                                    "provider_id": _getUser.id,
                                    "provider_name": "facebook",
                                    "name": _getUser.name,
                                    "email": _getUser.email,
                                    "token": _getToken.token.toString(),
                                  };

                                  print(data);

                                  await _loginController
                                      .socialLogin(data)
                                      .then((value) async {
                                    if (value == true) {
                                      Get.back();
                                    } else {
                                      await FacebookAuth.instance.logOut();
                                    }
                                  });
                                } else {
                                  print(result.status);
                                  print(result.message);
                                }
                              },
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset(
                                      'assets/images/facebook_logo.png',
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                      SizedBox(
                        width: 20,
                      ),
                      AppConfig.googleLogin
                          ? InkWell(
                              onTap: () async {
                                try {
                                  GoogleSignInAccount? googleSignInAccount =
                                      await _googleSignIn.signIn();

                                  await googleSignInAccount!.authentication
                                      .then((value) async {
                                    log(value.idToken.toString());

                                    Map data = {
                                      "provider_id": googleSignInAccount.id,
                                      "provider_name": "google",
                                      "name": googleSignInAccount.displayName,
                                      "email": googleSignInAccount.email,
                                      "token": value.idToken.toString(),
                                    };

                                    await _loginController
                                        .socialLogin(data)
                                        .then((value) {
                                      if (value == true) {
                                        Get.back();
                                      } else {
                                        _googleSignIn.signOut();
                                      }
                                    });
                                  });
                                } catch (e, t) {
                                  debugPrint(e.toString());
                                  debugPrint(t.toString());
                                }

                                // await _googleSignIn.signOut().then((value) {
                                //   log(value.authHeaders.toString());
                                // });
                              },
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    padding: const EdgeInsets.all(12.0),
                                    child: Image.asset(
                                      'assets/images/google_logo.png',
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

String prettyPrint(Map json) {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');
  String pretty = encoder.convert(json);
  return pretty;
}

FacebookResponse facebookResponseFromJson(String str) =>
    FacebookResponse.fromJson(json.decode(str));

String facebookResponseToJson(FacebookResponse data) =>
    json.encode(data.toJson());

class FacebookResponse {
  FacebookResponse({
    required this.userId,
    required this.token,
  });

  String userId;
  String token;

  factory FacebookResponse.fromJson(Map<String, dynamic> json) =>
      FacebookResponse(
        userId: json["userId"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "token": token,
      };
}

FacebookUser facebookUserFromJson(String str) =>
    FacebookUser.fromJson(json.decode(str));

String facebookUserToJson(FacebookUser data) => json.encode(data.toJson());

class FacebookUser {
  FacebookUser({
    required this.email,
    required this.id,
    required this.name,
  });

  String email;
  String id;
  String name;

  factory FacebookUser.fromJson(Map<String, dynamic> json) => FacebookUser(
        email: json["email"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "id": id,
        "name": name,
      };
}
