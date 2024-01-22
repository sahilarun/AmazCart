import 'dart:convert';
import 'dart:math';

import 'package:amazcart/config/config.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class OtpController extends GetxController {
  int? otp, _minOtpValue, _maxOtpValue;

  var tokenKey = 'token';

  GetStorage userToken = GetStorage();

  Future<dynamic> generateOtp(Map data,
      [int min = 100000, int max = 999999]) async {
    _minOtpValue = min;
    _maxOtpValue = max;
    otp = (_minOtpValue! + Random().nextInt(_maxOtpValue! - _minOtpValue!));

    print(data);

    data.addAll({
      'code': otp,
    });

    var body = jsonEncode(data);

    var response = await http.post(
      Uri.parse(URLs.OTP_SEND),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: body,
    );
    print(response.statusCode.toString() + "By getx");

    if (response.statusCode == 200) {
      SnackBars().snackBarSuccess("OTP Sent!".tr);

      return true;
    } else if (response.statusCode == 422) {
      final errorData = jsonDecode(response.body);

      String combinedMessage = "";

      errorData["errors"].forEach((key, messages) {
        for (var message in messages)
          combinedMessage = combinedMessage + "$message\n";
      });
      return combinedMessage;
    } else {
      final errorData = jsonDecode(response.body);

      print(response.body);

      String combinedMessage = "";

      errorData["errors"].forEach((key, messages) {
        for (var message in messages)
          combinedMessage = combinedMessage + "$message\n";
      });
      return combinedMessage;
    }
  }

  bool resultChecker(int enteredOtp) {
    //To validate OTP
    return enteredOtp == otp;
  }
}
