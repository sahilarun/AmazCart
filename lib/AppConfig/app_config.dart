import 'package:flutter/material.dart';

class AppConfig {
  static const String hostUrl = 'https://spn21.spondan.com/amazcart';

  static String appName = 'Amazcart';

  static String loginBackgroundImage = 'assets/config/login_bg.png';

  static String appLogo = 'assets/config/splash_screen_logo.png';

  static String appBanner = 'assets/config/app_banner.png';

  static const String assetPath = hostUrl + '/public';

  static Color loginScreenBackgroundGradient1 = Color(0xffFF3566);

  static Color loginScreenBackgroundGradient2 = Color(0xffD7365C);

  static String appColorScheme = "#FF3364";

  static const String privacyPolicyUrl =
      'https://spn21.spondan.com/amazcart/privacy-policy';

  static bool googleLogin = false;

  static bool facebookLogin = false;

  static bool isDemo = false;

  static String tabbyMerchantCode = 'FONCY';
}
