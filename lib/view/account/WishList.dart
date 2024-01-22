import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/controller/my_wishlist_controller.dart';
import 'package:amazcart/controller/product_details_controller.dart';
import 'package:amazcart/model/MyWishListModel.dart';
import 'package:amazcart/model/NewModel/Product/GiftCardData.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/authentication/LoginPage.dart';
import 'package:amazcart/view/cart/AddToCartWidget.dart';
import 'package:amazcart/view/products/product/ProductDetails.dart';
import 'package:amazcart/view/seller/StoreHome.dart';
import 'package:amazcart/widgets/cart_icon_widget.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../config/config.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  final MyWishListController wishListController =
      Get.put(MyWishListController());
  final HomeController controller = Get.put(HomeController());
  final GeneralSettingsController _currencyController =
      Get.put(GeneralSettingsController());

  String calculateGiftCardPrice(WishListProduct productModel) {
    String amountText;

    if (productModel.giftcard!.discount! > 0) {
      ///percentage - type
      if (productModel.giftcard!.discountType == 0) {
        amountText = ((productModel.giftcard!.sellingPrice! -
                        ((productModel.giftcard!.discount! / 100) *
                            productModel.giftcard!.sellingPrice!)) *
                    _currencyController.conversionRate.value)
                .toString() +
            '${_currencyController.appCurrency.value}';
      } else {
        ///minus - type
        ///no variant
        amountText = ((productModel.giftcard!.sellingPrice! -
                        productModel.giftcard!.discount!) *
                    _currencyController.conversionRate.value)
                .toString() +
            '${_currencyController.appCurrency.value}';
      }
    } else {
      ///
      ///no discount
      ///
      amountText = (productModel.giftcard!.sellingPrice! *
                  _currencyController.conversionRate.value)
              .toString() +
          '${_currencyController.appCurrency.value}';
    }
    return amountText;
  }

  double getPriceForCart(ProductModel productModel) {
    return double.parse((productModel.hasDeal != null
            ? productModel.hasDeal!.discount! > 0
                ? _currencyController.calculatePrice(productModel)
                : _currencyController.calculatePrice(productModel)
            : _currencyController.calculatePrice(productModel))
        .toString());
  }

  double getGiftCardPriceForCart(GiftCardData productModel) {
    dynamic productPrice = 0.0;
    if (productModel.endDate!.millisecondsSinceEpoch <
        DateTime.now().millisecondsSinceEpoch) {
      productPrice = productModel.sellingPrice;
    } else {
      if (productModel.discountType == 0 || productModel.discountType == "0") {
        productPrice = (productModel.sellingPrice! -
            ((productModel.discount! / 100) * productModel.sellingPrice!));
      } else {
        productPrice = (productModel.sellingPrice! - productModel.discount!);
      }
    }
    return double.parse(productPrice.toString());
  }

  @override
  void initState() {
    wishListController.getAllWishList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        actions: [
          CartIconWidget(),
        ],
        title: Obx(() {
          if (wishListController.isLoading.value) {
            return Text(
              'My Wishlist'.tr,
              style: AppStyles.appFont.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppStyles.blackColor),
            );
          }
          return Text(
            'My Wishlist'.tr + ' (${wishListController.wishListCount.value})',
            style: AppStyles.appFont.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppStyles.blackColor,
            ),
          );
        }),
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
      body: Obx(() {
        if (wishListController.isLoading.value) {
          return Center(
            child: CustomLoadingWidget(),
          );
        } else {
          if (wishListController.wishListModel.value.products == null ||
              wishListController.wishListModel.value.products!.length == 0) {
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
            return ListView.builder(
                shrinkWrap: true,
                itemCount:
                    wishListController.wishListModel.value.products!.length,
                itemBuilder: (context, index) {
                  List<WishListProduct> value = wishListController
                      .wishListModel.value.products!.values
                      .elementAt(index);
                  return Column(
                    children: [
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            _currencyController.vendorType.value == "single"
                                ? SizedBox.shrink()
                                : InkWell(
                                    onTap: () {
                                      print(
                                          'Seller id: ${value[0].seller!.id}');
                                      Get.to(() => StoreHome(
                                            sellerId: value[0].seller!.id!,
                                          ));
                                    },
                                    child: Container(
                                      height: 40,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              value[0].seller!.firstName!,
                                              style: AppStyles.appFont.copyWith(
                                                color: AppStyles.blackColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            height: 70,
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            Column(
                              children:
                                  List.generate(value.length, (prodIndex) {
                                return GestureDetector(
                                  onTap: () {
                                    if (value[prodIndex].type ==
                                        ProductType.PRODUCT) {
                                      Get.to(
                                        () => ProductDetails(
                                          productID:
                                              value[prodIndex].product!.id,
                                        ),
                                      );
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        color: AppStyles.appBackgroundColor,
                                        thickness: 4,
                                        height: 0,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 65,
                                            width: 65,
                                            child: value[prodIndex].type ==
                                                    ProductType.PRODUCT
                                                ? Image.network(
                                                    AppConfig.assetPath +
                                                        '/' +
                                                        value[prodIndex]
                                                            .product!
                                                            .product!
                                                            .thumbnailImageSource!,
                                                  )
                                                : Image.network(
                                                    AppConfig.assetPath +
                                                        '/' +
                                                        value[prodIndex]
                                                            .giftcard!
                                                            .thumbnailImage!,
                                                  ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    value[prodIndex].type ==
                                                            ProductType.PRODUCT
                                                        ? value[prodIndex]
                                                            .product!
                                                            .productName!
                                                            .capitalizeFirst!
                                                        : value[prodIndex]
                                                            .giftcard!
                                                            .name!
                                                            .capitalizeFirst!,
                                                    style: AppStyles.appFont
                                                        .copyWith(
                                                      color:
                                                          AppStyles.blackColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '${value[prodIndex].type == ProductType.PRODUCT ? _currencyController.calculatePrice(value[prodIndex].product!) : calculateGiftCardPrice(value[prodIndex])}',
                                                        style: AppStyles.appFont
                                                            .copyWith(
                                                          color: AppStyles
                                                              .pinkColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        value[prodIndex].type ==
                                                                ProductType
                                                                    .PRODUCT
                                                            ? value[prodIndex]
                                                                        .product!
                                                                        .discount! >
                                                                    0
                                                                ? '(' +
                                                                    'Price dropped'
                                                                        .tr +
                                                                    ')'
                                                                : ''
                                                            : value[prodIndex]
                                                                        .giftcard!
                                                                        .discount! >
                                                                    0
                                                                ? '(' +
                                                                    'Price dropped'
                                                                        .tr +
                                                                    ')'
                                                                : '',
                                                        style: AppStyles.appFont
                                                            .copyWith(
                                                          color: AppStyles
                                                              .darkBlueColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    value[prodIndex].type ==
                                                            ProductType.PRODUCT
                                                        ? _currencyController
                                                            .calculateMainPrice(
                                                                value[prodIndex]
                                                                    .product!)
                                                        : _currencyController
                                                            .calculateWishListGiftcardPrice(
                                                                value[prodIndex]
                                                                    .giftcard!),
                                                    style: AppStyles.appFont
                                                        .copyWith(
                                                      color: AppStyles
                                                          .greyColorDark,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      decorationColor:
                                                          AppStyles.pinkColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            print(
                                                                '${URLs.API_URL}/wishlist');
                                                            print(
                                                                'product id ::: ${value[prodIndex].id}');
                                                            wishListController
                                                                .deleteWishListProduct(
                                                                    value[index]
                                                                        .product!
                                                                        .id);
                                                          },
                                                          child: Container(
                                                              height: 30,
                                                              child: SvgPicture
                                                                  .asset(
                                                                      'assets/images/wishlist_delete.svg')),
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            final LoginController
                                                                loginController =
                                                                Get.put(
                                                                    LoginController());
                                                            if (value[prodIndex]
                                                                    .type ==
                                                                ProductType
                                                                    .PRODUCT) {
                                                              if (loginController
                                                                  .loggedIn
                                                                  .value) {
                                                                if (value[prodIndex]
                                                                        .product!
                                                                        .variantDetails!
                                                                        .length ==
                                                                    0) {
                                                                  if (value[prodIndex]
                                                                          .product!
                                                                          .stockManage ==
                                                                      1) {
                                                                    if (value[prodIndex]
                                                                            .product!
                                                                            .skus!
                                                                            .first
                                                                            .productStock! >
                                                                        0) {
                                                                      if (value[prodIndex]
                                                                              .product!
                                                                              .product!
                                                                              .minimumOrderQty >
                                                                          value[prodIndex]
                                                                              .product!
                                                                              .skus!
                                                                              .first
                                                                              .productStock) {
                                                                        SnackBars()
                                                                            .snackBarWarning('No more stock'.tr);
                                                                      } else {
                                                                        Map data =
                                                                            {
                                                                          'product_id': value[prodIndex]
                                                                              .product!
                                                                              .skus!
                                                                              .first
                                                                              .id,
                                                                          'qty':
                                                                              1,
                                                                          'price':
                                                                              getPriceForCart(value[prodIndex].product!),
                                                                          'seller_id': value[prodIndex]
                                                                              .product!
                                                                              .userId,
                                                                          'product_type':
                                                                              'product',
                                                                          'checked':
                                                                              true,
                                                                        };

                                                                        print(
                                                                            data);

                                                                        // return;
                                                                        final CartController
                                                                            cartController =
                                                                            Get.put(CartController());
                                                                        await cartController
                                                                            .addToCart(data)
                                                                            .then((value) {
                                                                          if (value) {
                                                                            SnackBars().snackBarSuccess('Card Added successfully'.tr);
                                                                          }
                                                                        });
                                                                      }
                                                                    } else {
                                                                      SnackBars()
                                                                          .snackBarWarning(
                                                                              'No more stock'.tr);
                                                                    }
                                                                  } else {
                                                                    //** Not manage stock */

                                                                    Map data = {
                                                                      'product_id': value[
                                                                              prodIndex]
                                                                          .product!
                                                                          .skus!
                                                                          .first
                                                                          .id,
                                                                      'qty': 1,
                                                                      'price': getPriceForCart(
                                                                          value[prodIndex]
                                                                              .product!),
                                                                      'seller_id': value[
                                                                              prodIndex]
                                                                          .product!
                                                                          .userId,
                                                                      'product_type':
                                                                          'product',
                                                                      'checked':
                                                                          true,
                                                                    };

                                                                    print(data);
                                                                    // return;
                                                                    final CartController
                                                                        cartController =
                                                                        Get.put(
                                                                            CartController());
                                                                    await cartController
                                                                        .addToCart(
                                                                            data)
                                                                        .then(
                                                                            (value) {
                                                                      if (value) {
                                                                        Future.delayed(
                                                                            Duration(seconds: 3),
                                                                            () {
                                                                          print(
                                                                              Get.isBottomSheetOpen);
                                                                          Get.back(
                                                                              closeOverlays: false);
                                                                        });
                                                                      }
                                                                    });
                                                                  }
                                                                } else {
                                                                  await Get
                                                                      .bottomSheet(
                                                                    AddToCartWidget(
                                                                      value[prodIndex]
                                                                          .product!
                                                                          .id,
                                                                    ),
                                                                    isScrollControlled:
                                                                        true,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    persistent:
                                                                        true,
                                                                  );
                                                                  Get.delete<
                                                                      ProductDetailsController>();
                                                                }
                                                              } else {
                                                                Get.dialog(
                                                                    LoginPage(),
                                                                    useSafeArea:
                                                                        false);
                                                              }
                                                            } else {
                                                              if (loginController
                                                                  .loggedIn
                                                                  .value) {
                                                                Map data = {
                                                                  'product_id':
                                                                      value[prodIndex]
                                                                          .giftcard!
                                                                          .id,
                                                                  'qty': 1,
                                                                  'price': getGiftCardPriceForCart(
                                                                      value[prodIndex]
                                                                          .giftcard!),
                                                                  'seller_id':
                                                                      1,
                                                                  'shipping_method_id':
                                                                      1,
                                                                  'product_type':
                                                                      'gift_card',
                                                                };
                                                                print(data);
                                                                final CartController
                                                                    cartController =
                                                                    Get.put(
                                                                        CartController());
                                                                await cartController
                                                                    .addToCart(
                                                                        data);
                                                              } else {
                                                                Get.dialog(
                                                                    LoginPage(),
                                                                    useSafeArea:
                                                                        false);
                                                              }
                                                            }
                                                          },
                                                          child: Container(
                                                              height: 30,
                                                              width: 30,
                                                              child: SvgPicture
                                                                  .asset(
                                                                      'assets/images/wishlist_cart.svg')),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                });
          }
        }
      }),
    );
  }
}
