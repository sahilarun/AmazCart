import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/AppConfig/api_keys.dart';
import 'package:amazcart/controller/account_controller.dart';
import 'package:amazcart/controller/address_book_controller.dart';
import 'package:amazcart/controller/checkout_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/controller/otp_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/controller/payment_gateway_controller.dart';
import 'package:amazcart/model/NewModel/GpayTokenModel.dart';
import 'package:amazcart/model/PaymentGatewayModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/authentication/OtpVerificationPage.dart';
import 'package:amazcart/view/payment/bank_payment_sheet.dart';
import 'package:amazcart/view/payment/instamojo_payment.dart';
import 'package:amazcart/view/payment/jazzcash.dart';
import 'package:amazcart/view/payment/midtrans_payment.dart';
import 'package:amazcart/view/payment/paypal/paypal_payment.dart';
import 'package:amazcart/view/payment/paytm_service.dart';
import 'package:amazcart/view/payment/razorpay_sheet.dart';
import 'package:amazcart/view/payment/stripe/stripe_payment.dart';
import 'package:amazcart/view/payment/gpay_service.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:amazcart/widgets/PinkButtonWidget.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:get/get.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';
import 'package:http/http.dart' as http;

import '../payment/tabby/create_session.dart';

class GatewaySelection extends StatefulWidget {
  @override
  _GatewaySelectionState createState() => _GatewaySelectionState();
}

class _GatewaySelectionState extends State<GatewaySelection> {
  final PaymentGatewayController controller =
      Get.put(PaymentGatewayController());
  final AddressController addressController = Get.put(AddressController());

  final GeneralSettingsController _settingsController =
      Get.put(GeneralSettingsController());

  final LoginController _loginController = Get.put(LoginController());
  final AccountController _accountController = Get.put(AccountController());
  final CheckoutController _checkoutController = Get.put(CheckoutController());

  final plugin = PaystackPlugin();

  bool selectedGooglePay = false;

  int radioSelector = 0;

  @override
  void initState() {
    plugin.initialize(publicKey: payStackPublicKey);
    _checkoutController.orderData.addAll({
      'wallet_amount': 'wallet_amount',
      'payment_id': 'id',
    });
    // print(_checkoutController.orderData);
    super.initState();
  }

  bool selected = false;

  final _paymentItems = <PaymentItem>[];

  setSelectedMethod(Gateway gateWay) {
    setState(() {
      controller.selectedGateway.value = gateWay;
      selected = true;
    });

    if (controller.selectedGateway.value.id == 13) {
      _paymentItems.add(PaymentItem(
        amount: _checkoutController.orderData['grand_total'].toString(),
        label: "${AppConfig.appName}" + "Order",
        status: PaymentItemStatus.final_price,
      ));
      setState(() {
        selectedGooglePay = true;
      });
      print(_paymentItems[0].amount);
    } else {
      _paymentItems.clear();
      setState(() {
        selectedGooglePay = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: 'Select Gateway'.tr,
      ),
      body: Obx(() {
        if (controller.isPaymentGatewayLoading.value) {
          return Center(child: CustomLoadingWidget());
        } else {
          return ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: controller.gatewayList.length,
              padding: EdgeInsets.only(top: 8),
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 8,
                );
              },
              itemBuilder: (BuildContext context, int position) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 0.2,
                      color: controller.gatewayList[position] ==
                              controller.gatewayList[radioSelector]
                          ? Get.textTheme.titleMedium!.color!
                          : Get.theme.canvasColor,
                    ),
                  ),
                  child: RadioListTile<Gateway>(
                    value: controller.gatewayList[position],
                    activeColor: AppStyles.pinkColor,
                    groupValue: controller.selectedGateway.value,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    onChanged: (value) {
                      setState(() {
                        radioSelector = position;
                      });
                      setSelectedMethod(value!);
                      print('${value.id} = ${value.method}');
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(controller.gatewayList[position].method ?? ''),
                        Expanded(child: Container()),
                        Container(
                          height: 35,
                          width: 50,
                          child: FadeInImage(
                            image: NetworkImage(AppConfig.assetPath +
                                '/' +
                                '${controller.gatewayList[position].logo}'),
                            placeholder: AssetImage("${AppConfig.appBanner}"),
                            fit: BoxFit.fitWidth,
                            imageErrorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Image.asset('${AppConfig.appBanner}');
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                );
              });
        }
      }),
      bottomNavigationBar: Material(
        elevation: 20,
        child: Container(
          height: 70,
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Total'.tr + ": ",
                          textAlign: TextAlign.center,
                          style: AppStyles.appFont.copyWith(
                            fontSize: 17,
                            color: AppStyles.blackColor,
                          ),
                        ),
                        Obx(() {
                          if (controller.checkoutController.isLoading.value) {
                            return Center(
                              child: Container(),
                            );
                          } else {
                            if (controller.checkoutController.checkoutModel
                                        .value.packages ==
                                    null ||
                                controller.checkoutController.checkoutModel
                                        .value.packages?.length ==
                                    0) {
                              return Container();
                            } else {
                              return Text(
                                '${(controller.checkoutController.grandTotal.value * _settingsController.conversionRate.value).toStringAsFixed(2)}${_settingsController.appCurrency.value}',
                                textAlign: TextAlign.center,
                                style: AppStyles.appFont.copyWith(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppStyles.darkBlueColor,
                                ),
                              );
                            }
                          }
                        })
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 3),
                      child: Text(
                        'VAT/TAX/GST included, where applicable'.tr,
                        style: AppStyles.kFontGrey12w5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5),
              Obx(() {
                if (controller.isPaymentProcessing.value) {
                  return SizedBox.shrink();
                } else {
                  return selectedGooglePay
                      ? Platform.isAndroid
                          ? GooglePayButton(
                              width: 100,
                              height: 50,
                              onError: (Object? error) {
                                debugPrint(error.toString());
                              },
                              childOnError: const Text('errror'),
                              onPressed: () {
                                debugPrint('pressed');
                              },
                              paymentConfigurationAsset:
                                  "payment/google_pay.json",
                              paymentItems: _paymentItems,
                              // style: GooglePayButtonStyle.white,
                              type: GooglePayButtonType.pay,
                              margin: EdgeInsets.symmetric(vertical: 10),
                              onPaymentResult: (paymentResult) async {
                                final data = jsonEncode(paymentResult);
                                final gpayTokenModel =
                                    gpayTokenModelFromJson(data);

                                final tokenModel = tokenFromJson(jsonDecode(
                                    jsonEncode(gpayTokenModel.paymentMethodData
                                        ?.tokenizationData?.token)));

                                log(tokenModel.id ?? '');

                                await GooglePaymentIntentConfirm()
                                    .postGpayPaymentIntent(
                                        email: addressController
                                                .billingAddress.value.email ??
                                            '',
                                        orderAmount: _checkoutController
                                            .orderData['grand_total']
                                            .toString(),
                                        token: tokenModel.id ?? '')
                                    .then((value) async {
                                  print(value.paymentIntent?.id);

                                  Map payment = {
                                    'amount': _checkoutController
                                        .orderData['grand_total'],
                                    'payment_method':
                                        controller.selectedGateway.value.id,
                                    'transection_id':
                                        '${value.paymentIntent?.id}'
                                  };
                                  _checkoutController.orderData.addAll({
                                    'payment_method':
                                        controller.selectedGateway.value.id,
                                  });

                                  await controller.paymentInfoStore(
                                    paymentData: payment,
                                    transactionID:
                                        value.paymentIntent?.id ?? '',
                                  );
                                });
                              },
                              loadingIndicator: Center(
                                child: CustomLoadingWidget(),
                              ),
                            )
                          : ApplePayButton(
                              paymentConfigurationAsset:
                                  'payment/apple_pay.json',
                              paymentItems: _paymentItems,
                              // style: ApplePayButtonStyle.black,
                              // type: ApplePayButtonType.buy,
                              margin: const EdgeInsets.only(top: 15.0),
                              onPaymentResult: (paymentResult) {
                                debugPrint(paymentResult.toString());
                              },
                              loadingIndicator: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                      : PinkButtonWidget(
                          height: 40,
                          btnText: 'Order Confirm'.tr,
                          btnOnTap: () async {
                            if (_settingsController.goldPriceModule.value) {
                              print(_settingsController.goldPriceModule.value);
                              await controller.checkPrice().then((value) async {
                                print('price update -> $value');
                                if (value > 0) {
                                  await _checkoutController.getCheckoutList();
                                  Get.back();
                                  SnackBars().snackBarWarning(
                                      "Cart Price updated. Please check prices and shipping again.");
                                } else {
                                  await orderConfirmSubmit();
                                }
                              });
                            } else {
                              await orderConfirmSubmit();
                            }
                          },
                        );
                }
              }),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future orderConfirmSubmit() async {
    print(controller.selectedGateway.value.id);

    /// Cash on delivery
    if (controller.selectedGateway.value.id == 1) {
      _checkoutController.orderData.addAll({
        'payment_method': controller.selectedGateway.value.id,
      });
      Map payment = {
        'amount': _checkoutController.orderData['grand_total'],
        'payment_method': controller.selectedGateway.value.id,
      };

      if (_settingsController.otpOnOrderWithCod.value) {
        int cancelOrders =
            _accountController.customerData.value.cancelOrderCount ?? 0;

        if (_loginController.profileData.value.isVerified == 1 &&
            _settingsController.otpOrderOnVerifiedCustomer.value &&
            _settingsController.orderCancelLimitOnVerified.value <
                cancelOrders) {
          Map data = {
            "type": "otp_on_order_with_cod",
            "email": _checkoutController.orderData['customer_email'],
            "name": _checkoutController.orderData['customer_name'],
            "phone": _checkoutController.orderData['customer_phone'],
          };

          final OtpController otpController = Get.put(OtpController());

          EasyLoading.show(
              maskType: EasyLoadingMaskType.none,
              indicator: CustomLoadingWidget());

          await otpController.generateOtp(data).then((value) {
            if (value == true) {
              EasyLoading.dismiss();
              Get.to(() => OtpVerificationPage(
                    data: data,
                    onSuccess: (result) async {
                      if (result == true) {
                        await controller.paymentInfoStore(
                          paymentData: payment,
                          transactionID: '',
                        );
                      }
                    },
                  ));
            } else {
              EasyLoading.dismiss();
              SnackBars().snackBarWarning(value.toString());
            }
          });
        } else if (_loginController.profileData.value.isVerified == 0) {
          Map data = {
            "type": "otp_on_order_with_cod",
            "email": _checkoutController.orderData['customer_email'],
            "name": _checkoutController.orderData['customer_name'],
            "phone": _checkoutController.orderData['customer_phone'],
          };

          final OtpController otpController = Get.put(OtpController());

          EasyLoading.show(
              maskType: EasyLoadingMaskType.none,
              indicator: CustomLoadingWidget());

          await otpController.generateOtp(data).then((value) {
            if (value == true) {
              EasyLoading.dismiss();
              Get.to(() => OtpVerificationPage(
                    data: data,
                    onSuccess: (result) async {
                      if (result == true) {
                        await controller.paymentInfoStore(
                          paymentData: payment,
                          transactionID: '',
                        );
                      }
                    },
                  ));
            } else {
              EasyLoading.dismiss();
              SnackBars().snackBarWarning(value.toString());
            }
          });
        }
      } else {
        await controller.paymentInfoStore(
          paymentData: payment,
          transactionID: '',
        );
      }
    }

    /// Wallet
    else if (controller.selectedGateway.value.id == 2) {
      final AccountController _accountController = Get.put(AccountController());

      await _accountController.getAccountDetails().then((value) async {
        if (double.parse(
                    _checkoutController.orderData['grand_total'].toString())
                .toDouble() >
            (_accountController.customerData.value.walletRunningBalance ?? 0)) {
          SnackBars()
              .snackBarWarning("You dont have sufficient wallet balance".tr);
        } else {
          _checkoutController.orderData.addAll({
            'wallet_amount':
                _accountController.customerData.value.walletRunningBalance,
            'payment_method': 2,
          });
          log(_checkoutController.orderData.toString());

          Map payment = {
            'amount': _checkoutController.orderData['grand_total'],
            'payment_method': controller.selectedGateway.value.id,
          };

          await controller.paymentInfoStore(
            paymentData: payment,
            transactionID: '',
          );
        }
      });
    }

    ///Paypal
    else if (controller.selectedGateway.value.id == 3) {
      Map payment = {
        'amount': _checkoutController.orderData['grand_total'],
        'payment_method': controller.selectedGateway.value.id,
      };
      _checkoutController.orderData.addAll({'payment_method': 3});
      Get.to(
        () => PaypalPayment(
          onFinish: (number) async {
            payment.addAll({
              'transection_id': number,
            });
            await controller.paymentInfoStore(
                paymentData: payment, transactionID: number);
          },
        ),
      );
    }

    ///Stripe
    else if (controller.selectedGateway.value.id == 4) {
      _checkoutController.orderData.addAll({
        'payment_method': controller.selectedGateway.value.id,
      });
      Map payment = {
        'amount': _checkoutController.orderData['grand_total'],
        'payment_method': controller.selectedGateway.value.id,
      };

      int amount = (double.parse(_checkoutController.orderData['grand_total'] != null?
                  _checkoutController.orderData['grand_total'].toString() : "0.0") *
              100)
          .toInt();

      String transactionId = await MyStripePayment().makePayment(
        amount: amount,
      );

      print('my final transaction is:::::: $transactionId');

      if (transactionId.isNotEmpty) {
        payment.addAll({
          'transection_id': transactionId,
        });
        await controller.paymentInfoStore(
          paymentData: payment,
          transactionID: transactionId,
        );
      } else {
        showAlertDialog(
          context,
          "Error",
          "Something wrong",
        );
      }
    }

    ///PayStack
    else if (controller.selectedGateway.value.id == 5) {
      _checkoutController.orderData.addAll({
        'payment_method': controller.selectedGateway.value.id,
      });
      final finalAmount =
          (_checkoutController.orderData['grand_total'] * 100).toInt();
      Charge charge = Charge()
        ..amount = finalAmount
        ..currency = 'ZAR'
        ..reference = _getReference()
        ..email = _checkoutController.orderData['customer_email'];
      CheckoutResponse response = await plugin.checkout(
        context,
        method: CheckoutMethod.card,
        // Defaults to CheckoutMethod.selectable
        charge: charge,
      );

      if (response.status == true) {
        print(response.reference);
        Map payment = {
          'amount': _checkoutController.orderData['grand_total'],
          'payment_method': controller.selectedGateway.value.id,
          'transection_id': response.reference,
        };
        await controller.paymentInfoStore(
            paymentData: payment, transactionID: response.reference ?? '');
      } else {
        SnackBars().snackBarWarning(response.message);
      }
    }

    ///Razorpay
    else if (controller.selectedGateway.value.id == 6) {
      _checkoutController.orderData.addAll({
        'payment_method': controller.selectedGateway.value.id,
      });
      Get.bottomSheet(
        RazorpaySheet(
          orderData: _checkoutController.orderData,
        ),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        persistent: true,
      );
    }

    ///Bank Payment
    else if (controller.selectedGateway.value.id == 7) {
      _checkoutController.orderData.addAll({
        'payment_method': controller.selectedGateway.value.id,
      });
      await controller.getBankInfo();
      Get.bottomSheet(
        BankPaymentSheet(
          orderData: _checkoutController.orderData,
        ),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        persistent: true,
      );
    }

    ///Instamojo
    else if (controller.selectedGateway.value.id == 8) {
      Map payment = {
        'amount': _checkoutController.orderData['grand_total'],
        'payment_method': controller.selectedGateway.value.id,
      };
      _checkoutController.orderData.addAll({'payment_method': 8});
      Get.to(
        () => InstaMojoPayment(
          orderData: _checkoutController.orderData,
          paymentData: payment,
          onFinish: (number) async {
            if (number != null) {
              payment.addAll({
                'transection_id': number,
              });
              print(payment);
              await controller.paymentInfoStore(
                  paymentData: payment, transactionID: number);
            }
          },
        ),
      );
    }

    ///PayTM
    else if (controller.selectedGateway.value.id == 9) {
      _checkoutController.orderData.addAll({'payment_method': 9});

      final orderId = "PayTM_${DateTime.now().millisecondsSinceEpoch}";

      String callBackUrl = (payTmIsTesting
              ? 'https://securegw-stage.paytm.in'
              : 'https://securegw.paytm.in') +
          '/theia/paytmCallback?ORDER_ID=' +
          orderId;

      Map payment = {
        'orderId': orderId,
        'amount': double.parse(
                _checkoutController.orderData['grand_total'].toString())
            .toStringAsFixed(2),
        'payment_method': controller.selectedGateway.value.id,
        "custID": "USER_" +
            addressController.shippingAddress.value.customerId.toString(),
        "custEmail": _checkoutController.orderData['customer_email'],
        "custPhone": _checkoutController.orderData['customer_phone'],
        'callbackUrl': callBackUrl,
      };

      await PayTmService().payTmPayment(
        trxData: payment,
        orderData: _checkoutController.orderData,
      );
    }

    ///Midtrans
    else if (controller.selectedGateway.value.id == 10) {
      _checkoutController.orderData.addAll({'payment_method': 10});

      Map payment = {
        'amount': _checkoutController.orderData['grand_total'],
        'payment_method': controller.selectedGateway.value.id,
      };

      Get.to(
        () => MidTransPaymentPage(
          orderData: _checkoutController.orderData,
          paymentData: payment,
          onFinish: (number) async {
            if (number != null) {
              payment.addAll({
                'transection_id': number,
              });
              print(payment);
              await controller.paymentInfoStore(
                  paymentData: payment, transactionID: number);
            }
          },
        ),
      );
    }

    ///PayUMoney
    else if (controller.selectedGateway.value.id == 11) {
      _checkoutController.orderData.addAll({'payment_method': 11});

      // Map payment = {
      //   'amount': _checkoutController.orderData['grand_total'],
      //   'payment_method': controller.selectedGateway.value.id,
      // };

      // await initPlatformState();
    }

    ///Jazzcash
    else if (controller.selectedGateway.value.id == 12) {
      _checkoutController.orderData.addAll({
        'payment_method': controller.selectedGateway.value.id,
      });
      Get.bottomSheet(
        JazzCashSheet(
          orderData: _checkoutController.orderData,
        ),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        persistent: true,
      );
    }

    ///Flutter wave
    else if (controller.selectedGateway.value.id == 14) {
      final AddressController addressController = Get.put(AddressController());
      _checkoutController.orderData.addAll({
        'payment_method': controller.selectedGateway.value.id,
      });
      try {
        final String currency = "NGN";

        Flutterwave flutterwave = Flutterwave(
          context: this.context,
          publicKey: flutterWavePublicKey,
          currency: currency,
          paymentOptions: "card, payattitude, barter",
          customization: Customization(title: "Cart Payment"),
          amount: _checkoutController.orderData['grand_total'].toString(),
          customer: Customer(
              name: addressController.shippingAddress.value.name ?? '',
              phoneNumber: _checkoutController.orderData['customer_phone'],
              email: _checkoutController.orderData['customer_email']),
          txRef: 'AMZ_${DateFormat("yyyyMMddHHmmss").format(DateTime.now())}', isTestMode: false, redirectUrl: '',
        );

        final ChargeResponse response = await flutterwave.charge();
        print(response.txRef);

        if (response.txRef != null) {
          Map payment = {
            'amount': _checkoutController.orderData['grand_total'],
            'payment_method': controller.selectedGateway.value.id,
            'transection_id': response.txRef,
          };
          controller.paymentInfoStore(
              paymentData: payment, transactionID: response.txRef ?? '');
        }
      } catch (error) {
        print("ERROR =>  ${error.toString()}");
      }
    }

    else if(controller.selectedGateway.value.id == 15) {
      final AddressController addressController = Get.put(AddressController());
      _checkoutController.orderData.addAll({
        'payment_method': controller.selectedGateway.value.id,
      });
      Get.bottomSheet(
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)), // Set the desired border radius.
          child: Container(
            height: Get.height * 0.5,
            color: Colors.white,
            child: CreateSessionScreen(),
          ),
        ),
        isScrollControlled: true,
        enableDrag: false,
      );

    }

  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'AMZ-${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              }, // dismiss dialog
            ),
          ],
        );
      },
    );
  }
}
