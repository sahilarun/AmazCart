import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/controller/product_details_controller.dart';
import 'package:amazcart/controller/settings_controller.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/authentication/LoginPage.dart';
import 'package:amazcart/view/cart/AddToCartWidget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCartWidget extends StatefulWidget {
  final ProductModel? productModel;
  AddCartWidget({this.productModel});

  @override
  State<AddCartWidget> createState() => _AddCartWidgetState();
}

class _AddCartWidgetState extends State<AddCartWidget> {
  bool isLoading = false;

  final GeneralSettingsController _generalSettingsController =
      Get.put(GeneralSettingsController());

  double getPriceForCart() {
    return double.parse((widget.productModel?.hasDeal != null
            ? (widget.productModel?.hasDeal?.discount ?? 0) > 0
                ? _generalSettingsController.calculatePrice(widget.productModel ?? ProductModel())
                : _generalSettingsController.calculatePrice(widget.productModel ?? ProductModel())
            : _generalSettingsController.calculatePrice(widget.productModel ?? ProductModel()))
        .toString());
  }

  double getGiftCardPriceForCart() {
    dynamic productPrice = 0.0;
    if ((widget.productModel?.giftCardEndDate?.millisecondsSinceEpoch ?? 0) <
        DateTime.now().millisecondsSinceEpoch) {
      productPrice = widget.productModel?.giftCardSellingPrice;
    } else {
      if (widget.productModel?.discountType == 0 ||
          widget.productModel?.discountType == "0") {
        productPrice = ((widget.productModel?.giftCardSellingPrice ?? 0) -
            (((widget.productModel?.discount ?? 0) / 100) * (widget.productModel?.giftCardSellingPrice ?? 1.0)));
      } else {
        productPrice = ((widget.productModel?.giftCardSellingPrice ?? 0) - (widget.productModel?.discount ?? 0));
      }
    }
    return double.parse(productPrice.toString());
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? InkWell(
            onTap: null,
            child: Container(
              height: 30,
              width: 30,
              padding: EdgeInsets.all(6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppStyles.pinkColor,
                shape: BoxShape.circle,
              ),
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
              // width: 30.w,
              // height: 30.h,
            ),
          )
        : InkWell(
            onTap: () async {
              final LoginController loginController =
                  Get.put(LoginController());
              if (widget.productModel?.productType == ProductType.PRODUCT) {
                if (loginController.loggedIn.value) {
                  setState(() {
                    isLoading = true;
                  });

                  if (widget.productModel?.variantDetails?.length == 0) {
                    if (widget.productModel?.stockManage == 1) {
                      if ((widget.productModel?.skus?.first.productStock ?? 0) > 0) {
                        if (widget.productModel?.product?.minimumOrderQty >
                            widget.productModel?.skus?.first.productStock) {
                          SnackBars().snackBarWarning('No more stock'.tr);
                        } else {
                          Map data = {
                            'product_id': widget.productModel?.skus?.first.id,
                            'qty': 1,
                            'price': getPriceForCart(),
                            'seller_id': widget.productModel?.userId,
                            'product_type': 'product',
                            'checked': true,
                          };

                          print(data);

                          // return;
                          final CartController cartController =
                              Get.put(CartController());
                          await cartController.addToCart(data);
                        }
                      } else {
                        SnackBars().snackBarWarning('No more stock'.tr);
                      }
                    } else {
                      //** Not manage stock */

                      Map data = {
                        'product_id': widget.productModel?.skus?.first.id,
                        'qty': 1,
                        'price': getPriceForCart(),
                        'seller_id': widget.productModel?.userId,
                        'product_type': 'product',
                        'checked': true,
                      };

                      print(data);
                      // return;
                      final CartController cartController =
                          Get.put(CartController());
                      await cartController.addToCart(data);
                    }
                  } else {
                    await Get.bottomSheet(
                      AddToCartWidget(widget.productModel?.id),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      persistent: true,
                    );
                    Get.delete<ProductDetailsController>();
                  }
                  setState(() {
                    isLoading = false;
                  });
                } else {
                  Get.dialog(LoginPage(), useSafeArea: false);
                }
              } else {
                if (loginController.loggedIn.value) {
                  Map data = {
                    'product_id': widget.productModel?.id,
                    'qty': 1,
                    'price': getGiftCardPriceForCart(),
                    'seller_id': 1,
                    'shipping_method_id': 1,
                    'product_type': 'gift_card',
                  };
                  print(data);
                  final CartController cartController =
                      Get.put(CartController());
                  await cartController.addToCart(data);
                } else {
                  Get.dialog(LoginPage(), useSafeArea: false);
                }
              }
            },
            child: Container(
              height: 30,
              width: 30,
              padding: EdgeInsets.all(6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppStyles.pinkColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/icon_cart.png',
                height: 35,
                width: 35,
                color: Colors.white,
              ),
              // width: 30.w,
              // height: 30.h,
            ),
          );
  }
}
