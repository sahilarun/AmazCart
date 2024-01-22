import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/view/payment/tabby/tabby_checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';

import '../../../controller/checkout_controller.dart';
import 'mock_payload.dart';

final CheckoutController _checkoutController = Get.put(CheckoutController());

class CreateSessionScreen extends StatefulWidget {
  const CreateSessionScreen({Key? key}) : super(key: key);

  @override
  State<CreateSessionScreen> createState() => _CreateSessionScreenState();
}

class _CreateSessionScreenState extends State<CreateSessionScreen> {
  String _status = 'idle';
  TabbySession? session;
  late Lang lang;

  void _setStatus(String newStatus) {
    setState(() {
      _status = newStatus;
    });
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => getCurrentLang());
  }

  void getCurrentLang() {
    final myLocale = Localizations.localeOf(context);
    setState(() {
      lang = myLocale.languageCode == 'ar' ? Lang.ar : Lang.en;
    });
  }

  Future<void> createSession() async {
    try {
      _setStatus('pending');
      print('Lang::::: $lang');

      final s = await TabbySDK().createSession(TabbyCheckoutPayload(
        merchantCode: '${AppConfig.tabbyMerchantCode}',
        lang: lang,
        payment: mockPayload,
      ));

      debugPrint('Session id: ${s.sessionId}');
      debugPrint('Tabby Response :::::: Payment ID: ${s.paymentId}');

      setState(() {
        session = s;
      });
      _setStatus('created');
    } catch (e, s) {
      printError(e, s);
      _setStatus('error');
    }
  }

  void openCheckOutPage() {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (builder) => TabbyCheckoutPage(),
        settings: RouteSettings(
          arguments: TabbyCheckoutNavParams(
            selectedProduct: session!.availableProducts.installments!,
          ),
        ),
      ),
    );
  }

  void openInAppBrowser() {
    TabbyWebView.showWebView(
      context: context,
      webUrl: session!.availableProducts.installments!.webUrl,
      onResult: (WebViewResult resultCode) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(resultCode.name),
          ),
        );
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            const SizedBox(height: 24),
             Padding(
              padding: EdgeInsets.all(16),
              child: TabbyCheckoutSnippet(
                price: '${double.parse(_checkoutController.orderData['grand_total'].toString()).toStringAsFixed(2)}',
                currency: Currency.aed,
                lang: Lang.en,
              ),
            ),
            Text(
              '${mockPayload.amount} ${mockPayload.currency.displayName}',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              mockPayload.buyer?.email ?? '',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            Text(
              mockPayload.buyer?.phone ?? '',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              _status,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            if (session == null) ...[
              ElevatedButton(
                onPressed: _status == 'pending' ? null : createSession,
                child: const Text('Create Session'),
              ),
            ],
            if (session != null) ...[
              ElevatedButton(
                onPressed: openCheckOutPage,
                child: const Text('Open checkout page'),
              ),
              const SizedBox(height: 24),

            ],
          ],
        ),
      ),
    );
  }
}
