import 'dart:convert';
import 'dart:developer';

import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/checkout_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/model/NewModel/BankInformationModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/model/PaymentGatewayModel.dart';
import 'package:amazcart/model/PaymentStoreModel.dart';
import 'package:amazcart/view/account/orders/OrderList/MyOrders.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class PaymentGatewayController extends GetxController {
  final CheckoutController checkoutController = Get.put(CheckoutController());
  final CartController cartController = Get.put(CartController());
  final GeneralSettingsController settingsController =
      Get.put(GeneralSettingsController());

  var isPaymentGatewayLoading = false.obs;
  var gateway = PaymentGatewayModel().obs;

  var bank = BankInformationModel().obs;

  var gatewayList = <Gateway>[].obs;

  var tokenKey = 'token';

  GetStorage userToken = GetStorage();

  var paymentProcessing = false.obs;

  DIO.Response? response;
  DIO.Dio dio = new DIO.Dio();

  Rx<Gateway> selectedGateway = Gateway().obs;

  Future<PaymentGatewayModel> getPaymentGateway() async {
    Uri userData = Uri.parse(URLs.PAYMENT_GATEWAY);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    print(response.statusCode.toString() + "By getx --- getGateway()");
    var jsonString = jsonDecode(response.body);
    return PaymentGatewayModel.fromJson(jsonString);
  }

  Future<BankInformationModel> getBankInfo() async {
    Uri userData = Uri.parse(URLs.BANK_INFO);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    print(response.statusCode.toString() + "By getx --- getBankInfo()");
    var jsonString = jsonDecode(response.body);
    var bankInfo = BankInformationModel.fromJson(jsonString);
    bank.value = bankInfo;
    return bank.value;
  }

  Future<PaymentGatewayModel> getGatewayList() async {
    print('gateway get');
    try {
      isPaymentGatewayLoading(true);
      var gateways = await getPaymentGateway();
      if (gateways != null) {
        gateway.value = gateways;

        gatewayList.value = gateways.data!
            .where((element) => element.activeStatus == 1)
            .toList();

        checkoutController.checkoutModel.value.packages?.forEach((key, value) {
          value.items?.forEach((value2) {
            print(value2.productType);
            if (value2.productType == ProductType.GIFT_CARD) {
              print('prod typ ${value2.productType}');
              gatewayList.remove(gatewayList[0]);
            }
          });
        });
        selectedGateway.value = gatewayList.first;
      } else {
        gateway.value = PaymentGatewayModel();
      }
      return gateways;
    } finally {
      isPaymentGatewayLoading(false);
    }
  }

  RxBool isPaymentProcessing = false.obs;

  Future paymentInfoStore({required Map paymentData, required String transactionID}) async {
    isPaymentProcessing(true);

    await paymentStore(
      paymentData: paymentData,
      transactionID: transactionID,
    );
  }

  Future paymentStore({required Map paymentData, required String transactionID}) async {
    print('Trasnscation ID: $transactionID');
    String token = await userToken.read(tokenKey);
    Uri userData = Uri.parse(URLs.ORDER_PAYMENT_STORE);

    if (transactionID == null || transactionID.isEmpty) {
      paymentData.addAll(
          {'transection_id': 'AMZ-${DateTime.now().millisecondsSinceEpoch}'});
    }
    print(paymentData);
    var body = json.encode(paymentData);
    var response = await http.post(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    var jsonString = jsonDecode(response.body);
    // print(jsonString);
    print(response.statusCode);
    if (response.statusCode == 201) {
      var data = PaymentStore.fromJson(jsonString);
      print('PAYMENT ID ${data.paymentInfo?.id}');

      checkoutController.orderData.addAll({
        'payment_id': data.paymentInfo?.id,
      });

      await submitOrder(checkoutController.orderData);

      isPaymentProcessing(false);

      return true;
    } else {
      SnackBars().snackBarError(jsonString['message']);
      return false;
    }
  }

  Future<int> checkPrice() async {
    String token = await userToken.read(tokenKey);

    Uri url = Uri.parse(URLs.CHECK_PRICE_UPDATE);

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    var jsonString = jsonDecode(response.body);

    return jsonString['count'];
  }

  Future submitOrder(data) async {
    print('cash on delevery------>2');
    // print(data);
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey);

    final m = new Map<String, dynamic>.from(data);

    final DIO.FormData formData = DIO.FormData.fromMap(m);

    try {
      response = await dio.post(URLs.ORDER_STORE,
          options: DIO.Options(
            followRedirects: false,
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
              'Content-Type': 'multipart/form-data',
            },
          ),
          data: formData);
      print('cash on delevery------>3');
      print(response!.statusCode);
      print(response!.data);
      if (response!.statusCode == 201) {
        SnackBars().snackBarSuccess("Order created successfully");
        Get.delete<CheckoutController>();
        await cartController.getCartList();
        Get.offAndToNamed('/');
        Get.to(() => MyOrders(0));
      }
    } on DIO.DioError catch (e) {
      print('cash on delevery------>error');
      if (e.response!.statusCode == 404) {
        print(e.response!.statusCode);
      } else {
        print(e.message);
        print(e.response);
        SnackBars().snackBarError(e.response!.statusMessage);
      }
    }

    EasyLoading.dismiss();
    // Get.offAndToNamed('/');
    // Get.to(() => MainNavigation(
    //   navIndex: 2,
    // ));
  }

  @override
  void onInit() {
    getGatewayList();
    super.onInit();
  }
}
