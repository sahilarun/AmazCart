import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/otp_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/authentication/OtpVerificationPage.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordPage extends GetView<LoginController> {
  final LoginController _loginController = Get.put(LoginController());

  final GeneralSettingsController _settingsController =
      Get.put(GeneralSettingsController());

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
                    'Reset Password'.tr,
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
                          color: Colors.red,
                        ),
                      ),
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
                    style: AppStyles.kFontWhite14w5
                        .copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    validator: (value) {
                      if (value?.length == 0) {
                        return 'Please Type something'.tr + '...';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
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
                              if (_settingsController
                                  .otpOnPasswordReset.value) {
                                Map data = {
                                  "type": "otp_on_password_reset",
                                  "email": _loginController.email.value.text,
                                };

                                final OtpController otpController =
                                    Get.put(OtpController());

                                _loginController.isLoading.value = true;

                                await otpController
                                    .generateOtp(data)
                                    .then((value) {
                                  if (value == true) {
                                    _loginController.isLoading.value = false;
                                    Get.to(() => OtpVerificationPage(
                                          data: data,
                                          onSuccess: (result) async {
                                            if (result == true) {
                                              var jsonString =
                                                  await _loginController
                                                      .forgotPassword()
                                                      .then((value) {
                                                if (value == true) {
                                                  SnackBars().snackBarSuccess(
                                                      "Reset password link sent"
                                                          .tr);
                                                } else {
                                                  SnackBars().snackBarError(
                                                      value.toString());
                                                }
                                              });
                                              print(jsonString);
                                            }
                                          },
                                        ));
                                  } else {
                                    _loginController.isLoading.value = false;
                                    SnackBars()
                                        .snackBarWarning(value.toString());
                                  }
                                });
                              } else {
                                var jsonString = await _loginController
                                    .forgotPassword()
                                    .then((value) {
                                  if (value == true) {
                                    SnackBars().snackBarSuccess(
                                        "Reset password link sent".tr);
                                  }
                                });
                                print(jsonString);
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
                                child: Text('Send'.tr,
                                    textAlign: TextAlign.center,
                                    style: AppStyles.kFontPink15w5),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
