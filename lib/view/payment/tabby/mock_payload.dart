import 'package:get/get.dart';
import 'package:tabby_flutter_inapp_sdk/tabby_flutter_inapp_sdk.dart';
import '../../../controller/address_book_controller.dart';
import '../../../controller/checkout_controller.dart';

final CheckoutController _checkoutController = Get.put(CheckoutController());
final AddressController addressController = Get.put(AddressController());

final mockPayload = Payment(
  amount: '${double.parse(_checkoutController.orderData['grand_total'].toString()).toStringAsFixed(2)}',
  currency: Currency.aed,
  buyer: Buyer(
    email: 'id.card.success@tabby.ai',
    phone: '500000001',
    name: 'Yazan Khalid',
    dob: '2019-08-24',
  ),
  buyerHistory: BuyerHistory(
    loyaltyLevel: 0,
    registeredSince: '2019-08-24T14:15:22Z',
    wishlistCount: 0,
  ),
  shippingAddress: const ShippingAddress(
    city: 'string',
    address: 'string',
    zip: 'string',
  ),
  order: Order(referenceId: 'id123', items: _checkoutController.tabbyProduct
  // [
  //   OrderItem(
  //     title: 'Jersey',
  //     description: 'Jersey',
  //     quantity: _checkoutController.totalQty.toInt(),
  //     unitPrice: '${double.parse(_checkoutController.orderData['grand_total'].toString()).toStringAsFixed(2)}',
  //     referenceId: 'uuid',
  //     productUrl: 'http://example.com',
  //     category: 'clothes',
  //   )
  // ]
  ),
  orderHistory: [
    OrderHistoryItem(
      purchasedAt: '2019-08-24T14:15:22Z',
      amount: '${double.parse(_checkoutController.orderData['grand_total'].toString()).toStringAsFixed(2)}',
      paymentMethod: OrderHistoryItemPaymentMethod.card,
      status: OrderHistoryItemStatus.newOne,
    )
  ],
);
