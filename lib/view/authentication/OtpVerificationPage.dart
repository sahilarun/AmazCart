import 'dart:async';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/controller/otp_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';

class OtpVerificationPage extends StatefulWidget {
  final Function(bool)? onSuccess;
  final Map? data;

  OtpVerificationPage({this.data, this.onSuccess});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final LoginController _loginController = Get.put(LoginController());

  final OtpController _otpController = Get.put(OtpController());

  final GeneralSettingsController _settingsController =
      Get.put(GeneralSettingsController());

  final CountDownController _countDownController = CountDownController();

  String enteredOtp = '';

  bool timedOut = false;

  int? _validationTime;

  // Timer _timer;

  @override
  void initState() {
    _validationTime = _settingsController.otpCodeValidationTime.value * 60;
    Future.delayed(Duration(seconds: 1), () {
      _countDownController.start();
    });
    super.initState();
  }

  // void startTimer() {
  //   setState(() {
  //     _timer = Timer.periodic(
  //       const Duration(seconds: 1),
  //       (Timer timer) {
  //         if (_validationTime == 0) {
  //           setState(() {
  //             timedOut = true;
  //             timer.cancel();
  //           });
  //         } else {
  //           setState(() {
  //             _validationTime--;
  //           });
  //         }
  //       },
  //     );
  //   });
  // }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Enter 6-digit verification code',
                      textAlign: TextAlign.left,
                      style: AppStyles.appFont.copyWith(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                // Text("${intToTimeLeft(_validationTime)}"),

                CircularCountDownTimer(
                  duration: _validationTime ?? 0,
                  initialDuration: 0,
                  controller: _countDownController,
                  width: 40,
                  height: 40,
                  ringColor: Colors.grey[300] ?? Colors.grey,
                  ringGradient: null,
                  fillColor: AppStyles.pinkColor,
                  fillGradient: null,
                  backgroundColor: Colors.white,
                  backgroundGradient: null,
                  strokeWidth: 4.0,
                  strokeCap: StrokeCap.round,
                  textStyle: TextStyle(
                    fontSize: 10.0,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                  textFormat: CountdownTextFormat.MM_SS,
                  isReverse: true,
                  isReverseAnimation: true,
                  isTimerTextShown: true,
                  autoStart: false,
                  onComplete: () {

                    setState(() {
                      timedOut = true;
                      // _timer.cancel();
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'Enter the verification code, we have sent to'.tr,
                textAlign: TextAlign.left,
                style: AppStyles.appFont.copyWith(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                ' ${_loginController.email.value.text.toString()}',
                textAlign: TextAlign.left,
                style: AppStyles.appFont.copyWith(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            PinCodeTextField(
              appContext: context,
              length: 6,
              obscureText: false,
              animationType: AnimationType.fade,
              keyboardType: TextInputType.number,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                selectedFillColor: AppStyles.textFieldFillColor,
                activeColor: AppStyles.textFieldFillColor,
                activeFillColor: Colors.white,
                inactiveFillColor: AppStyles.textFieldFillColor,
                borderWidth: 1,
              ),
              animationDuration: Duration(milliseconds: 300),
              cursorColor: Colors.black,
              cursorWidth: 1.0,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              enableActiveFill: true,
              onChanged: (String value) {
                if (value != null) {
                  enteredOtp = value.toString();
                }
              },
            ),
            SizedBox(
              height: Get.height * 0.24,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                color: Color(0xFFFF3364),
                child: Text(
                  "Submit".tr,
                  style: AppStyles.appFont.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onTap: () {
                if (timedOut == true) {
                  SnackBars().snackBarWarning(
                    "OTP Timed out. Please resend OTP".tr,
                  );
                } else {
                  bool isCorrectOTP =
                      _otpController.resultChecker(int.parse(enteredOtp));

                  if (isCorrectOTP) {
                    Get.back(result: widget.onSuccess!(true));
                  } else {
                    SnackBars().snackBarWarning(
                      "OTP does not match".tr,
                    );
                  }
                }
              },
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  timedOut = false;

                  // _timer.cancel();

                  _validationTime =
                      _settingsController.otpCodeValidationTime.value * 60;

                  print(_validationTime.toString());

                  // _timer = Timer.periodic(
                  //   const Duration(seconds: 1),
                  //   (Timer timer) {
                  //     if (_validationTime == 0) {
                  //       setState(() {
                  //         timedOut = true;
                  //         timer.cancel();
                  //       });
                  //     } else {
                  //       setState(() {
                  //         _validationTime--;
                  //       });
                  //     }
                  //   },
                  // );
                });

                await _otpController.generateOtp(widget.data!).then((value) {
                  if (value) {
                    _countDownController.restart();
                  }
                });
              },
              child: Container(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  "Resend OTP".tr,
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.pinkColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
