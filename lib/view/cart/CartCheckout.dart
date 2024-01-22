import 'dart:convert';
import 'dart:developer';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/address_book_controller.dart';
import 'package:amazcart/controller/checkout_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/model/NewModel/Cart/MyCheckoutModel.dart';
import 'package:amazcart/model/NewModel/Cart/FlatGst.dart';
import 'package:amazcart/model/NewModel/GeneralSettingsModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/model/NewModel/ShippingMethodModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/cart/GatewaySelection.dart';
import 'package:amazcart/view/settings/AddAddress.dart';
import 'package:amazcart/view/settings/AddressBook.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:amazcart/widgets/CustomDate.dart';
import 'package:amazcart/widgets/PinkButtonWidget.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';

class CartCheckout extends StatefulWidget {
  @override
  _CartCheckoutState createState() => _CartCheckoutState();
}

class _CartCheckoutState extends State<CartCheckout> {
  final CheckoutController checkoutController = Get.put(CheckoutController());
  final AddressController addressController = Get.put(AddressController());

  final TextEditingController customerPhoneCtrl = TextEditingController();
  final TextEditingController customerEmailCtrl = TextEditingController();

  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  // bool _isConfirm = false;
  ScrollController _scrollController = ScrollController();

  var gstId = 0;
  var gstShow = '';
  var gstShowList = [];

  String _verticalGroupValue = "Home Delivery";
  List<String> _status = [
    "Home Delivery",
    "Pickup Location",
  ];

  PickupLocation? selectedPickupValue;
  @override
  void initState() {
    checkoutController.orderData.addAll({
      'package_wise_weight': {},
      'package_wise_height': {},
      'package_wise_length': {},
      'package_wise_breadth': {},
      'packagewiseTax': {},
      'shipping_cost': {},
      'delivery_date': {},
      'shipping_method': {},
    });
    if (currencyController.vendorType.value == "single") {
      selectedPickupValue =
          currencyController.settingsModel.value.pickupLocations?.first;
    }

    if (_verticalGroupValue == "Home Delivery") {
      checkoutController.deliveryType.value = "home_delivery";
    } else {
      checkoutController.deliveryType.value = "pickup_location";
      checkoutController.pickupId.value = selectedPickupValue?.id ?? 0;
    }
    checkoutController.getCheckoutList();

    super.initState();
  }

  void removeValueToMap<K, V>(Map<K, List<V>> map, K key, V value) {
    map.update(key, (list) => list..remove(value), ifAbsent: () => [value]);
  }

  void addValueToMap<K, V>(Map<K, V> map, K key, V value) {
    map.update(key, (v) => value, ifAbsent: () => value);
  }

  @override
  Widget build(BuildContext context) {
    // checkoutController.calculateDiscount();
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: 'Checkout'.tr,
      ),
      body: Scrollbar(
        controller: _scrollController,
        child: ListView(
          controller: _scrollController,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            SizedBox(
              height: 10,
            ),

            //**Delivery Info
            Obx(() {
              if (checkoutController.isLoading.value) {
                return Container();
              } else {
                if (addressController.addressCount.value > 0) {
                  customerEmailCtrl.text =
                      addressController.shippingAddress.value.email ?? '';
                  customerPhoneCtrl.text =
                      addressController.shippingAddress.value.phone ?? '';
                  return Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Icon(
                                  Icons.phone,
                                  size: 20,
                                  color: AppStyles.darkBlueColor,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: TextField(
                                  autofocus: false,
                                  controller: customerPhoneCtrl,
                                  scrollPhysics:
                                      AlwaysScrollableScrollPhysics(),
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    hintText: 'Phone number',
                                    fillColor: AppStyles.appBackgroundColor,
                                    isDense: true,
                                    filled: true,
                                    contentPadding: EdgeInsets.all(14),
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
                                    hintStyle: AppStyles.appFont.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: AppStyles.greyColorDark,
                                    ),
                                  ),
                                  style: AppStyles.appFont.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: AppStyles.blackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Icon(
                                  Icons.mail,
                                  size: 20,
                                  color: AppStyles.darkBlueColor,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: TextField(
                                  autofocus: false,
                                  controller: customerEmailCtrl,
                                  scrollPhysics:
                                      AlwaysScrollableScrollPhysics(),
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    hintText: 'Email Address',
                                    fillColor: AppStyles.appBackgroundColor,
                                    isDense: true,
                                    filled: true,
                                    contentPadding: EdgeInsets.all(14),
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
                                    hintStyle: AppStyles.appFont.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                      color: AppStyles.greyColorDark,
                                    ),
                                  ),
                                  style: AppStyles.appFont.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    color: AppStyles.blackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8),

                        //** HOME DELIVERY / PICKUP */

                        currencyController.vendorType.value == "single"
                            ? RadioGroup<String>.builder(
                                direction: Axis.horizontal,
                                horizontalAlignment: MainAxisAlignment.start,
                                groupValue: _verticalGroupValue,
                                onChanged: (value) => setState(() {
                                  _verticalGroupValue = value ?? '';

                                  if (_verticalGroupValue == "Home Delivery") {
                                    checkoutController.deliveryType.value =
                                        "home_delivery";

                                    // double totalShipping = 0.0;

                                    // print(checkoutController.packageCount.value
                                    //     .toString());

                                    // for (int i = 0;
                                    //     i <
                                    //         checkoutController
                                    //             .packageCount.value;
                                    //     i++) {
                                    //   if (checkoutController
                                    //           .orderData["shipping_cost[$i]"] !=
                                    //       null) {
                                    //     totalShipping += double.parse(
                                    //         checkoutController
                                    //             .orderData["shipping_cost[$i]"]
                                    //             .toString());
                                    //   }
                                    // }
                                    checkoutController.calculateShipment();
                                    print(checkoutController.shipping.value);
                                  } else {
                                    checkoutController.deliveryType.value =
                                        "pickup_location";
                                    checkoutController.pickupId.value =
                                        selectedPickupValue?.id ?? 0;

                                    checkoutController.shipping.value = 0.0;
                                  }

                                  checkoutController
                                      .grandTotal.value = (checkoutController
                                                  .subTotal.value +
                                              checkoutController
                                                  .shipping.value +
                                              checkoutController.gstTotal.value)
                                          .toPrecision(2) -
                                      checkoutController.discountTotal.value;
                                }),
                                items: _status,
                                itemBuilder: (item) => RadioButtonBuilder(
                                  item,
                                ),
                                activeColor: Colors.red,
                              )
                            : SizedBox.shrink(),

                        currencyController.vendorType.value == "single"
                            ? _verticalGroupValue != "Home Delivery"
                                ? ListView(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(top: 10),
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      Text(
                                        'Select a pickup point'.tr,
                                        style: AppStyles.appFont.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppStyles.pinkColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color:
                                                  AppStyles.appBackgroundColor,
                                              border: Border.all(
                                                  color: AppStyles
                                                      .textFieldFillColor)),
                                          child: DropdownButton<PickupLocation>(
                                            elevation: 1,
                                            isExpanded: true,
                                            underline: Container(),
                                            value: selectedPickupValue,
                                            items: currencyController
                                                .settingsModel
                                                .value
                                                .pickupLocations
                                                ?.map((e) {
                                              // reasonValue = widget.reasonValue;
                                              return DropdownMenuItem<
                                                  PickupLocation>(
                                                child:
                                                    Text('${e.pickupLocation}'),
                                                value: e,
                                              );
                                            }).toList(),
                                            onChanged: (PickupLocation? value) {
                                              setState(() {
                                                selectedPickupValue = value;
                                              });

                                              checkoutController.deliveryType
                                                  .value = "pickup_location";
                                              checkoutController
                                                      .pickupId.value =
                                                  selectedPickupValue?.id ?? 0;
                                            },
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink()
                            : SizedBox.shrink(),

                        //** Shipping address */

                        currencyController.vendorType.value != "single"
                            ? Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    title: Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        'Shipping Address'.tr,
                                        style: AppStyles.appFont.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppStyles.pinkColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    subtitle: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/images/location_ico.png',
                                          color: AppStyles.darkBlueColor,
                                          width: 17,
                                          height: 17,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                addressController
                                                    .shippingAddress
                                                    .value
                                                    .name
                                                    ?.capitalizeFirst ?? '',
                                                style: AppStyles.kFontBlack14w5
                                                    .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Address'.tr + ': ',
                                                  style: AppStyles.kFontGrey14w5
                                                      .copyWith(
                                                    color:
                                                        AppStyles.darkBlueColor,
                                                    fontSize: 13,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '${addressController.shippingAddress.value.address}',
                                                      style: AppStyles
                                                          .kFontGrey14w5
                                                          .copyWith(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: InkWell(
                                      onTap: () {
                                        Get.to(() => AddressBook());
                                      },
                                      child: Container(
                                        child: Text(
                                          'Change'.tr,
                                          style: AppStyles.appFont.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: AppStyles.pinkColor,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    title: Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        'Billing Address'.tr,
                                        style: AppStyles.appFont.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppStyles.pinkColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    subtitle: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          child: Image.asset(
                                            'assets/images/icon_delivery-parcel.png',
                                            color: AppStyles.darkBlueColor,
                                            width: 15,
                                            height: 15,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                addressController.billingAddress
                                                    .value.name?.capitalizeFirst ?? '',
                                                style: AppStyles.kFontBlack14w5
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Address'.tr + ': ',
                                                  style: AppStyles.kFontGrey14w5
                                                      .copyWith(
                                                    color:
                                                        AppStyles.darkBlueColor,
                                                    fontSize: 13,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '${addressController.billingAddress.value.address}',
                                                      style: AppStyles
                                                          .kFontGrey14w5
                                                          .copyWith(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: InkWell(
                                      onTap: () {
                                        Get.to(() => AddressBook());
                                      },
                                      child: Container(
                                        child: Text(
                                          'Change'.tr,
                                          style: AppStyles.appFont.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: AppStyles.pinkColor,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : _verticalGroupValue == "Home Delivery"
                                ? ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    title: Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        'Shipping Address'.tr,
                                        style: AppStyles.appFont.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppStyles.pinkColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    subtitle: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          'assets/images/location_ico.png',
                                          color: AppStyles.darkBlueColor,
                                          width: 17,
                                          height: 17,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                addressController
                                                    .shippingAddress
                                                    .value
                                                    .name
                                                    ?.capitalizeFirst ?? '',
                                                style: AppStyles.kFontBlack14w5
                                                    .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Address'.tr + ': ',
                                                  style: AppStyles.kFontGrey14w5
                                                      .copyWith(
                                                    color:
                                                        AppStyles.darkBlueColor,
                                                    fontSize: 13,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '${addressController.shippingAddress.value.address}',
                                                      style: AppStyles
                                                          .kFontGrey14w5
                                                          .copyWith(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: InkWell(
                                      onTap: () {
                                        Get.to(() => AddressBook());
                                      },
                                      child: Container(
                                        child: Text(
                                          'Change'.tr,
                                          style: AppStyles.appFont.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: AppStyles.pinkColor,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    title: Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        'Billing Address'.tr,
                                        style: AppStyles.appFont.copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: AppStyles.pinkColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    subtitle: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(2),
                                          child: Image.asset(
                                            'assets/images/icon_delivery-parcel.png',
                                            color: AppStyles.darkBlueColor,
                                            width: 15,
                                            height: 15,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                addressController.billingAddress
                                                    .value.name?.capitalizeFirst ?? '',
                                                style: AppStyles.kFontBlack14w5
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              RichText(
                                                text: TextSpan(
                                                  text: 'Address'.tr + ': ',
                                                  style: AppStyles.kFontGrey14w5
                                                      .copyWith(
                                                    color:
                                                        AppStyles.darkBlueColor,
                                                    fontSize: 13,
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text:
                                                          '${addressController.billingAddress.value.address}',
                                                      style: AppStyles
                                                          .kFontGrey14w5
                                                          .copyWith(
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: InkWell(
                                      onTap: () {
                                        Get.to(() => AddressBook());
                                      },
                                      child: Container(
                                        child: Text(
                                          'Change'.tr,
                                          style: AppStyles.appFont.copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: AppStyles.pinkColor,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.all(15),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => AddAddress());
                      },
                      child: DottedBorder(
                        color: AppStyles.lightBlueColor,
                        strokeWidth: 1,
                        borderType: BorderType.RRect,
                        radius: Radius.circular(12),
                        child: Container(
                          alignment: Alignment.center,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color(0xffEDF3FA),
                            borderRadius: BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle_outline_rounded,
                                color: AppStyles.lightBlueColor,
                                size: 22,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Add Address'.tr,
                                textAlign: TextAlign.center,
                                style: AppStyles.appFont.copyWith(
                                  color: AppStyles.lightBlueColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }
            }),
            SizedBox(
              height: 10,
            ),

            //**Products
            Obx(() {
              if (checkoutController.isLoading.value) {
                return Center(
                  child: CustomLoadingWidget(),
                );
              } else {
                if (checkoutController.checkoutModel.value.packages == null ||
                    checkoutController.checkoutModel.value.packages?.length ==
                        0) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Icon(
                          FontAwesomeIcons.exclamation,
                          color: AppStyles.pinkColor,
                          size: 25,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'No Products found'.tr,
                          textAlign: TextAlign.center,
                          style: AppStyles.kFontPink15w5.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  );
                } else {
                  // var packageInd = 0;
                  // ignore: unused_local_variable
                  var taxes = [];
                  // ignore: unused_local_variable
                  var pTaxes = [];
                  var additionalShipping = 0.0;

                  return Container(
                    color: Colors.white,
                    child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: checkoutController
                            .checkoutModel.value.packages?.values.length,
                        itemBuilder: (context, packageIndex) {
                          // var packageTax = 0.0;
                          // packageInd++;
                          var qty = 0;
                          var price = 0.0;

                          var totalWeight = 0.0;
                          var totalHeight = 0.0;
                          var totalLength = 0.0;
                          var totalBreadth = 0.0;

                          // String packageId = checkoutController
                          //     .checkoutModel.value.packages.entries
                          //     .elementAt(packageIndex)
                          //     .key;

                          print("Additional $additionalShipping");

                          checkoutController.checkoutModel.value.packages?.values
                              .elementAt(packageIndex)
                              .items
                              ?.forEach((element) {
                            qty += (element.qty ?? 0);
                          });
                          checkoutController.checkoutModel.value.packages?.values
                              .elementAt(packageIndex)
                              .items
                              ?.forEach((element) {
                            price += element.totalPrice;
                          });

                          checkoutController.checkoutModel.value.packages?.values
                              .elementAt(packageIndex)
                              .items
                              ?.forEach((element) {
                            if (element.productType == ProductType.PRODUCT) {
                              totalWeight +=
                                  double.parse(element.product?.sku?.weight ?? "0.0")
                                      .toDouble();
                              totalHeight +=
                                  double.parse(element.product?.sku?.height ?? "0.0")
                                      .toDouble();
                              totalLength +=
                                  double.parse(element.product?.sku?.length ?? "0.0")
                                      .toDouble();
                              totalBreadth +=
                                  double.parse(element.product?.sku?.breadth ?? "0.0")
                                      .toDouble();
                            }
                          });

                          final Map<dynamic, dynamic> packageWiseWeightMap =
                              checkoutController
                                  .orderData['package_wise_weight'];
                          final Map<dynamic, dynamic> packageWiseHeightMap =
                              checkoutController
                                  .orderData['package_wise_height'];
                          final Map<dynamic, dynamic> packageWiseLengthMap =
                              checkoutController
                                  .orderData['package_wise_length'];
                          final Map<dynamic, dynamic> packageWiseBreadthMap =
                              checkoutController
                                  .orderData['package_wise_breadth'];

                          final Map<dynamic, dynamic> packageWiseTaxMap =
                              checkoutController.orderData['packagewiseTax'];

                          checkoutController.checkoutModel.value.packages
                              ?.forEach((key, value) {
                            addValueToMap(packageWiseWeightMap, '$packageIndex',
                                totalWeight);
                            addValueToMap(packageWiseHeightMap, '$packageIndex',
                                totalHeight);
                            addValueToMap(packageWiseLengthMap, '$packageIndex',
                                totalLength);
                            addValueToMap(packageWiseBreadthMap,
                                '$packageIndex', totalBreadth);
                          });

                          var gst = 0.0;
                          var gstS = '';
                          var gstShowList = [];
                          var gstID = [];
                          var gstAmount = [];

                          var gstTT = 0.0;

                          checkoutController.checkoutModel.value.packages?.values
                              .elementAt(packageIndex)
                              .items
                              ?.forEach((element) {
                            print(element.id);
                            if (element.product?.product?.product?.gstGroup ==
                                null) {
                              print(1);
                              if (checkoutController
                                      .checkoutModel.value.isGstModuleEnable ==
                                  1) {
                                gstShowList.clear();
                                gstID.clear();
                                gstAmount.clear();

                                if (checkoutController
                                        .checkoutModel.value.isGstEnable ==
                                    1) {
                                  if (currencyController
                                          .settingsModel.value.vendorType ==
                                      "single") {
                                    if (element
                                            .customer?.customerShippingAddress !=
                                        null) {
                                      if (element.customer
                                              ?.customerShippingAddress?.state ==
                                          currencyController.settingsModel.value
                                              .settings?.stateId
                                              .toString()) {
                                        checkoutController.checkoutModel.value
                                            .sameStateGstList
                                            ?.forEach((same) {
                                          gstTT += double.parse(
                                                  (element.totalPrice *
                                                          same.taxPercentage /
                                                          100)
                                                      .toString())
                                              .toPrecision(2);

                                          gst = double.parse(((price *
                                                          same.taxPercentage) /
                                                      100)
                                                  .toString())
                                              .toPrecision(2);
                                          gstS =
                                              '${same.name}(${same.taxPercentage} %) : $gst${currencyController.appCurrency.value}';
                                          gstShowList.add(gstS);
                                          gstID.add(same.id);
                                          gstAmount.add(gst);
                                        });
                                      } else {
                                        checkoutController.checkoutModel.value
                                            .differantStateGstList
                                            ?.forEach((diff) {
                                          gstTT += double.parse(
                                                  (element.totalPrice *
                                                          diff.taxPercentage /
                                                          100)
                                                      .toString())
                                              .toPrecision(2);

                                          gst = double.parse(((price *
                                                          diff.taxPercentage) /
                                                      100)
                                                  .toString())
                                              .toPrecision(2);

                                          gstS =
                                              '${diff.name}(${diff.taxPercentage} %) : $gst${currencyController.appCurrency.value} ';
                                          gstShowList.add(gstS);
                                          gstID.add(diff.id);
                                          gstAmount.add(gst);
                                        });
                                      }
                                    }
                                  } else {
                                    if ((element.customer
                                                    ?.customerShippingAddress !=
                                                null &&
                                            element.seller
                                                    ?.sellerBusinessInformation !=
                                                null) &&
                                        element.customer?.customerShippingAddress
                                                ?.state ==
                                            element
                                                .seller
                                                ?.sellerBusinessInformation
                                                ?.businessState) {
                                      checkoutController
                                          .checkoutModel.value.sameStateGstList
                                          ?.forEach((same) {
                                        gstTT += double.parse(
                                                (element.totalPrice *
                                                        same.taxPercentage /
                                                        100)
                                                    .toString())
                                            .toPrecision(2);

                                        gst =
                                            (price * same.taxPercentage) / 100;
                                        gstS =
                                            '${same.name}(${same.taxPercentage} %) : $gst${currencyController.appCurrency.value} ';
                                        gstShowList.add(gstS);
                                        gstID.add(same.id);
                                        gstAmount.add(gst);
                                      });
                                    } else {
                                      if (element.seller
                                              ?.sellerBusinessInformation ==
                                          null) {
                                        gstTT += double.parse(
                                                (element.totalPrice *
                                                        checkoutController
                                                            .checkoutModel
                                                            .value
                                                            .flatGst
                                                            ?.taxPercentage /
                                                        100)
                                                    .toString())
                                            .toPrecision(2);

                                        gst = (element.totalPrice *
                                                checkoutController
                                                    .checkoutModel
                                                    .value
                                                    .flatGst
                                                    ?.taxPercentage) /
                                            100;

                                        gstS =
                                            '${checkoutController.checkoutModel.value.flatGst?.name}(${checkoutController.checkoutModel.value.flatGst?.taxPercentage} %) : $gst${currencyController.appCurrency.value}';
                                        gstShowList.add(gstS);
                                        gstAmount.add(gst);
                                      } else {
                                        checkoutController.checkoutModel.value
                                            .differantStateGstList
                                            ?.forEach((diff) {
                                          gstTT += double.parse(
                                                  (element.totalPrice *
                                                          diff.taxPercentage /
                                                          100)
                                                      .toString())
                                              .toPrecision(2);
                                          gst = (price * diff.taxPercentage) /
                                              100;
                                          gstS =
                                              '${diff.name}(${diff.taxPercentage} %) : $gst${currencyController.appCurrency.value}';
                                          gstShowList.add(gstS);
                                          gstID.add(diff.id);
                                          gstAmount.add(gst);
                                        });
                                      }
                                    }
                                  }
                                } else {
                                  ///
                                  ///not enable gst
                                  ///
                                  log("not enable gst");
                                  FlatGst? flatGST = checkoutController.checkoutModel.value.flatGst;
                                  print(flatGST?.taxPercentage);
                                  gstTT += double.parse((element.totalPrice *
                                              flatGST?.taxPercentage /
                                              100)
                                          .toString())
                                      .toPrecision(2);
                                }
                              }
                            } else {
                              print(2);
                              final Map<dynamic, dynamic> sameState =
                                  jsonDecode(element.product?.product?.product
                                      ?.gstGroup?.sameStateGst ?? '');

                              final Map<dynamic, dynamic> outsideState =
                                  jsonDecode(element.product?.product?.product
                                      ?.gstGroup?.outsiteStateGst ?? '');

                              var totalSameStateGst = 0.0;
                              var totalOutsideStateGst = 0.0;

                              sameState.entries.forEach((element) {
                                totalSameStateGst +=
                                    double.parse(element.value.toString())
                                        .toPrecision(2);
                              });
                              outsideState.entries.forEach((element) {
                                totalOutsideStateGst +=
                                    double.parse(element.value.toString())
                                        .toPrecision(2);
                              });

                              if (element.customer?.customerShippingAddress !=
                                      null &&
                                  (element.customer?.customerShippingAddress
                                          ?.state ==
                                      currencyController
                                          .settingsModel.value.settings?.stateId
                                          .toString())) {
                                gstTT += double.parse(((element.totalPrice *
                                                totalSameStateGst) /
                                            100)
                                        .toString())
                                    .toPrecision(2);
                              } else {
                                gstTT += double.parse((element.totalPrice *
                                            totalOutsideStateGst /
                                            100)
                                        .toString())
                                    .toPrecision(2);
                              }
                            }

                            addValueToMap(
                                packageWiseTaxMap, '$packageIndex', gstTT);
                          });
                          print(packageWiseTaxMap);
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    currencyController.vendorType.value ==
                                            "single"
                                        ? SizedBox.shrink()
                                        : ListTile(
                                            dense: true,
                                            contentPadding: EdgeInsets.zero,
                                            title: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                  'assets/images/icon_delivery-parcel.png',
                                                  width: 15,
                                                  height: 15,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Package'.tr +
                                                            ' ${packageIndex + 1}/${checkoutController.packageCount.value}',
                                                        style: AppStyles
                                                            .kFontBlack12w4,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          additionalShipping >
                                                                  0.0
                                                              ? Text(
                                                                  'Additional Shipping'
                                                                          .tr +
                                                                      ': ${(additionalShipping * currencyController.conversionRate.value)}${currencyController.appCurrency.value}',
                                                                  style: AppStyles
                                                                      .kFontGrey12w5,
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            trailing: Text(
                                              'Sold by'.tr +
                                                  ': ${checkoutController.checkoutModel.value.packages?.values.elementAt(packageIndex).items?.first.seller?.name}',
                                              style: AppStyles.kFontGrey12w5,
                                            ),
                                          ),
                                    ListView.separated(
                                        separatorBuilder: (contxt, index) {
                                          return Divider(
                                            height: 2,
                                          );
                                        },
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: checkoutController
                                            .checkoutModel.value.packages?.values
                                            .elementAt(packageIndex)
                                            .items
                                            ?.length ?? 0,
                                        itemBuilder: (context, productIndex) {
                                          List<CheckoutItem> checkoutItem =
                                              checkoutController.checkoutModel
                                                  .value.packages?.values
                                                  .elementAt(packageIndex)
                                                  .items ?? [];

                                          return Column(
                                            children: [
                                              Container(
                                                color: Colors.white,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 14,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5)),
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          child: Container(
                                                            height: 65,
                                                            width: 65,
                                                            child: checkoutItem[
                                                                            productIndex]
                                                                        .productType ==
                                                                    ProductType
                                                                        .PRODUCT
                                                                ? checkoutItem[productIndex]
                                                                            .product
                                                                            ?.sku
                                                                            ?.variantImage !=
                                                                        null
                                                                    ? FancyShimmerImage(
                                                                        imageUrl:
                                                                            "${AppConfig.assetPath}/${checkoutItem[productIndex].product?.sku?.variantImage}",
                                                                        boxFit:
                                                                            BoxFit.contain,
                                                                        errorWidget:
                                                                            FancyShimmerImage(
                                                                          imageUrl:
                                                                              "${AppConfig.assetPath}/backend/img/default.png",
                                                                          boxFit:
                                                                              BoxFit.contain,
                                                                        ),
                                                                      )
                                                                    : FancyShimmerImage(
                                                                        imageUrl:
                                                                            "${AppConfig.assetPath}/${checkoutItem[productIndex].product?.product?.product?.thumbnailImageSource}",
                                                                        boxFit:
                                                                            BoxFit.contain,
                                                                        errorWidget:
                                                                            FancyShimmerImage(
                                                                          imageUrl:
                                                                              "${AppConfig.assetPath}/backend/img/default.png",
                                                                          boxFit:
                                                                              BoxFit.contain,
                                                                        ),
                                                                      )
                                                                : FancyShimmerImage(
                                                                    imageUrl:
                                                                        "${AppConfig.assetPath}/${checkoutItem[productIndex].giftCard?.thumbnailImage}",
                                                                    boxFit: BoxFit
                                                                        .contain,
                                                                    errorWidget:
                                                                        FancyShimmerImage(
                                                                      imageUrl:
                                                                          "${AppConfig.assetPath}/backend/img/default.png",
                                                                      boxFit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                  ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      checkoutItem[productIndex].productType ==
                                                                              ProductType.PRODUCT
                                                                          ? Text(
                                                                              checkoutItem[productIndex].product?.product?.product?.productName ?? '',
                                                                              style: AppStyles.kFontBlack13w4,
                                                                            )
                                                                          : Text(
                                                                              checkoutItem[productIndex].giftCard?.name ?? '',
                                                                              style: AppStyles.kFontBlack13w4,
                                                                            ),
                                                                      checkoutItem[productIndex].productType ==
                                                                              ProductType
                                                                                  .PRODUCT
                                                                          ? ListView
                                                                              .builder(
                                                                              shrinkWrap: true,
                                                                              physics: NeverScrollableScrollPhysics(),
                                                                              padding: EdgeInsets.symmetric(vertical: 4),
                                                                              itemCount: checkoutItem[productIndex].product?.productVariations?.length,
                                                                              itemBuilder: (BuildContext context, int variationIndex) {
                                                                                if (checkoutItem[productIndex].product?.productVariations?[variationIndex].attribute?.name == 'Color') {
                                                                                  return Text(
                                                                                    '${checkoutItem[productIndex].product?.productVariations?[variationIndex].attribute?.name}: ${checkoutItem[productIndex].product?.productVariations?[variationIndex].attributeValue?.color?.name}',
                                                                                    style: AppStyles.kFontGrey12w5,
                                                                                  );
                                                                                }
                                                                                return Text(
                                                                                  '${checkoutItem[productIndex].product?.productVariations?[variationIndex].attribute?.name}: ${checkoutItem[productIndex].product?.productVariations?[variationIndex].attributeValue?.value}',
                                                                                  style: AppStyles.kFontGrey12w5,
                                                                                );
                                                                              },
                                                                            )
                                                                          : SizedBox
                                                                              .shrink(),
                                                                      Wrap(
                                                                        runSpacing:
                                                                            10,
                                                                        alignment:
                                                                            WrapAlignment.start,
                                                                        crossAxisAlignment:
                                                                            WrapCrossAlignment.start,
                                                                        children: [
                                                                          //** Price */
                                                                          checkoutItem[productIndex].productType == ProductType.PRODUCT
                                                                              ? checkoutItem[productIndex].product?.product?.hasDiscount == "yes"
                                                                                  ? Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          '${double.parse((checkoutItem[productIndex].price * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                                          style: AppStyles.kFontPink15w5,
                                                                                        ),
                                                                                        SizedBox(width: 5),
                                                                                        Text(
                                                                                          '${double.parse((checkoutItem[productIndex].product?.sellingPrice * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                                          style: AppStyles.kFontGrey12w5.copyWith(
                                                                                            decoration: TextDecoration.lineThrough,
                                                                                            decorationThickness: 2,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  : Text(
                                                                                      '${double.parse((checkoutItem[productIndex].price * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                                      style: AppStyles.kFontPink15w5,
                                                                                    )
                                                                              : checkoutItem[productIndex].giftCard!.endDate!.millisecondsSinceEpoch > DateTime.now().millisecondsSinceEpoch
                                                                                  ? Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          '${double.parse((checkoutItem[productIndex].price * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                                          style: AppStyles.kFontPink15w5,
                                                                                        ),
                                                                                        SizedBox(width: 5),
                                                                                        Text(
                                                                                          '${double.parse(((checkoutItem[productIndex].giftCard?.sellingPrice ?? 1) * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                                          style: AppStyles.kFontGrey12w5.copyWith(decoration: TextDecoration.lineThrough),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  : Text(
                                                                                      '${double.parse((checkoutItem[productIndex].price * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                                      style: AppStyles.kFontPink15w5,
                                                                                    ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          //** Discount */
                                                                          checkoutItem[productIndex].productType == ProductType.PRODUCT
                                                                              ? checkoutItem[productIndex].product?.product?.hasDeal != null
                                                                                  ? Row(
                                                                                      children: [
                                                                                        Container(
                                                                                          padding: EdgeInsets.all(4),
                                                                                          decoration: BoxDecoration(
                                                                                            color: AppStyles.pinkColor,
                                                                                            borderRadius: BorderRadius.circular(2),
                                                                                          ),
                                                                                          child: Text(
                                                                                            checkoutItem[productIndex].product?.product?.hasDeal?.discountType == 0 ? '-${checkoutItem[productIndex].product?.product?.hasDeal?.discount}%' : '-${double.parse((checkoutItem[productIndex].product!.product!.hasDeal!.discount! * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                                            style: AppStyles.kFontWhite12w5,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  : checkoutItem[productIndex].product!.product!.discount! > 0
                                                                                      ? Row(
                                                                                          children: [
                                                                                            Container(
                                                                                              padding: EdgeInsets.all(4),
                                                                                              decoration: BoxDecoration(
                                                                                                color: AppStyles.pinkColor,
                                                                                                borderRadius: BorderRadius.circular(2),
                                                                                              ),
                                                                                              child: Text(
                                                                                                checkoutItem[productIndex].product?.product?.discountType == "0" ? '-${checkoutItem[productIndex].product?.product?.discount}%' : '-${double.parse((checkoutItem[productIndex].product!.product!.discount! * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                                                style: AppStyles.kFontWhite12w5,
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        )
                                                                                      : Container()
                                                                              : checkoutItem[productIndex].giftCard!.discount! > DateTime.now().millisecondsSinceEpoch
                                                                                  ? Row(
                                                                                      children: [
                                                                                        Container(
                                                                                          padding: EdgeInsets.all(4),
                                                                                          decoration: BoxDecoration(
                                                                                            color: AppStyles.pinkColor,
                                                                                            borderRadius: BorderRadius.circular(2),
                                                                                          ),
                                                                                          child: Text(
                                                                                            checkoutItem[productIndex].giftCard?.discountType == "0" || checkoutItem[productIndex].giftCard?.discountType == 0 ? '-${checkoutItem[productIndex].giftCard?.discount}%' : '-${double.parse((checkoutItem[productIndex].giftCard!.discount! * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                                            style: AppStyles.kFontWhite12w5,
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    )
                                                                                  : Container(),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Text(
                                                                  'Qty'.tr +
                                                                      ': ${checkoutItem[productIndex].qty}',
                                                                  style: AppStyles
                                                                      .kFontBlack12w4,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                    Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Divider(
                                            color: AppStyles.lightBlueColorAlt,
                                            thickness: 2,
                                            height: 2,
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  '$qty ' +
                                                      'Item(s), Total: '.tr +
                                                      '${double.parse((price * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                  style:
                                                      AppStyles.kFontBlack12w4,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _verticalGroupValue == "Home Delivery"
                                  ? Divider(
                                      height: 10,
                                      thickness: 2,
                                      color: AppStyles.appBackgroundColor,
                                    )
                                  : SizedBox.shrink(),
                              _verticalGroupValue == "Home Delivery"
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 10),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Shipping Method".tr + ":",
                                          textAlign: TextAlign.left,
                                          style: AppStyles.kFontBlack14w5,
                                        ),
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              _verticalGroupValue == "Home Delivery"
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: ShippingDropDown(
                                        shippingValue: checkoutController
                                            .checkoutModel.value.packages!.values
                                            .elementAt(packageIndex)
                                            .shipping
                                            !.first,
                                        shippings: checkoutController
                                            .checkoutModel.value.packages!.values
                                            .elementAt(packageIndex)
                                            .shipping!,
                                        packageIndex: packageIndex,
                                        price: price,
                                        totalWeight: totalWeight,
                                        orderData: checkoutController.orderData,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              Divider(
                                height: 10,
                                thickness: 10,
                                color: AppStyles.appBackgroundColor,
                              ),
                            ],
                          );
                        }),
                  );
                }
              }
            }),

            //** Pricing Info
            Obx(() {
              if (checkoutController.isLoading.value) {
                return Center(
                  child: Container(),
                );
              } else {
                if (checkoutController.checkoutModel.value.packages == null ||
                    checkoutController.checkoutModel.value.packages?.length ==
                        0) {
                  return Container();
                } else {
                  return Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal'.tr,
                              style: AppStyles.kFontBlack12w4.copyWith(
                                color: AppStyles.greyColorDark,
                              ),
                            ),
                            Text(
                              '${(checkoutController.subTotal.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                        _verticalGroupValue == "Home Delivery"
                            ? Container(
                                margin: EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Shipping'.tr,
                                      style: AppStyles.kFontBlack12w4.copyWith(
                                        color: AppStyles.greyColorDark,
                                      ),
                                    ),
                                    Text(
                                      '${(checkoutController.shipping.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                      style: AppStyles.kFontBlack14w5,
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: 12,
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Saving'.tr,
                              style: AppStyles.kFontBlack12w4.copyWith(
                                color: AppStyles.greyColorDark,
                              ),
                            ),
                            Text(
                              '-${(checkoutController.discountTotal.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        checkoutController
                                    .checkoutModel.value.isGstModuleEnable ==
                                1
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total VAT/TAX/GST'.tr,
                                        style:
                                            AppStyles.kFontBlack12w4.copyWith(
                                          color: AppStyles.greyColorDark,
                                        ),
                                      ),
                                      Text(
                                        '${(checkoutController.gstTotal.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                        style: AppStyles.kFontBlack14w5,
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                        _verticalGroupValue == "Home Delivery"
                            ? SizedBox(
                                height: 12,
                              )
                            : Container(
                                margin: EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  'Collect from Pickup location'.tr +
                                      ": ${selectedPickupValue?.address}",
                                  style: AppStyles.kFontBlack12w4.copyWith(
                                    color: AppStyles.greyColorDark,
                                  ),
                                ),
                              ),
                        checkoutController.couponApplied.value
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      checkoutController.removeCoupon();
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          'Coupon Discount'.tr,
                                          style: AppStyles.kFontGrey12w5
                                              .copyWith(color: Colors.green),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '${(checkoutController.couponDiscount.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                    style: AppStyles.kFontBlack14w5
                                        .copyWith(color: Colors.green),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: AppStyles.lightBlueColorAlt,
                          thickness: 2,
                          height: 2,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${checkoutController.totalQty} ' +
                                  'Item(s), Grand Total:'.tr +
                                  ' ' +
                                  '${(checkoutController.grandTotal.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        !checkoutController.couponApplied.value
                            ? Row(
                                children: [
                                  Flexible(
                                    child: Container(
                                      height: 45,
                                      child: TextField(
                                        autofocus: false,
                                        scrollPhysics:
                                            AlwaysScrollableScrollPhysics(),
                                        controller: checkoutController
                                            .couponCodeTextController,
                                        decoration: InputDecoration(
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          hintText:
                                              'Enter coupon/voucher code'.tr,
                                          fillColor:
                                              AppStyles.appBackgroundColor,
                                          filled: true,
                                          isDense: true,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  AppStyles.textFieldFillColor,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  AppStyles.textFieldFillColor,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  AppStyles.textFieldFillColor,
                                            ),
                                          ),
                                          hintStyle: AppStyles.kFontGrey12w5
                                              .copyWith(fontSize: 13),
                                        ),
                                        style: AppStyles.kFontBlack13w5,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      checkoutController.applyCoupon();
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: 100,
                                      height: 45,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          border: Border.all(
                                              color: AppStyles.greyColorDark)),
                                      child: Text(
                                        'Apply'.tr,
                                        textAlign: TextAlign.center,
                                        style: AppStyles.appFont.copyWith(
                                          color: AppStyles.greyColorDark,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  );
                }
              }
            }),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        if (checkoutController.isLoading.value) {
          return SizedBox.shrink();
        } else
          return Material(
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
                              if (checkoutController.isLoading.value) {
                                return Center(
                                  child: Container(),
                                );
                              } else {
                                if (checkoutController
                                            .checkoutModel.value.packages ==
                                        null ||
                                    checkoutController.checkoutModel.value
                                            .packages?.length ==
                                        0) {
                                  return Container();
                                } else {
                                  return Text(
                                    '${(checkoutController.grandTotal.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
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
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 3),
                          child: Text(
                            'VAT/TAX/GST included, where applicable'.tr,
                            style: AppStyles.kFontGrey12w5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 5),
                  PinkButtonWidget(
                    height: 40,
                    btnText: 'Proceed to Payment'.tr,
                    btnOnTap: () async {
                      if (addressController.addressCount.value == 0) {
                        SnackBars().snackBarWarning(
                            'Please Add Shipping and Billing Address'.tr);
                      } else {
                        checkoutController.orderData.addAll({
                          'customer_shipping_address':
                              addressController.shippingAddress.value.id,
                          'customer_billing_address':
                              addressController.billingAddress.value.id,
                          'customer_email': '${customerEmailCtrl.text}',
                          'customer_phone': '${customerPhoneCtrl.text}',
                          'customer_name':
                              '${addressController.shippingAddress.value.name ?? ""}',
                          'number_of_item': checkoutController.totalQty.value,
                          'number_of_package':
                              checkoutController.packageCount.value,
                          'shipping_total': checkoutController.shipping.value,
                          'discount_total':
                              checkoutController.discountTotal.value,
                          'tax_total': checkoutController.gstTotal.value,
                          'delivery_type':
                              checkoutController.deliveryType.value,
                          'pickup_location_id':
                              checkoutController.pickupId.value,
                          'sub_total': checkoutController.subTotal.value,
                          'grand_total': checkoutController.grandTotal.value,
                          'product_info': checkoutController.cartProducts,
                        });

                        if (checkoutController.couponDiscount.value > 0) {
                          checkoutController.orderData.addAll({
                            'coupon_id': checkoutController.couponId.value,
                            'coupon_amount':
                                checkoutController.couponDiscount.value,
                          });
                        }
                        log(jsonEncode(checkoutController.orderData)
                            .toString());
                        Get.to(() => GatewaySelection());
                      }
                    },
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          );
      }),
    );
  }
}

// ignore: must_be_immutable
class ShippingDropDown extends StatefulWidget {
  Shipping? shippingValue;
  final int? packageIndex;
  final double? price;

  final double? totalWeight;
  final List<Shipping>? shippings;
  Map? orderData;

  ShippingDropDown({
    this.shippingValue,
    this.packageIndex,
    this.shippings,
    this.price,
    this.totalWeight,
    this.orderData,
  });

  @override
  _ShippingDropDownState createState() => _ShippingDropDownState();
}

class _ShippingDropDownState extends State<ShippingDropDown> {
  final GeneralSettingsController currencyController =
      Get.put(GeneralSettingsController());

  final CheckoutController checkoutController = Get.put(CheckoutController());

  void addValueToMap<K, V>(Map<K, V> map, K key, V value) {
    map.update(key, (v) => value, ifAbsent: () => value);
  }

  double shippingCost2 = 0.0;

  double additionalShipping =0;

  String calculateArrival(shipmentTime) {
    var arr = shipmentTime;
    if (arr.contains('days')) {
      arr = arr.replaceAll(' days', '');
      arr = 'Est. Arrival Date: ' +
          CustomDate().formattedDateOnly(DateTime.now()
              .add(Duration(days: int.parse(arr.split('-').first)))) +
          '-' +
          CustomDate().formattedDateOnly(DateTime.now()
              .add(Duration(days: int.parse(arr.split('-').last))));
    } else {
      arr = 'Est. Arrival Time: ' + arr;
    }
    return arr;
  }

  @override
  void initState() {
    additionalShipping = 0.0;
    checkoutController.checkoutModel.value.packages?.forEach((key, value) {
      value.items?.forEach((CheckoutItem itemEl) {
        if (itemEl.productType == ProductType.PRODUCT) {
          additionalShipping  += itemEl.product?.sku?.additionalShipping;
        }
      });
    });

    if (widget.shippingValue?.costBasedOn == 'Price') {
      if (widget.price! > 0) {
        shippingCost2 = (widget.price! / 100) * (widget.shippingValue?.cost??0) + additionalShipping;
      }
    } else if (widget.shippingValue?.costBasedOn == 'Weight') {
      if ((widget.totalWeight ?? 0) > 0) {
        shippingCost2 = ((widget.totalWeight ?? 0) / 100) * (widget.shippingValue?.cost ?? 0) +
            additionalShipping;
      }
    } else {
      if ((widget.shippingValue?.cost ?? 0) > 0) {
        shippingCost2 = (widget.shippingValue?.cost ?? 0) + additionalShipping;
      }
    }

    final Map<dynamic, dynamic> shippingCostMap =
        checkoutController.orderData['shipping_cost'];

    final Map<dynamic, dynamic> deliveryDateMap =
        checkoutController.orderData['delivery_date'];

    final Map<dynamic, dynamic> shippingMethodMap =
        checkoutController.orderData['shipping_method'];
    addValueToMap(shippingCostMap, '${widget.packageIndex}', shippingCost2);
    addValueToMap(deliveryDateMap, '${widget.packageIndex}',
        calculateArrival(widget.shippingValue?.shipmentTime));
    addValueToMap(
        shippingMethodMap, '${widget.packageIndex}', widget.shippingValue?.id);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<Shipping>(
        elevation: 1,
        isExpanded: true,
        underline: Container(),
        value: widget.shippingValue,
        itemHeight: 80,
        items: widget.shippings?.map((e) {
          String basedOn = '';
          double shippingCost = 0.0;

          if (e.costBasedOn == "Price") {
            basedOn = "Based on Per Hundred".tr;
          } else if (e.costBasedOn == "Weight") {
            basedOn = "Based on Per 100 Gm".tr;
          } else {
            basedOn = "Based on Flat Rate".tr;
          }

          if (e.costBasedOn == 'Price') {
            if ((widget.price ?? 0) > 0) {
              shippingCost =
                  (((widget.price ?? 0) / 100) * (e.cost ?? 0)) + additionalShipping;
            }
          } else if (e.costBasedOn == 'Weight') {
            if ((widget.totalWeight ?? 0) > 0) {
              shippingCost =
                  (((widget.totalWeight ?? 0) / 100) * (e.cost ?? 0)) + additionalShipping;
            }
          } else {
            if ((e.cost ?? 0) > 0) {
              shippingCost = (e.cost ?? 0) + additionalShipping;
            }
          }

          return DropdownMenuItem<Shipping>(
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Row(
                  children: [
                    Text(
                      "${e.methodName}",
                      style: AppStyles.kFontBlack14w5.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    Text(
                      "${double.parse("${shippingCost * currencyController.conversionRate.value}").toStringAsFixed(2)}${currencyController.appCurrency.value}",
                      style: AppStyles.kFontBlack14w5.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "[${e.shipmentTime} - ($basedOn)]",
                  style: AppStyles.kFontBlack14w5,
                ),
                currencyController.vendorType.value == "single"
                    ? Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          "Minimum shopping amount (without shipping cost): ${double.parse("${(e.minimumShopping ?? 0) * currencyController.conversionRate.value}").toStringAsFixed(2)}${currencyController.appCurrency.value}",
                          style:
                              AppStyles.kFontBlack14w5.copyWith(fontSize: 12),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
            value: e,
          );
        }).toList(),
        onChanged: (Shipping? value) {
          if (currencyController.vendorType.value == "single") {
            if (!((value?.minimumShopping ?? 0) >= checkoutController.subTotal.value)) {
              setState(() {
                widget.shippingValue = value;

                checkoutController.selectedShipping[(widget.packageIndex ?? 0)] =
                    value!;

                double shippingCost = 0.0;

                if (widget.shippingValue?.costBasedOn == 'Price') {
                  if ((widget.price ?? 0) > 0) {
                    shippingCost =
                        ((widget.price ?? 0) / 100) * (widget.shippingValue?.cost ?? 0) + additionalShipping;
                  }
                } else if (widget.shippingValue?.costBasedOn == 'Weight') {
                  if ((widget.totalWeight ?? 0) > 0) {
                    shippingCost =
                        ((widget.totalWeight ?? 0) / 100) * (widget.shippingValue?.cost ?? 0) +
                            additionalShipping;
                  }
                } else {
                  if ((widget.shippingValue?.cost ?? 0) > 0) {
                    shippingCost =
                        (widget.shippingValue?.cost ?? 0) + additionalShipping;
                  }
                }

                final Map<dynamic, dynamic> shippingCostMap =
                    checkoutController.orderData['shipping_cost'];

                final Map<dynamic, dynamic> deliveryDateMap =
                    checkoutController.orderData['delivery_date'];

                final Map<dynamic, dynamic> shippingMethodMap =
                    checkoutController.orderData['shipping_method'];

                addValueToMap(
                    shippingCostMap, '${widget.packageIndex}', shippingCost);

                addValueToMap(deliveryDateMap, '${widget.packageIndex}',
                    calculateArrival(value.shipmentTime));

                addValueToMap(
                    shippingMethodMap, '${widget.packageIndex}', value.id);

                double totalShipping = 0.0;

                shippingCostMap.forEach((key, value) {
                  print(value);
                  totalShipping += double.parse(value.toString());
                });

                checkoutController.shipping.value =
                    totalShipping.toPrecision(2);

                checkoutController.grandTotal.value =
                    (checkoutController.subTotal.value +
                                checkoutController.shipping.value +
                                checkoutController.gstTotal.value)
                            .toPrecision(2) -
                        checkoutController.discountTotal.value;
              });
            }
          } else {
            setState(() {
              widget.shippingValue = value;

              checkoutController.selectedShipping[widget.packageIndex ?? 0] = value!;

              double shippingCost = 0.0;

              if (widget.shippingValue?.costBasedOn == 'Price') {
                if ((widget.price ?? 0) > 0) {
                  shippingCost =
                      ((widget.price ?? 0) / 100) * (widget.shippingValue?.cost ?? 0) +
                          additionalShipping;
                }
              } else if (widget.shippingValue?.costBasedOn == 'Weight') {
                if ((widget.totalWeight ?? 0) > 0) {
                  shippingCost =
                      ((widget.totalWeight ?? 0) / 100) * (widget.shippingValue?.cost ?? 0) +
                          additionalShipping;
                }
              } else {
                if ((widget.shippingValue?.cost ?? 0) > 0) {
                  shippingCost = (widget.shippingValue?.cost ?? 0) + additionalShipping;
                }
              }

              final Map<dynamic, dynamic> shippingCostMap =
                  checkoutController.orderData['shipping_cost'];

              final Map<dynamic, dynamic> deliveryDateMap =
                  checkoutController.orderData['delivery_date'];

              final Map<dynamic, dynamic> shippingMethodMap =
                  checkoutController.orderData['shipping_method'];

              addValueToMap(
                  shippingCostMap, '${widget.packageIndex}', shippingCost);

              addValueToMap(deliveryDateMap, '${widget.packageIndex}',
                  calculateArrival(value.shipmentTime));

              addValueToMap(
                  shippingMethodMap, '${widget.packageIndex}', value.id);

              double totalShipping = 0.0;

              shippingCostMap.forEach((key, value) {
                print(value);
                totalShipping += double.parse(value.toString());
              });

              checkoutController.shipping.value = totalShipping.toPrecision(2);

              checkoutController.grandTotal.value =
                  (checkoutController.subTotal.value +
                              checkoutController.shipping.value +
                              checkoutController.gstTotal.value)
                          .toPrecision(2) -
                      checkoutController.discountTotal.value;
            });
          }
        },
      ),
    );
  }
}
