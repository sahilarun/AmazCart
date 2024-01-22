import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/authentication/OtpVerificationPage.dart';
import 'package:amazcart/widgets/ButtonWidget.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpPage extends StatefulWidget {
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _formKey = GlobalKey<FormState>();

  String countryCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
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
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'What is your phone number?'.tr,
                textAlign: TextAlign.left,
                style: AppStyles.appFont.copyWith(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Form(
              key: _formKey,
              child: Container(
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xffF6FAFC),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
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
                      prefixIcon: CountryCodePicker(
                        dialogBackgroundColor: Colors.white,
                        dialogTextStyle: AppStyles.appFont.copyWith(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                        barrierColor: Colors.white,
                        onChanged: (value) {
                          setState(() {
                            countryCode = value.code ?? '';
                          });
                        },
                        initialSelection: 'US',
                        showCountryOnly: false,
                        showOnlyCountryWhenClosed: false,
                        flagWidth: 35,
                        textStyle: AppStyles.appFont.copyWith(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      hintText: 'Enter your mobile number',
                      hintMaxLines: 4,
                      hintStyle: AppStyles.appFont.copyWith(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    style: AppStyles.appFont.copyWith(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                    validator: (value) {
                      if (value?.length == 0) {
                        return 'Please Enter your Mobile Number'.tr;
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                'We will send a code to your mobile number',
                textAlign: TextAlign.left,
                style: AppStyles.appFont.copyWith(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.24,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ButtonWidget(
        buttonText: 'Next'.tr,
        onTap: () async {
          generateOtp();
        },
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      ),
    );
  }

  Future<dynamic> generateOtp([int min = 100000, int max = 999999]) async {
    Get.to(() => OtpVerificationPage(
          onSuccess: (result) async {
            if (result == true) {}
          },
        ));
  }
}
