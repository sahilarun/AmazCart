import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';
import 'package:http/http.dart' as http;

import '../../../config/config.dart';
import '../../../controller/cart_controller.dart';
import '../../../controller/checkout_controller.dart';
import '../../../widgets/snackbars.dart';
import '../../account/orders/OrderList/MyOrders.dart';

final CheckoutController _checkoutController = Get.put(CheckoutController());
final CartController cartController = Get.put(CartController());

class TabbyCheckoutNavParams {
  TabbyCheckoutNavParams({
    required this.selectedProduct,
  });

  final TabbyProduct selectedProduct;
}

class TabbyCheckoutPage extends StatefulWidget {
  const TabbyCheckoutPage({Key? key}) : super(key: key);

  @override
  State<TabbyCheckoutPage> createState() => _TabbyCheckoutPageState();
}

class _TabbyCheckoutPageState extends State<TabbyCheckoutPage> {
  late TabbyProduct selectedProduct;

  Future<void> onResult(WebViewResult resultCode) async {
    print('Tabby Response :::::: ${resultCode.name}');

    // "email": _checkoutController.orderData['customer_email'],
    // "phone": _checkoutController.orderData['customer_phone'],
    // controller.selectedGateway.value.id

    final String apiUrl = 'https://spn21.spondan.com/amazcart/api/tabby-checkout';

    final Map<dynamic, dynamic> requestData = _checkoutController.orderData;

    final response = await http.post(
      Uri.parse(URLs.TABBYURL),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 201) {

      SnackBars().snackBarSuccess("Order created successfully");
      Get.delete<CheckoutController>();
      await cartController.getCartList();
      Get.offAndToNamed('/');
      Get.to(() => MyOrders(0));

      // Successful response, handle the data as needed
      final responseData = jsonDecode(response.body);
      print('Response Tabby: ${responseData}');
    } else {
      SnackBars().snackBarSuccess("Order create unsuccessfully");
      // Handle error response
      print('Error: ${response.statusCode}');
    }


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(resultCode.name),
      ),
    );
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ModalRoute.of(context)!.settings;
    selectedProduct =
        (settings.arguments as TabbyCheckoutNavParams).selectedProduct;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tabby Checkout'),
      ),
      body: TabbyWebView(
        webUrl: selectedProduct.webUrl,
        onResult: onResult,
      ),
    );
  }
}
